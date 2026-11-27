set -u
pip install -q python-sat 2>&1 | tail -1
cd scratch
for cfg in "33 mcb 6" "33 cd15 7" "33 g4 6" "33 mcb 0"; do set -- $cfg; (timeout 275m python3 resfind.py 4 3 $1 $2 $3 > "../out2/res_$1_$2_w$3.txt" 2>&1 &); done
for i in $(seq 1 1640); do sleep 10; if grep -q "saved" ../out2/res_*.txt 2>/dev/null; then sleep 5; break; fi; if [ "$(grep -l 'result False' ../out2/res_*.txt 2>/dev/null | wc -l)" -ge 4 ]; then break; fi; done
cp proof_*.json ../out2/ 2>/dev/null
for f in ../out2/res_*.txt; do echo "== $f"; cat $f; done
