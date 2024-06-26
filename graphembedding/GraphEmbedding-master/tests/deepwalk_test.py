import networkx as nx
import sys
sys.path.append('C:/Users/Craig Ray/Desktop/GNN& Interbank Market/graphembedding/GraphEmbedding-master/ge/models')
sys.path.append('C:/Users/Craig Ray/Desktop/GNN& Interbank Market/graphembedding/GraphEmbedding-master/tests')
from deepwalk import DeepWalk


def test_DeepWalk():
    G = nx.read_edgelist('Wiki_edgelist.txt',
                         create_using=nx.DiGraph(), nodetype=None, data=[('weight', int)])

    model = DeepWalk(G, walk_length=3, num_walks=2, workers=1)
    model.train(window_size=3, iter=1)
    embeddings = model.get_embeddings()


if __name__ == "__main__":
    test_DeepWalk()
