# -*- coding: utf-8 -*-
"""
Created on Wed Jan 18 14:28:30 2023

@author: pedro
"""

import numpy as np


sdT = np.loadtxt('D:/Dropbox/ERA_40_Test/All_sdT_vector.csv', skiprows=1, delimiter='\n') 

Tm  = np.loadtxt('D:/Dropbox/ERA_40_Test/All_Tm_vector.csv', skiprows=1, delimiter='\n')


def least_squares(G, d):	# G and d must have the same amount of rows
	""" Calculate and return least-squares solution."""
	GtG = G.T @ G
	m_est = np.linalg.inv(GtG) @ G.T @ d
	print('Least squares solution >> m_est:', m_est)
	return m_est


def weighted_least_squares(G, d, Wd):	# G and d must have the same amount of rows
	""" Calculate and return a data weighted least-squares solution."""
	GtG = G.T @ Wd.T @ Wd @ G
	m_est2 = np.linalg.inv(GtG) @ G.T @ Wd.T @ Wd @ d
    #print('m_est2:')
	return m_est2


#%%

"cortar datos a 10 años, para test"

#magic_number = 312 * 12 * 10  #  = n celdas (312) * meses x año (12) * n años

#sdT=sdT[0:magic_number]

#Tm=Tm[0:magic_number]


#%% 
n=len(sdT)


G = np.ones((n, 2))
d = np.zeros((n,1))

G[:,0]=Tm
d[:,0]=sdT

Wd=np.identity(n)

#%% poner valores de desviacion estandar diviendo a 1 en diagonal de weighting matrix, value = 1/sdT

for i in range(0,n):
    Wd[i,i]=1/sdT[i]    
    


#%%

m_est = least_squares(G, d)

m_est2 = weighted_least_squares(G, d, Wd)


np.savetxt('least_squares_solution.csv', m_est, fmt='%.18e', delimiter=';', newline='\n', header='m_est_LeastSquares', footer='', comments='# ', encoding=None)

np.savetxt('weighted_least_squares_solution.csv', m_est2, fmt='%.18e', delimiter=';', newline='\n', header='m_est_weighted_LeastSquares', footer='', comments='# ', encoding=None)