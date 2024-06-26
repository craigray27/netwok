randn('state',18)
z=rand(1,437)*0.0046;
p=zeros(1,437);
p(1)=0.01;
for i=2:437
 p(i)=p(i-1)+z(i-1);
end
cluster=(3/4)*((10-2)/(10-1))*(1-p).^3;
l=log(500*10*p)./(100*p);

r0=0.1;
sigma=0.20655528;
N=437;
a= 0.84044417;
b=8.21835 ;
dt=cluster(1:end-1)-cluster(2:end);
dw=sqrt(dt).*randn(1,436);
R=1;Dt=R*dt;L=436;
rem=zeros(1,L);
r=r0;

for j=1:L
    winc=sum(dw(R*(j-1)+1:R*j));
    r=r+(a-b*r)*Dt(j)+sigma*sqrt(r)*winc;%weak-eular
    rem(j)=r;
end

rem=[r0,rem];
c=sort(cluster);
d=sort(l);
scatter(d,rem)
xlabel('Average Shortest Path')
ylabel('Accuracy Rate ')



