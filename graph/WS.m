
% 生成 WS小世界网络
function  [A_WS,h]=WS(N,K,beta)
% 输出：邻接矩阵A_WS；% 图 h
% 输入：网络节点数N，最近邻数=度均值=2*N，重连概率beta
 
s = repelem((1:N)',1,K);
% 初始的末端点t（最近的右K个邻居，周期型网络）
t = s + repmat(1:K,N,1);
t = mod(t-1,N)+1;%mod计算用N除以(t-1)后的余数
 
% 以概率 beta 重新连线每条边的目标节点
for source=1:N
    switchEdge = rand(K, 1) < beta;
    % 生成K行1列随机数，与beta比较大小,得到K行1列的逻辑数组
    newTargets = rand(N, 1);%生成N行1列随机数
    newTargets(source) = 0;%当前点的值为0
    newTargets(s(t==source)) = 0;
    newTargets(t(source, ~switchEdge)) = 0;
    
    [~, ind] = sort(newTargets, 'descend');%ind是索引向量
    t(source, switchEdge) = ind(1:nnz(switchEdge));%nnz：非零矩阵元素数目
end
 
h = graph(s,t);% graph(s,t) 在节点对组中指定图边 (s,t)，绘制无向图
A_WS=adjacency(h);
A_WS=full(A_WS);
end
