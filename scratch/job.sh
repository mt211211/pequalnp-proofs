set -u
pip install -q python-sat 2>&1 | tail -1
for cfg in "mcb fwd" "cd15 rev" "lgl fwd" "cd15 shuf"; do (timeout 75m python3 scratch/sat16093.py $cfg > "out/sat_${cfg// /_}.txt" 2>&1 &) ; done
# stop as soon as one finds a circuit
for i in $(seq 1 450); do sleep 10; if grep -l "\[('" out/sat_*.txt >/dev/null 2>&1; then break; fi; if [ "$(grep -l 'None' out/sat_*.txt 2>/dev/null | wc -l)" -ge 1 ]; then break; fi; done
cat out/sat_*.txt
