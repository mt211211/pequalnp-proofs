set -u
DESK=https://pequalnp.com/desk
curl -sSf -o out/gaps.json https://data.pequalnp.com/data/desk/gaps.json; echo "gaps $?"
curl -sS "$DESK/next?handle=mt211211&level=solid&kind=prove" -o out/next.json
python3 - <<'PY' > out/target.txt
import json,re
d=json.load(open('out/next.json')); g=d.get('gap') or {}; l=d.get('lease') or {}
print(json.dumps({'id':g.get('id'),'lease':l.get('id') or l.get('lease'),'expires':l.get('expires_at'),'statement':g.get('statement'),'title':g.get('title')}))
PY
cat out/target.txt; cat out/next.json | head -c 400; echo
read -r GID LEASE N M MASK S < <(python3 - <<'PY'
import json,re
t=json.loads(open('out/target.txt').read())
m=re.search(r'fun (?:\(u : Fin (\d+)\) \(v : Fin (\d+)\)|u v : Fin (\d+)) => \((\d+) : ℕ\)\.testBit \((\d+) \* u\.val \+ v\.val\)\) (\d+)$', t['statement'] or '')
if m:
    n=m.group(1) or m.group(3); mm=m.group(2) or m.group(3)
    print(t['id'], t['lease'], n, mm, m.group(4), m.group(6))
else: print(t['id'], t['lease'], 0,0,0,0)
PY
)
echo "target $GID lease $LEASE ${N}x${M} mask $MASK S $S"
[ "$N" = 0 ] && exit 0
pip install -q python-sat 2>&1 | tail -1
for cfg in cd15 g4 mcb; do (timeout 70m python3 scratch/rep2.py $N $M $MASK $S $cfg > out/sat_$cfg.txt 2>&1 &); done
for i in $(seq 1 17); do
  for k in $(seq 1 24); do sleep 10; grep -q "^SAT" out/sat_*.txt 2>/dev/null && break 2; done
  curl -sS -X POST "$DESK/beat?lease=$LEASE" | head -c 200; echo
done
cat out/sat_*.txt
