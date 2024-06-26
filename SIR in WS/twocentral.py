
import numpy as np
import random
import matplotlib.pyplot as plt
#matplotlib inline
import networkx as nx

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
    
    if plot:
        g = nx.from_numpy_matrix(A,create_using=nx.DiGraph())
        pos  = nx.kamada_kawai_layout(g)
        nodesize = []
        maxsize = 10
        minsize = 1
        maxdegree = np.max(np.sum(A,axis=0))
        mindegree = np.min(np.sum(A,axis=0))
        if maxdegree == mindegree:
            nodesize = [minsize for i in range(len(A))]
        else:
            for node in g:
                size = (np.sum(A[node]) - mindegree)/(maxdegree-mindegree)*(maxsize-minsize)+minsize 
                nodesize.append(size)

    result = []
    time = 0
    while True:
    
        result.append((sum(S==0), sum(S==1), sum(S==2)))
        if sum(S==1) == N or sum(S==1) == 0 or time >12:
         if plot:
            cmap = ['g', 'r', 'b']
            colors = [cmap[s] for s in S]
            plt.figure(figsize=(20,20))
            
            nx.draw_networkx_nodes(g, pos=pos , with_labels=True , node_color=colors, alpha=0.6)
            nx.draw_networkx_edges(g, pos=pos , with_labels=True , width=0.3 , alpha=0.3)
            plt.title('time = {}'.format(time))
            #plt.savefig('{}.png'.format(str(time).zfill(4)))
            plt.show()
            plt.pause(0.1)
            break
        Beta=Beta-time*0.04
        Gamma=Gamma+time*0.004
        S = infect(A, S, Beta, Gamma) 
        time += 1
    
    return np.array(result)

def small_world(N, d, a):
   A = np.zeros((N, N))
   for i in range(N):
        if i==50 or i==100 or i==150 or i==200 or i==300:
            t = 0
            d=150
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
         if i==50 or i==100  or i==200:
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
# main     
random.seed(20)
N=500
d=50
a=0.2
A = small_world(N,d,a)  
if 1:
        g = nx.from_numpy_matrix(A,create_using=nx.DiGraph())
        pos  = nx.kamada_kawai_layout(g)
        nodesize = []
        maxsize = 10
        minsize = 1
        maxdegree = np.max(np.sum(A,axis=0))
        mindegree = np.min(np.sum(A,axis=0))
        if maxdegree == mindegree:
            nodesize = [minsize for i in range(len(A))]
        else:
            for node in g:
                size = (np.sum(A[node]) - mindegree)/(maxdegree-mindegree)*(maxsize-minsize)+minsize 
                nodesize.append(size)
                


z=nx.average_clustering(g)
d=nx.average_shortest_path_length(g)
print(z,d)



