set -u
cd up/lean
for f in ../../scratch/*.lean; do echo "=== $f"; ( time lake env lean "$f" ) 2>&1 | tail -30; done
