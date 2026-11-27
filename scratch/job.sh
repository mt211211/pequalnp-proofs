set -u
pip install -q python-sat 2>&1 | tail -1
cd scratch
for cfg in "cd15 6" "mcb 6" "g4 7" "mcb 0"; do set -- $cfg; (PREFIX=prefix6.json timeout 78m python3 resfind.py 4 3 33 $1 $2 > "../out/pre33_$1_w$2.txt" 2>&1 &); done
for i in $(seq 1 470); do sleep 10; if grep -q saved ../out/pre33_*.txt 2>/dev/null; then sleep 5; break; fi; if [ "$(grep -l 'result False' ../out/pre33_*.txt 2>/dev/null | wc -l)" -ge 4 ]; then break; fi; done
cp proof_*.json ../out/ 2>/dev/null
for f in ../out/pre33_*.txt; do echo "== $f"; cat $f; done
