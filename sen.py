import numpy as np
from math import pi
import matplotlib.pyplot as plt
N = 20
vec=[]
for i in range(0,N):
    vec.append(round(np.sin((2*pi)*20*i/360)*7 + 7))

for x in vec:
    print(x)
plt.scatter(np.arange(N),vec)
plt.show()
    
