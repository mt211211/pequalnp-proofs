set -u
DESK=https://pequalnp.com/desk
echo "release:"; curl -sS -X POST "$DESK/release?lease=cde966ed-7dc7-4d1b-9710-ebb304766183&reason=statement_seems_false"; echo
curl -sS "$DESK/next?handle=mt211211&kind=prove" -o out/next.json; echo "next $?"
cat out/next.json; echo
