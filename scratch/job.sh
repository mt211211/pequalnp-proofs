set -u
cd up/lean
( time lake build PEqualNP.Defs ) 2>&1 | tail -5
for f in ../../scratch/*.lean; do echo "=== $f"; ( time lake env lean "$f" ) 2>&1 | tail -30; done
