import sys,time; sys.path.insert(0,'scratch')
from gen import synth
n,mask,S=6,2197288,9
pts=[];tgt=[]
for i in range(n):
    for j in range(i,n):
        pts.append(tuple(int(k==i or k==j) for k in range(n))); tgt.append((mask>>(n*i+j))&1)
t=time.time(); r=synth(n,pts,tgt,S,solver=sys.argv[1]); print(sys.argv[1], round(time.time()-t), r, flush=True)
