import unittest
import requests

API_BASE_URL = "http://localhost:6400/api/v1"

TEST_TODO = {
    "id": 1,
    "title": "Watch CSSE6400 Lecture",
    "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
    "completed": True,
    "deadline_at": "2023-02-27T00:00:00",
    "created_at": "2023-02-20T00:00:00",
    "updated_at": "2023-02-20T00:00:00"
}


class TestTodoAPI(unittest.TestCase):
    def test_health(self):
        response = requests.get(f"{API_BASE_URL}/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"status": "ok"})

    def test_get_todos(self):
        response = requests.get(f"{API_BASE_URL}/todos")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), [TEST_TODO])

    def test_get_todo_by_id(self):
        response = requests.get(f"{API_BASE_URL}/todos/1")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), TEST_TODO)

    def test_post_todo(self):
        response = requests.post(f"{API_BASE_URL}/todos", json=TEST_TODO)
        self.assertEqual(response.status_code, 201)
        self.assertEqual(response.json(), TEST_TODO)

    def test_put_todo(self):
        response = requests.put(f"{API_BASE_URL}/todos/1", json=TEST_TODO)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), TEST_TODO)

    def test_delete_todo(self):
        response = requests.delete(f"{API_BASE_URL}/todos/1")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), TEST_TODO)

if __name__ == '__main__':
    unittest.main()