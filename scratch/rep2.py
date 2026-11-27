import sys, itertools
from pysat.solvers import Solver
n, m, mask, S = map(int, sys.argv[1:5]); sname = sys.argv[5] if len(sys.argv) > 5 else 'cd15'
N = n + m
pts = [(u, v) for u in range(n) for v in range(m)]
tgt = [(mask >> (m*u+v)) & 1 for (u, v) in pts]
cnt = [0]
def new():
    cnt[0] += 1; return cnt[0]
cl = []
T = new(); cl.append([T])
val = {}
for p,(u,v) in enumerate(pts):
    for w in range(N):
        val[w,p] = T if ((w == u) or (w == n+v)) else -T
sel = {}; isand = {}
for j in range(S):
    g = N + j
    isand[j] = new()
    for k in (0, 1):
        for w in range(g): sel[j,k,w] = new()
        vs = [sel[j,k,w] for w in range(g)]
        cl.append(vs)
        for a, b in itertools.combinations(vs, 2): cl.append([-a, -b])
    # strictly ordered inputs: in0 < in1
    for w1 in range(g):
        for w2 in range(w1+1):
            cl.append([-sel[j,0,w1], -sel[j,1,w2]])
    # no AND of two left inputs or two right inputs (constant false on the promise)
    for a in range(N):
        for b in range(a+1, N):
            if (a < n) == (b < n):
                cl.append([-isand[j], -sel[j,0,a], -sel[j,1,b]])
    for p in range(len(pts)):
        o = new(); val[g,p] = o
        a = new(); b = new()
        for w in range(g):
            cl.append([-sel[j,0,w], -val[w,p], a]); cl.append([-sel[j,0,w], val[w,p], -a])
            cl.append([-sel[j,1,w], -val[w,p], b]); cl.append([-sel[j,1,w], val[w,p], -b])
        cl += [[-isand[j], -o, a], [-isand[j], -o, b], [-isand[j], o, -a, -b]]
        cl += [[isand[j], o, -a], [isand[j], o, -b], [isand[j], -o, a, b]]
# every gate but the last is read later
for j in range(S-1):
    cl.append([sel[k,i,N+j] for k in range(j+1, S) for i in (0,1)])
# independent neighbours in order of first input
for j in range(S-1):
    g = N + j
    for w1 in range(g):
        for w2 in range(w1):
            cl.append([sel[j+1,0,g], sel[j+1,1,g], -sel[j,0,w1], -sel[j+1,0,w2]])
# distinct wire functions: gate differs from every earlier wire somewhere (cheap form: from inputs only skipped)
for p in range(len(pts)):
    o = val[N+S-1, p]; cl.append([o] if tgt[p] else [-o])
with Solver(name=sname, bootstrap_with=cl) as s:
    r = s.solve()
    if not r: print("UNSAT", S); sys.exit(1)
    M = set(x for x in s.get_model() if x > 0)
    gates = [("and" if isand[j] in M else "or", [next(w for w in range(N+j) if sel[j,k,w] in M) for k in (0,1)]) for j in range(S)]
def ev(u,v):
    w = [int(i==u) for i in range(n)] + [int(i==v) for i in range(m)]
    for op, ins in gates:
        a, b = w[ins[0]], w[ins[1]]; w.append(a & b if op == "and" else a | b)
    return w[-1]
assert all(ev(u,v) == t for (u,v), t in zip(pts, tgt))
print("SAT", gates, "output", N+S-1)
