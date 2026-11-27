# Search for a normal-form FanInTwo circuit for 3x3 perfect matching, <= S gates, gates 0,1 fixed to OR(0,1), AND(2,9).
import sys, itertools, time, json
sys.path.insert(0,'.')
from pysat.solvers import Solver
n=9; S=int(sys.argv[1]); sname=sys.argv[2]
pts=[tuple((m>>i)&1 for i in range(9)) for m in range(512)]
def pm(x): return int((x[0] and x[4] and x[8]) or (x[0] and x[5] and x[7]) or (x[1] and x[3] and x[8]) or (x[1] and x[5] and x[6]) or (x[2] and x[3] and x[7]) or (x[2] and x[4] and x[6]))
tgt=[pm(x) for x in pts]
ops=('and','or','not')
cnt=[0]
def new(): cnt[0]+=1; return cnt[0]
cl=[]; T=new(); cl.append([T])
val={}
for p,x in enumerate(pts):
    for w in range(n): val[w,p]=T if x[w] else -T
sel={}; op={}
for j in range(S):
    g=n+j
    op[j]={o:new() for o in ops}; cl.append(list(op[j].values()))
    for a,b in itertools.combinations(op[j].values(),2): cl.append([-a,-b])
    for k in (0,1):
        vs=[new() for _ in range(g)]
        for w in range(g): sel[j,k,w]=vs[w]
        cl.append(vs)
        for a,b in itertools.combinations(vs,2): cl.append([-a,-b])
    for w1 in range(g):
        for w2 in range(g):
            if w2!=w1: cl.append([-op[j]['not'],-sel[j,0,w1],-sel[j,1,w2]])
            if w2<=w1: cl.append([op[j]['not'],-sel[j,0,w1],-sel[j,1,w2]])
    for p in range(512):
        o=new(); val[g,p]=o; a=new(); b=new()
        for w in range(g):
            cl.append([-sel[j,0,w],-val[w,p],a]); cl.append([-sel[j,0,w],val[w,p],-a])
            cl.append([-sel[j,1,w],-val[w,p],b]); cl.append([-sel[j,1,w],val[w,p],-b])
        A=op[j]['and']; O=op[j]['or']; N=op[j]['not']
        cl += [[-A,-o,a],[-A,-o,b],[-A,o,-a,-b],[-O,o,-a],[-O,o,-b],[-O,-o,a,b],[-N,o,a],[-N,-o,-a]]
    # nonconstant and different from every earlier wire
    cl.append([val[g,p] for p in range(512)]); cl.append([-val[g,p] for p in range(512)])
    for k in range(g):
        d=[]
        for p in range(512):
            if k<n: d.append(-val[g,p] if pts[p][k] else val[g,p])
            else:
                z=new(); d.append(z); cl += [[-z,val[g,p],val[k,p]],[-z,-val[g,p],-val[k,p]]]
        cl.append(d)
for j in range(S-1):
    cl.append([sel[k,i,n+j] for k in range(j+1,S) for i in (0,1)])
for p in range(512):
    o=val[n+S-1,p]; cl.append([o] if tgt[p] else [-o])
# fixed opening
cl += [[op[0]['or']],[sel[0,0,0]],[sel[0,1,1]],[op[1]['and']],[sel[1,0,2]],[sel[1,1,9]]]
t=time.time()
with Solver(name=sname, bootstrap_with=cl) as s:
    r=s.solve(); print('S',S,sname,'result',r,round(time.time()-t,1),flush=True)
    if r:
        M=set(x for x in s.get_model() if x>0)
        gates=[]
        for j in range(S):
            o=next(k for k,v in op[j].items() if v in M); ins=[next(w for w in range(n+j) if sel[j,k,w] in M) for k in (0,1)]
            gates.append((o, ins[:1] if o=='not' else ins))
        print(json.dumps(gates))
