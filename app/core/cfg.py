import datetime as dt
import os
from dataclasses import dataclass

__author__ = 'kclark'

@dataclass()
class Configuration:
    app_env: str
    app_start_time: dt.datetime
    debug_mode: bool

# Create global singleton for configuration settings
cfg = Configuration(
    app_env=os.getenv('APP_ENV', 'dev'),
    app_start_time=dt.datetime.utcnow(),
    debug_mode=bool(os.getenv('FLASK_DEBUG', False))
)
