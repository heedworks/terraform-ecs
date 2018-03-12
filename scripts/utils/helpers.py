import os
import sys


def get_env_var(key, default=None):
    if key in os.environ:
        return os.environ[key]
    else:
        return default


def get_arg(index, default=None):
    if len(sys.argv) > index:
        return sys.argv[index]
    else:
        return default
