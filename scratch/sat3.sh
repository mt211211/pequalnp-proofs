set -u
pip install -q python-sat 2>&1 | tail -1
cd scratch
for cfg in "12 mcb" "11 cd15" "11 mcb" "10 mcb"; do set -- $cfg; (timeout 75m python3 pm12.py $1 $2 > ../out3/pm_$1_$2.txt 2>&1 &); done
for i in $(seq 1 440); do sleep 10; if grep -q "result True" ../out3/pm_*.txt 2>/dev/null; then sleep 3; break; fi; [ "$(grep -l 'result False' ../out3/pm_*.txt 2>/dev/null | wc -l)" -ge 4 ] && break; done
for f in ../out3/pm_*.txt; do echo "== $f"; cat $f; done
