set -u
pip install -q python-sat 2>&1 | tail -1
(timeout 78m python3 scratch/crown.py 22 cd15 > out/crown_cd15.txt 2>&1 &)
(timeout 78m python3 scratch/crown.py 22 mcb > out/crown_mcb.txt 2>&1 &)
(timeout 78m python3 scratch/pm.py 13 cd15 > out/pm_cd15.txt 2>&1 &)
(timeout 78m python3 scratch/pm.py 13 mcb > out/pm_mcb.txt 2>&1 &)
for i in $(seq 1 470); do sleep 10; if grep -q "SAT \[\|PM 13 .* \[(" out/*.txt 2>/dev/null; then break; fi; done
for f in out/*.txt; do echo "== $f"; cat $f; done
