import unittest
import requests

class TestHealth(unittest.TestCase):
    def setUp(self):
        self.api_url = "http://localhost:6400"

    def test_health(self):
        response = requests.get(f"{self.api_url}/api/v1/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {'status': 'ok'})

if __name__ == '__main__':
    unittest.main()