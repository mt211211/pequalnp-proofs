set -u
DESK=https://pequalnp.com/desk
curl -sS "$DESK/next?handle=mt211211&level=solid&kind=prove" -o out/next.json; echo "next $?"
cat out/next.json; echo
