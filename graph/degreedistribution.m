clear;clc;
N=500;
K=6;
p=[0.1,0.2,0.4,0.6,0.9,1];
degree=zeros(N-1,length(p));

%��ʼ�������ɺ�N���ڵ�Ļ�״��������������ڽӾ�������ÿ���ڵ������������ڵĸ�K/2���ڵ�����
adj=zeros(N,N);
for i=1:K/2
    adj=adj+diag(ones(1,N-i),i);
    adj(i,N-K/2+i:N)=1;
end
adj=adj+adj'; 
A_conserve=adj;%������ڽӾ���Ȼ�����Ǹ��ݱߵ�����һֱ���¸��ڽӾ���
node=zeros(K*N/2,2);%�øþ��󴢴��ʼ״̬���еıߵ������ڵ�
t=1;%��ʱ����temp
for i=1:N
    for j=i+1:N
        if(adj(i,j)==1)
            node(t,1)=i;node(t,2)=j;%��¼�ʼ�����бߵ������ڵ�
            t=t+1;
        end
    end
end
for m=1:length(p)
    adj=A_conserve;
    for n=1:K*N/2 %���²���
        if(rand(1,1)<p(m))
            while 1
                newvertex=randperm(N,1);%�����½ڵ㣬randperm(N,1)������1~N�е��������
                if(randperm(2,1)==1 && newvertex~=node(n,2) && adj(newvertex,node(n,2))~=1)%������һ���ڵ㡢�½ڵ㲻���ǵڶ����ڵ�(�����л�)���½ڵ㲻�����Ѿ��бߵĽ��(�������ر�)
                    adj(node(n,1),node(n,2))=0;
                    adj(node(n,2),node(n,1))=0;
                    adj(newvertex,node(n,2))=1;
                    adj(node(n,2),newvertex)=1;
                    break
                elseif(randperm(2,1)==2 && newvertex~=node(n,1) && adj(node(n,1),newvertex)~=1)%�����ڶ����ڵ㡢�½ڵ㲻���ǵ�һ���ڵ�(�����л�)���½ڵ㲻�����Ѿ��бߵĽ��(�������ر�)
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
                count=count+1;%�����Ϊi�Ľ��ĸ���
            end
        end
        degree(i,m)=count;
    end
end
x=1:N-1;
semilogy(x,degree(:,1)/sum(degree(:,1)),'bo-');%semilogy:yΪ�����̶ȣ�xΪ���Կ̶�;semilogx:xΪ�����̶ȣ�yΪ���Կ̶�
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
plot(y,px);%����Ϊ6ʱ�Ĳ��ɷֲ�
hold on
legend('p=0,1','p=0.2','p=0.4','p=0.6','p=0.9','p=1','Poisson');
title('DegreeDistribution');
xlabel('k');ylabel('p(k)');