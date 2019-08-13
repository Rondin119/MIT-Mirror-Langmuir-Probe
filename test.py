#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
import os
import time

from PCS import PCS
from koheron import connect

host = os.getenv('HOST', 'rp4')
client = connect(host, name='plasma-current-response')
driver = PCS(client)




driver.set_Temperature(500)
driver.set_ISat(2)
driver.set_Vfloating(0)
driver.set_Resistence(100)
driver.set_Switch(1)

