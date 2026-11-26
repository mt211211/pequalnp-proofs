set -u
DESK=https://pequalnp.com/desk
curl -sS "$DESK/next?handle=mt211211&level=warmup" -o out/next.json; echo "next $?"
head -c 3000 out/next.json; echo
cd lean && lake env lean --version && ls .lake/packages | head
