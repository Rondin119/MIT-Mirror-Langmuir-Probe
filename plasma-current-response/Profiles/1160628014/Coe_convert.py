import matplotlib.pyplot as plt
import numpy as np
import csv

########################################################################
# Function to read an input csv file
def ReadCSVfile(fileName):
    valArray = []
    with open(fileName, newline='') as csvfile:
        valreader = csv.reader(csvfile, delimiter=',')
        for row in valreader:
            for col in row:
                valArray.append(float(col))

    return valArray
#########################################################################

############################################################################
# Function to write COE file
def WriteCoe(dataArray, fileName):
    with open(fileName, "w") as lut_file:
        lut_file.write("memory_initialization_radix=10;\n")
        lut_file.write("memory_initialization_vector=")
        for val in dataArray:
            lut_file.write("%i " % val)
###########################################################################

iSat = ReadCSVfile("Isat.csv")
Temp = ReadCSVfile("Te.csv")
vFloat = ReadCSVfile("Vf.csv")
Time = ReadCSVfile("Time.csv")

timeVal = 0
usArray = []
count = 0
for i in range(len(Time)):
    if Time[i] != timeVal:
        timeVal = Time[i]
    if Time[i] == timeVal:
        if count == 0:
            usArray.append(i)
            count += 1
        elif count == 2:
            count = 0
        else:
            count += 1

newTime = np.array(Time)[usArray]
newTemp = np.array(Temp)[usArray]
newiSat = np.array(iSat)[usArray]
newvFloat = np.array(vFloat)[usArray]

print(len(newiSat), len(newTemp), len(newvFloat), len(newTime))

indStart = np.where(newTime > 0.9858)[0][0]

newTime   = newTime[indStart:indStart+8191]
newTemp   = newTemp[indStart:indStart+8191]
newiSat   = newiSat[indStart:indStart+8191]/1e4
newvFloat = newvFloat[indStart:indStart+8191]/1e1

print(len(newiSat), len(newTemp), len(newvFloat), len(newTime))

plt.plot(newTime, newTemp, 'b')
plt.plot(newTime, newvFloat, 'r')
plt.plot(newTime, newiSat, 'y')
plt.show()

WriteCoe(newTemp, "Temp.coe")
WriteCoe(newiSat, "iSat.coe")
WriteCoe(newvFloat, "vFloat.coe")



