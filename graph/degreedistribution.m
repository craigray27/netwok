clear;clc;
N=500;
K=6;
p=[0.1,0.2,0.4,0.6,0.9,1];
degree=zeros(N-1,length(p));

%初始化，生成含N个节点的环状最近邻耦合网络的邻接矩阵，其中每个节点与其左右相邻的各K/2个节点相邻
adj=zeros(N,N);
for i=1:K/2
    adj=adj+diag(ones(1,N-i),i);
    adj(i,N-K/2+i:N)=1;
end
adj=adj+adj'; 
A_conserve=adj;%保存该邻接矩阵，然后我们根据边的重连一直更新该邻接矩阵
node=zeros(K*N/2,2);%用该矩阵储存初始状态所有的边的两个节点
t=1;%临时变量temp
for i=1:N
    for j=i+1:N
        if(adj(i,j)==1)
            node(t,1)=i;node(t,2)=j;%记录最开始的所有边的两个节点
            t=t+1;
        end
    end
end
for m=1:length(p)
    adj=A_conserve;
    for n=1:K*N/2 %重新布线
        if(rand(1,1)<p(m))
            while 1
                newvertex=randperm(N,1);%生成新节点，randperm(N,1)是生成1~N中的随机整数
                if(randperm(2,1)==1 && newvertex~=node(n,2) && adj(newvertex,node(n,2))~=1)%换掉第一个节点、新节点不能是第二个节点(否则有环)、新节点不能是已经有边的结点(否则有重边)
                    adj(node(n,1),node(n,2))=0;
                    adj(node(n,2),node(n,1))=0;
                    adj(newvertex,node(n,2))=1;
                    adj(node(n,2),newvertex)=1;
                    break
                elseif(randperm(2,1)==2 && newvertex~=node(n,1) && adj(node(n,1),newvertex)~=1)%换掉第二个节点、新节点不能是第一个节点(否则有环)、新节点不能是已经有边的结点(否则有重边)
                    adj(node(n,1),node(n,2))=0;
                    adj(node(n,2),node(n,1))=0;
                    adj(node(n,1),newvertex)=1;
                    adj(newvertex,node(n,1))=1;
                    break
                end
            end
        end
    end
    for i=1:N-1
        count=0;
        for j=1:N
            if(sum(adj(:,j))==i)
                count=count+1;%计算度为i的结点的个数
            end
        end
        degree(i,m)=count;
    end
end
x=1:N-1;
semilogy(x,degree(:,1)/sum(degree(:,1)),'bo-');%semilogy:y为对数刻度，x为线性刻度;semilogx:x为对数刻度，y为线性刻度
hold on
semilogy(x,degree(:,2)/sum(degree(:,2)),'rs-');
hold on
semilogy(x,degree(:,3)/sum(degree(:,3)),'gd-');
hold on
semilogy(x,degree(:,4)/sum(degree(:,4)),'k^-');
hold on
semilogy(x,degree(:,5)/sum(degree(:,5)),'y+-');
hold on
semilogy(x,degree(:,6)/sum(degree(:,6)),'*-');
hold on
y=1:20;
px=poisspdf(y,6);
plot(y,px);%参数为6时的泊松分布
hold on
legend('p=0,1','p=0.2','p=0.4','p=0.6','p=0.9','p=1','Poisson');
title('DegreeDistribution');
xlabel('k');ylabel('p(k)');