
% ���� WSС��������
function  [A_WS,h]=WS(N,K,beta)
% ������ڽӾ���A_WS��% ͼ h
% ���룺����ڵ���N���������=�Ⱦ�ֵ=2*N����������beta
 
s = repelem((1:N)',1,K);
% ��ʼ��ĩ�˵�t���������K���ھӣ����������磩
t = s + repmat(1:K,N,1);
t = mod(t-1,N)+1;%mod������N����(t-1)�������
 
% �Ը��� beta ��������ÿ���ߵ�Ŀ��ڵ�
for source=1:N
    switchEdge = rand(K, 1) < beta;
    % ����K��1�����������beta�Ƚϴ�С,�õ�K��1�е��߼�����
    newTargets = rand(N, 1);%����N��1�������
    newTargets(source) = 0;%��ǰ���ֵΪ0
    newTargets(s(t==source)) = 0;
    newTargets(t(source, ~switchEdge)) = 0;
    
    [~, ind] = sort(newTargets, 'descend');%ind����������
    t(source, switchEdge) = ind(1:nnz(switchEdge));%nnz���������Ԫ����Ŀ
end
 
h = graph(s,t);% graph(s,t) �ڽڵ������ָ��ͼ�� (s,t)����������ͼ
A_WS=adjacency(h);
A_WS=full(A_WS);
end
