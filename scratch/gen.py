# Generic exact-synthesis SAT: n input wires, points (list of input bit-tuples) with targets, S gates.
# ops: 'and','or' (two distinct earlier wires), 'not' (one earlier wire). Output = last gate.
import sys, itertools
from pysat.solvers import Solver
def synth(n, pts, tgt, S, ops=('and','or','not'), solver='cd15', need_not=False):
    cnt=[0]
    def new(): cnt[0]+=1; return cnt[0]
    cl=[]; T=new(); cl.append([T])
    val={}
    for p,x in enumerate(pts):
        for w in range(n): val[w,p]= T if x[w] else -T
    sel={}; op={}
    for j in range(S):
        g=n+j
        op[j]={o:new() for o in ops}
        cl.append(list(op[j].values()))
        for a,b in itertools.combinations(op[j].values(),2): cl.append([-a,-b])
        for k in (0,1):
            vs=[new() for _ in range(g)]
            for w in range(g): sel[j,k,w]=vs[w]
            cl.append(vs)
            for a,b in itertools.combinations(vs,2): cl.append([-a,-b])
        for w1 in range(g):
            for w2 in range(g):
                if 'not' in ops:
                    # not: in1 == in0 ; binary: in0 < in1
                    if w2 != w1: cl.append([-op[j]['not'], -sel[j,0,w1], -sel[j,1,w2]])
                if w2 <= w1:
                    cl.append([op[j]['not'] if 'not' in ops else -T, -sel[j,0,w1], -sel[j,1,w2]])
        for p in range(len(pts)):
            o=new(); val[g,p]=o; a=new(); b=new()
            for w in range(g):
                cl.append([-sel[j,0,w],-val[w,p],a]); cl.append([-sel[j,0,w],val[w,p],-a])
                cl.append([-sel[j,1,w],-val[w,p],b]); cl.append([-sel[j,1,w],val[w,p],-b])
            if 'and' in ops:
                A=op[j]['and']; cl += [[-A,-o,a],[-A,-o,b],[-A,o,-a,-b]]
            if 'or' in ops:
                O=op[j]['or']; cl += [[-O,o,-a],[-O,o,-b],[-O,-o,a,b]]
            if 'not' in ops:
                N=op[j]['not']; cl += [[-N,o,a],[-N,-o,-a]]
    for j in range(S-1):
        cl.append([sel[k,i,n+j] for k in range(j+1,S) for i in (0,1)])
    if need_not: cl.append([op[j]['not'] for j in range(S)])
    for p in range(len(pts)):
        o=val[n+S-1,p]; cl.append([o] if tgt[p] else [-o])
    with Solver(name=solver, bootstrap_with=cl) as s:
        if not s.solve(): return None
        M=set(x for x in s.get_model() if x>0)
    gates=[]
    for j in range(S):
        o=next(k for k,v in op[j].items() if v in M)
        ins=[next(w for w in range(n+j) if sel[j,k,w] in M) for k in (0,1)]
        gates.append((o, ins[:1] if o=='not' else ins))
    # verify
    for x,t in zip(pts,tgt):
        w=list(x)
        for o,ins in gates:
            w.append((w[ins[0]] and w[ins[1]]) if o=='and' else (w[ins[0]] or w[ins[1]]) if o=='or' else (not w[ins[0]]))
        assert bool(w[-1])==bool(t)
    return gates
if __name__=='__main__':
    kind=sys.argv[1]
    if kind=='twolit':
        n,mask,S=map(int,sys.argv[2:5])
        pts=[];tgt=[]
        for i in range(n):
            for j in range(i,n):
                pts.append(tuple(int(k==i or k==j) for k in range(n))); tgt.append((mask>>(n*i+j))&1)
        r=synth(n,pts,tgt,S)
        print('UNSAT' if r is None else 'SAT %s output %d'%(r,n+S-1))
