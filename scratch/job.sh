set -u
pip install -q python-sat 2>&1 | tail -1
for cfg in "cd15 0,1,2" "mcb 3,4" "cd15 5,6" "mcb 7,8"; do set -- $cfg; (timeout 85m python3 scratch/cyc7.py $1 $2 > "out/cyc_$2.txt" 2>&1 &); done
for i in $(seq 1 520); do sleep 10; if grep -q "result True" out/cyc_*.txt 2>/dev/null; then break; fi; if [ "$(grep -l 'result False' out/cyc_*.txt 2>/dev/null | wc -l)" -ge 4 ]; then break; fi; done
for f in out/cyc_*.txt; do echo "== $f"; cat $f; done
