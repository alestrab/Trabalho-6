import numpy as np

data = np.loadtxt('teste.txt',dtype=str)
new_data = []
for i in range(0,len(data)):
    new_data.append('RAM['+str(i)+'] <= 32\'h' + data[i] + ';')

filename='ram-hex.txt'
np.savetxt(filename,new_data,fmt='%s')