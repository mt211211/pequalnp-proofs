import sys,time; sys.path.insert(0,'scratch')
from gen import synth
T=3936938664*2**32+3936913544
pts=[tuple((x>>i)&1 for i in range(6)) for x in range(64)]
tgt=[(T>>x)&1 for x in range(64)]
order=sys.argv[2]
if order=='rev': pts,tgt=pts[::-1],tgt[::-1]
elif order=='shuf':
    import random; random.seed(7); z=list(zip(pts,tgt)); random.shuffle(z); pts,tgt=map(list,zip(*z))
t=time.time(); r=synth(6,pts,tgt,9,need_not=True,solver=sys.argv[1]); print(sys.argv[1:],9, round(time.time()-t,1), r, flush=True)
