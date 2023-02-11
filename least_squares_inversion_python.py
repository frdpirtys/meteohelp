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
	print('m_est:', m_est)
	return m_est


#%%

n=len(sdT)


G = np.ones((n, 2))
d = np.zeros((n,1))

G[:,0]=Tm
d[:,0]=sdT

#%%

m_est = least_squares(G, d)