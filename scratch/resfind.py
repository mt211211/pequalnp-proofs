# Exact search for a resolution refutation of PHP m n with K derived lines (after all axioms).
import sys, itertools, time, json
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType
m, n, K = map(int, sys.argv[1:4]); sname = sys.argv[4] if len(sys.argv) > 4 else 'cd15'; WMAX = int(sys.argv[5]) if len(sys.argv) > 5 else 0
V=[(i,j) for i in range(m) for j in range(n)]; NV=len(V); vid={v:k for k,v in enumerate(V)}
AX=[]
for i in range(m): AX.append(({vid[(i,j)] for j in range(n)}, set()))
for j in range(n):
    for i in range(m):
        for i2 in range(i+1,m): AX.append((set(), {vid[(i,j)], vid[(i2,j)]}))
A=len(AX); L=A+K
cnt=[0]
def new(): cnt[0]+=1; return cnt[0]
cl=[]; T=new(); cl.append([T])
pos=[[None]*NV for _ in range(L)]; neg=[[None]*NV for _ in range(L)]
for l,(P,N_) in enumerate(AX):
    for w in range(NV): pos[l][w]= T if w in P else -T; neg[l][w]= T if w in N_ else -T
sa={}; sb={}; piv={}
for l in range(A, L):
    for w in range(NV): pos[l][w]=new(); neg[l][w]=new()
    a=[new() for _ in range(l)]; b=[new() for _ in range(l)]; pv=[new() for _ in range(NV)]
    sa[l]=a; sb[l]=b; piv[l]=pv
    for X in (a,b,pv):
        cl.append(X); cl += CardEnc.atmost(X, 1, top_id=cnt[0], encoding=EncType.seqcounter).clauses if False else [[-x,-y] for x,y in itertools.combinations(X,2)]
    # values of selected premises
    PA=[new() for _ in range(NV)]; NA=[new() for _ in range(NV)]; PB=[new() for _ in range(NV)]; NB=[new() for _ in range(NV)]
    for k in range(l):
        for w in range(NV):
            cl += [[-a[k],-pos[k][w],PA[w]],[-a[k],pos[k][w],-PA[w]],[-a[k],-neg[k][w],NA[w]],[-a[k],neg[k][w],-NA[w]]]
            cl += [[-b[k],-pos[k][w],PB[w]],[-b[k],pos[k][w],-PB[w]],[-b[k],-neg[k][w],NB[w]],[-b[k],neg[k][w],-NB[w]]]
    for w in range(NV):
        # pivot: v positive in a, negative in b
        cl += [[-pv[w],PA[w]],[-pv[w],NB[w]]]
        # pos[l][w] = (PA[w] & !pv[w]) | PB[w] ; neg[l][w] = NA[w] | (NB[w] & !pv[w])
        P=pos[l][w]; N_=neg[l][w]
        cl += [[-PA[w],pv[w],P],[-PB[w],P],[-P,PA[w],PB[w]],[-P,-pv[w],PB[w]]]
        cl += [[-NA[w],N_],[-NB[w],pv[w],N_],[-N_,NA[w],NB[w]],[-N_,-pv[w],NA[w]]]
        # no tautologies
        cl.append([-P,-N_])
# last line empty
for w in range(NV): cl += [[-pos[L-1][w]],[-neg[L-1][w]]]
# every derived line except the last is used later
for l in range(A, L-1):
    cl.append([sa[k][l] for k in range(l+1,L)]+[sb[k][l] for k in range(l+1,L)])

# symmetry: if line l+1 does not read line l, then the positive premise of l is <= that of l+1 (greedy topological order)
for l in range(A, L-1):
    for k1 in range(l):
        for k2 in range(k1):
            cl.append([sa[l+1][l], sb[l+1][l], -sa[l][k1], -sa[l+1][k2]])
# no duplicate derived lines (differ in some literal)
for l1 in range(A, L):
    for l2 in range(l1+1, L):
        d=[]
        for w in range(NV):
            for X in (pos, neg):
                z=new(); d.append(z)
                cl += [[-z, X[l1][w], X[l2][w]], [-z, -X[l1][w], -X[l2][w]]]
        cl.append(d)
# width cap
if WMAX:
    for l in range(A, L):
        lits=[pos[l][w] for w in range(NV)]+[neg[l][w] for w in range(NV)]
        enc=CardEnc.atmost(lits, WMAX, top_id=cnt[0], encoding=EncType.seqcounter)
        cnt[0]=max(cnt[0], enc.nv); cl += enc.clauses
import os
if os.environ.get('PREFIX'):
    pre=json.load(open(os.environ['PREFIX']))
    for t,(P,N_,a,b,w) in enumerate(pre):
        l=A+t
        for x in range(NV):
            cl.append([pos[l][x]] if x in P else [-pos[l][x]]); cl.append([neg[l][x]] if x in N_ else [-neg[l][x]])
        cl.append([sa[l][a]]); cl.append([sb[l][b]]); cl.append([piv[l][w]])
print('vars',cnt[0],'clauses',len(cl),flush=True)
t=time.time()
with Solver(name=sname, bootstrap_with=cl) as s:
    r=s.solve(); print('result',r,round(time.time()-t,1),flush=True)
    if r:
        M=set(x for x in s.get_model() if x>0)
        lines=[]
        for l in range(L):
            if l<A: lines.append({'pos':sorted(AX[l][0]),'neg':sorted(AX[l][1]),'by':None})
            else:
                a=next(k for k in range(l) if sa[l][k] in M); b=next(k for k in range(l) if sb[l][k] in M); v=next(w for w in range(NV) if piv[l][w] in M)
                lines.append({'pos':[w for w in range(NV) if pos[l][w] in M],'neg':[w for w in range(NV) if neg[l][w] in M],'by':[a,b,v]})
        json.dump({'m':m,'n':n,'V':V,'lines':lines}, open('proof_%d_%d_%d.json'%(m,n,K),'w'))
        print('saved')
