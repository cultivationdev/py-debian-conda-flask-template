import datetime as dt
import json

from app.core.cfg import cfg

__author__ = 'kclark'


def test_api_liveness_endpoint_response_status(client):
    # act on test
    resp = client.get('/api/liveness')

    # assert test output
    assert resp.status == '200 OK'


def test_api_liveness_endpoint_response_data(client):
    # act on test
    resp = client.get('/api/liveness')
    data = json.loads(resp.data)

    # assert test output
    assert isinstance(data, dict)
    assert data.get('app_env') == cfg.app_env
    assert data.get('app_start_time') == cfg.app_start_time.isoformat()
    assert dt.datetime.strptime(data.get('response_time'), '%Y-%m-%dT%H:%M:%S.%f') > cfg.app_start_time
    assert dt.datetime.strptime(data.get('response_time'), '%Y-%m-%dT%H:%M:%S.%f') < dt.datetime.utcnow()
