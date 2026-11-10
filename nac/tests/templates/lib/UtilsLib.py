# Copyright: (c) 2026, Daniel Schmidt <danischm@cisco.com>

"""Keywords of the tests shipped with the Terraform module."""

import ast
import os
import time

import jmespath
import requests
from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.Collections import Collections

__version__ = "0.1.0"


class UtilsLib:
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    GET_RETRIES = 6
    MAX_REDIRECTS = 5
    TRANSIENT_STATUS_CODES = (429, 500, 502, 503, 504)

    def __init__(self):
        self.BuiltIn = BuiltIn()
        self.Collections = Collections()
        self._session = None
        self._base_url = os.environ.get(
            "MERAKI_BASE_URL", "https://api.meraki.com/api/v1"
        ).rstrip("/")

    def _get_session(self):
        if self._session is None:
            api_key = os.environ.get("MERAKI_API_KEY")
            if not api_key:
                raise RuntimeError("Environment variable MERAKI_API_KEY is not set")
            self._session = requests.Session()
            self._session.headers.update(
                {"Authorization": f"Bearer {api_key}", "Accept": "application/json"}
            )
        return self._session

    def _get(self, url):
        """GET a URL, retrying rate limited (429) and transient server errors.

        Redirects are followed here, as requests drops the Authorization header
        when a redirect points to another host.
        """
        attempt = 0
        redirects = 0
        while True:
            response = self._get_session().get(url, timeout=60, allow_redirects=False)
            if response.is_redirect and redirects < self.MAX_REDIRECTS:
                redirects += 1
                url = response.headers["Location"]
                continue
            if (
                response.status_code in self.TRANSIENT_STATUS_CODES
                and attempt < self.GET_RETRIES
            ):
                attempt += 1
                try:
                    delay = float(response.headers["Retry-After"])
                except (KeyError, ValueError):
                    delay = min(2**attempt, 30)
                logger.debug(
                    f"GET {url} returned {response.status_code} (attempt {attempt}/{self.GET_RETRIES}), retrying in {delay}s"
                )
                time.sleep(delay)
                continue
            response.raise_for_status()
            return response

    @keyword("Meraki Get")
    def meraki_get(self, path):
        """
        Read a Dashboard API path (relative to MERAKI_BASE_URL) and return the
        JSON response. Paginated lists are read completely.
        """
        response = self._get(f"{self._base_url}/{path.lstrip('/')}")
        data = response.json()
        while isinstance(data, list) and "next" in response.links:
            response = self._get(response.links["next"]["url"])
            data += response.json()
        return data

    @keyword("Meraki Get Organization Id")
    def meraki_get_organization_id(self, name):
        """Return the ID of the organization with the given name."""
        for organization in self.meraki_get("/organizations"):
            if organization.get("name") == name:
                return organization["id"]
        raise AssertionError(f"Organization '{name}' not found")

    # --- JMESPath assertion keywords ---
    #
    # An empty expected value (an attribute that is not configured) is not
    # checked.

    def _jmespath_search(self, data, expression):
        """Execute a JMESPath query and return the raw result."""
        try:
            return jmespath.search(expression, data)
        except Exception as e:
            raise RuntimeError(
                f"JMESPath query failed: {expression}\nError: {str(e)}"
            ) from e

    @keyword("Should Be Equal Value Json String")
    def should_be_equal_value_json_string(self, json_data, json_path, value=""):
        if not value:
            return
        r_value = self._jmespath_search(json_data, json_path)
        r_value = "" if r_value is None else str(r_value)
        self.BuiltIn.should_be_equal_as_strings(r_value, value)

    @keyword("Should Be Equal Value Json List")
    def should_be_equal_value_json_list(self, json_data, json_path, value=""):
        """
        Compare a list ignoring order and duplicates. The expected value is a
        list or its Python literal, such as a list rendered by Jinja.
        """
        if not value:
            return
        if isinstance(value, str):
            value = ast.literal_eval(value)
        r_value = self._jmespath_search(json_data, json_path)
        if r_value is None:
            r_value = []
        elif not isinstance(r_value, list):
            r_value = [r_value]
        self.Collections.lists_should_be_equal(sorted(set(r_value)), sorted(set(value)))
