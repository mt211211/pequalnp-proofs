set -u
pip install -q python-sat 2>&1 | tail -1
cd scratch
for cfg in "33 cd15" "33 mcb" "33 g4" "36 cd15"; do set -- $cfg; (timeout 275m python3 resfind.py 4 3 $1 $2 > "../out2/res_$1_$2.txt" 2>&1 &); done
for i in $(seq 1 1640); do sleep 10; if grep -q "result True" ../out2/res_33_*.txt 2>/dev/null; then sleep 5; break; fi; done
cp proof_*.json ../out2/ 2>/dev/null
for f in ../out2/res_*.txt; do echo "== $f"; cat $f; done
