set -u
pip install -q python-sat 2>&1 | tail -1
for s in cd15 mcb g4 lgl; do (timeout 78m python3 scratch/crown.py 22 $s > out/crown_$s.txt 2>&1 &); done
for i in $(seq 1 470); do sleep 10; if grep -q "^SAT" out/crown_*.txt 2>/dev/null; then break; fi; if [ "$(grep -l 'UNSAT' out/crown_*.txt 2>/dev/null | wc -l)" -ge 1 ]; then break; fi; done
for f in out/crown_*.txt; do echo "== $f"; cat $f; done
