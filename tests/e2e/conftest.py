import pytest

from app.main import app

__author__ = 'kclark'


@pytest.fixture()
def client():
    app.config['TESTING'] = True

    return app.test_client()
