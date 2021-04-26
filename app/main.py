import logging

from app.core.app import create_app
from app.core.cfg import cfg

__author__ = 'kclark'

logger = logging.getLogger(__name__)

app = create_app()

def run_app():
    logger.info('App Server Initializing')

    app.run(host='localhost', port=5000, threaded=True, debug=cfg.debug_mode)

    logger.info('App Server Running')


if __name__ == '__main__':
    run_app()
