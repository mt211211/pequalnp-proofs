set -u
DESK=https://pequalnp.com/desk
for i in $(seq 1 40); do
  curl -sS "$DESK/next?handle=mt211211&level=warmup" -o out/next.json
  if python3 -c "import json,sys; sys.exit(0 if json.load(open('out/next.json')).get('gap') else 1)"; then echo "got one at try $i"; break; fi
  sleep 60
done
cat out/next.json
