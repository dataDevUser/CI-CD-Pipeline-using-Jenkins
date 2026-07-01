from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.get_json()["message"] == "Hello, Jenkins CI/CD Pipeline!"


def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json()["status"] == "ok"


def test_add():
    client = app.test_client()
    response = client.get("/add/2/3")
    assert response.status_code == 200
    assert response.get_json()["result"] == 5
