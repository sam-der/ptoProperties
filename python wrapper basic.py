import matlab.engine
from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt

eng = matlab.engine.start_matlab()
S = np.linspace(10000000, 80000000, num = 4)
D = np.linspace(10000000, 50000000, num = 4)
P = np.linspace(10, 10000, num = 4)

def pto(SDP):
    powerOut = eng.ptoProperties(SDP, nargout=1)
    return powerOut

outputs = []
sInd = []
dInd = []
pInd = []
for s in S:
    for d in D:
        for p in P:
            powerOut = pto([s, d, p])
            sInd.append(s)
            dInd.append(d)
            pInd.append(p)
            outputs.append(powerOut)

minVal = min(outputs)
minValIndex = outputs.index(min(outputs))
maxVal = max(outputs)
maxValIndex = outputs.index(max(outputs))
print(minValIndex)

S, D, P = np.meshgrid(S, D, P)

# Flatten all inputs
S = S.flatten()
D = D.flatten()
P = P.flatten()

print(S, len(S), len(outputs))

# Create a 3D scatter plot
fig = plt.figure()
ax = fig.add_subplot(projection='3d')

# Scatter plot with color-coded data
sc = ax.scatter(S, D, P, c=outputs, edgecolor = 'k')

# Add a color bar
plt.colorbar(sc, label='Output Data')

plt.show()

#plotting
#full matrix
#put in repository

#start optimizing
    #test on one combination of values

#numpy.linspace
#revise matlab
#write loop sweep to python

# github
# lines 18-19 turn into function
# write outside of function, call instead of 18-19
# denser sweep w plot
# non-zero parameters for constraints
# try to optimize