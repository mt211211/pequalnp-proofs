# SAT search for L-meta-18791: 10-gate FanInTwo circuit of the 7-cycle function where x0 is read only by one OR gate i,
# OR(x0,h), gate i read by a later AND gate, and h true at some point with x0=x1=x6=0.
import sys, itertools, time, json
from pysat.solvers import Solver
n=7; S=10
pts=[tuple((x>>i)&1 for i in range(n)) for x in range(128)]
def C7(x): return int(any(x[i] and x[(i+1)%7] for i in range(7)))
tgt=[C7(x) for x in pts]
P0=[p for p,x in enumerate(pts) if x[0]==0 and x[1]==0 and x[6]==0]
cnt=[0]
def new(): cnt[0]+=1; return cnt[0]
cl=[]; T=new(); cl.append([T])
val={}
for p,x in enumerate(pts):
    for w in range(n): val[w,p]= T if x[w] else -T
sel={}; op={}; A={}; B={}
for j in range(S):
    g=n+j
    op[j]={o:new() for o in ('and','or','not')}
    cl.append(list(op[j].values()))
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
    for p in range(128):
        o=new(); val[g,p]=o; a=new(); b=new(); A[j,p]=a; B[j,p]=b
        for w in range(g):
            cl.append([-sel[j,0,w],-val[w,p],a]); cl.append([-sel[j,0,w],val[w,p],-a])
            cl.append([-sel[j,1,w],-val[w,p],b]); cl.append([-sel[j,1,w],val[w,p],-b])
        An=op[j]['and']; Or=op[j]['or']; Nt=op[j]['not']
        cl += [[-An,-o,a],[-An,-o,b],[-An,o,-a,-b]]
        cl += [[-Or,o,-a],[-Or,o,-b],[-Or,-o,a,b]]
        cl += [[-Nt,o,a],[-Nt,-o,-a]]
for j in range(S-1):
    cl.append([sel[k,i,n+j] for k in range(j+1,S) for i in (0,1)])
# independent neighbours ordered by first input (sound: greedy topological order)
for j in range(S-1):
    g=n+j
    for w1 in range(g):
        for w2 in range(w1):
            cl.append([sel[j+1,0,g],sel[j+1,1,g],-sel[j,0,w1],-sel[j+1,0,w2]])
for p in range(128):
    o=val[n+S-1,p]; cl.append([o] if tgt[p] else [-o])
# shape constraints
isI=[new() for j in range(S)]
cl.append(isI)
if len(sys.argv)>2:
    allowed=[int(t) for t in sys.argv[2].split(',')]
    for j in range(S):
        if j not in allowed: cl.append([-isI[j]])
for a,b in itertools.combinations(isI,2): cl.append([-a,-b])
for j in range(S):
    # wire 0 read by gate j (as either input) iff j is i ; x0 is wire 0 so it can only be in0 of a binary gate
    for k in (0,1): cl.append([-sel[j,k,0], isI[j]])
    cl.append([-isI[j], sel[j,0,0]])
    cl.append([-isI[j], op[j]['or']])
    # some later AND reads wire n+j
    r=[]
    for k in range(j+1,S):
        for t in (0,1):
            z=new(); cl += [[-z,op[k]['and']],[-z,sel[k,t,n+j]]]; r.append(z)
    cl.append([-isI[j]]+r)
    # h = in1 of gate i true at some point of P0
    cl.append([-isI[j]]+[B[j,p] for p in P0])
print('vars',cnt[0],'clauses',len(cl),flush=True)
t=time.time()
with Solver(name=sys.argv[1] if len(sys.argv)>1 else 'cd15', bootstrap_with=cl) as s:
    r=s.solve(); print('result', r, round(time.time()-t,1), flush=True)
    if r:
        M=set(x for x in s.get_model() if x>0)
        gates=[]
        for j in range(S):
            o=next(k for k,v in op[j].items() if v in M)
            ins=[next(w for w in range(n+j) if sel[j,k,w] in M) for k in (0,1)]
            gates.append((o, ins[:1] if o=='not' else ins))
        print(json.dumps(gates), 'i=', [j for j in range(S) if isI[j] in M])
