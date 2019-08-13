# Python script to generate the saturation current look up table

import numpy as np
import matplotlib.pyplot as plt

dataArray = []

xVal = np.linspace(-8, 8, num=2**14)

def lutFunction(x):
    exp = np.exp(x)
    func = exp - 1
    if x > -1 and x < 1:
        func = func*(2**6)
    elif x >= 1 and x < 2:
        func = func*(2**6)
    elif x >= 2 and x < 3:
        func = func*(2**6)
    elif x >= 3 and x < 4:
        func = func*(2**6)
    elif x >= 4 and x < 5:
        func = func*(2**1)
    elif x >= 5 and x < 6:
        func = func*(2**1)
    elif x >= 6 and x < 7:
        func = func*(2**1)
    elif x >= 7:
        func = func*(2**1)
    else:
        func = func*(2**13)

    return int(round(func))

for i in range(len(xVal)):
    dataArray.append(lutFunction(xVal[i]))

#dataArray = np.array(dataArray)

plt.plot(xVal, dataArray)
plt.show()

with open("current_lut.coe", "w") as lut_file:
    lut_file.write("memory_initialization_radix=10;\n")
    lut_file.write("memory_initialization_vector=")
    for val in dataArray:
        lut_file.write("%i " % val)
        
