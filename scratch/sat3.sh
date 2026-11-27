set -u
pip install -q python-sat 2>&1 | tail -1
for s in mcb lgl cd19 mpl; do (timeout 70m python3 scratch/tl9.py $s > out3/tl9_$s.txt 2>&1 &); done
for i in $(seq 1 410); do sleep 10; if grep -q "\[(" out3/tl9_*.txt 2>/dev/null; then break; fi; if grep -q "None" out3/tl9_*.txt 2>/dev/null; then break; fi; done
for f in out3/tl9_*.txt; do echo "== $f"; cat $f; done
