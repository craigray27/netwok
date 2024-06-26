# -*- coding: utf-8 -*-
"""
Created on Thu Aug 25 23:25:21 2022

@author: 15559
"""
import numpy as np

import math

from ge.classify import read_node_label, Classifier
from ge import DeepWalk
from sklearn.linear_model import LogisticRegression

import matplotlib.pyplot as plt
import networkx as nx
from sklearn.manifold import TSNE
import random

# 初始化零号病人
def patient_zero(N,num):
    Infecters = random.sample(range(N),num)
    InfectStatus = np.zeros(N,int)            
    for i in Infecters:
        InfectStatus[i] = 1                   
    return InfectStatus

# 感染过程
def infect(A, S, beta, gamma=0):        
    N = len(A)
    for i in range(N):
        if S[i] == 1 and random.random() <= gamma:
            S[i] = 2
 
    if sum(S==1) < N/2:                 
        for i in range(N):               
            if S[i] == 1:
                for j in range(N):
                    if A[i][j] == 1 and S[j] == 0 and random.random() <= beta:
                        S[j] = 1        
    else:
        for i in range(N):
            if S[i] == 0:
                for j in range(N):
                    if A[i][j] == 1 and S[j] == 1 and random.random() <= beta:
                        S[i] = 1
    return S

# 网络中的 SIR 过程
def SIR(A, N0, Beta, Gamma, plot=True):
    N = len(A)
    S = patient_zero(N, N0)
    
    result = []
    time = 0
    while True:
    
        result.append((sum(S==0), sum(S==1), sum(S==2)))
        if sum(S==1) == N or sum(S==1) == 0 or time >10:
            break
        Beta=Beta-time*0.04
        Gamma=Gamma+time*0.004
        S = infect(A, S, Beta, Gamma) 
        time += 1
    
    return np.array(result)

def small_world(N, d, a):
   A = np.zeros((N, N))
   for i in range(N):
        if i==50 or i==100 :
            t = 0
            d=60
            while t < (d/2):
              A[i][i-(t+1)] = 1
              A[i-(t+1)][i] = 1
              t += 1
            d=5;
        else:
            t = 0
            while t < (d/2):
              A[i][i-(t+1)] = 1
              A[i-(t+1)][i] = 1
              t += 1
              
   for i in range(N):  
        t = 0
        while t < (N/2):
         if i==50 or i==100 :
            if A[i][i-(t+1)] == 1:        
                if random.random() < a:         
                    A[i][i-(t+1)] = 0                   
                    A[i-(t+1)][i] = 0
                    target = random.randint(0,(N-1))
                    while A[i][target] == 1 or target == i: 
                        target = random.randint(0,(N-1))
                    A[i][target] = 1                    
                    A[target][i] = 1
         else:
             if A[i][i-(t+1)] == 1:        
                if random.random() < a:         
                    A[i][i-(t+1)] = 0                   
                    A[i-(t+1)][i] = 0
                    target = random.randint(0,(N-1))
                    while A[i][target] == 1 or target == i: 
                        target = random.randint(0,(N-1))
                    A[i][target] = 1                    
         t += 1
   return A

N=100
d=15
z=[]
D=[]
f=[]

for i in range(50):
  a=0.01+0.02*i
  A = small_world(N,d,a)  
  g = nx.from_numpy_matrix(A,create_using=nx.DiGraph())
  z.append(nx.average_clustering(g))
  D.append(nx.average_shortest_path_length(g))
  for j in range(100):
   if 1:
        i=0
        result = SIR(A,10,0.3,0.1,plot=True)
        k=len(result)
        i=i+result[k-1,1]/N
  f.append(i/100)
