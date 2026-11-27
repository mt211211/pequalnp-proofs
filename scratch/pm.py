# monotone 3x3 perfect matching (permanent) with S gates, AND/OR only
import sys,time; sys.path.insert(0,'scratch')
from gen import synth
S=int(sys.argv[1])
pts=[tuple((m>>i)&1 for i in range(9)) for m in range(512)]
def pm(x): return int((x[0] and x[4] and x[8]) or (x[0] and x[5] and x[7]) or (x[1] and x[3] and x[8]) or (x[1] and x[5] and x[6]) or (x[2] and x[3] and x[7]) or (x[2] and x[4] and x[6]))
t=time.time(); r=synth(9,pts,[pm(x) for x in pts],S,ops=('and','or'),solver=sys.argv[2]); print('PM',S,sys.argv[2],round(time.time()-t),r,flush=True)
