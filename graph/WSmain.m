
G=graph([1 1 2 2 3 4 4 4 5 6], [2 3 3 4 5 5 6 7 6 7]);
A=adjacency(G);

T=2;
dt=0.01;
n=T/dt;%nodes of time
X=zeros(7,T/dt+1);
S=zeros(7,T/dt+1);
x=zeros(7,T/dt+1);
s=zeros(7,T/dt+1);
beta=4.1; derta=6.3;

[A_WS,h]=WS(500,4,0.2);

%ODE form
X(:,1)=0.5;
S(:,1)=A*X(:,1);

%stochastic form
x(:,1)=0.5;
s(:,1)=A*x(:,1);

randn('state',100)
dw=sqrt(dt)*randn(7,n);
sigma=0.06;

k=2;
for i=dt:dt:T
   X(:,k)=X(:,k-1)+dt*(beta*S(:,k-1).*(1-X(:,k-1))-derta*X(:,k-1));
   S(:,k)=A*X(:,k);
   
   x(:,k)=x(:,k-1)+dt*(beta*s(:,k-1).*(1-x(:,k-1))-derta*x(:,k-1))+sigma*s(:,k-1).*(1-x(:,k-1)).*dw(:,k-1);
   s(:,k)=A*x(:,k);
   k=k+1;
end


plot(graph(A_WS))



   
   



