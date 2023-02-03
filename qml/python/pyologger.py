#!/usr/bin/env python3

import pyotherside as pyo


class PyoLogger:

    def log(self, message):
        pyo.send(message)
