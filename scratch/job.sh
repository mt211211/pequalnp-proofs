set -u
DESK=https://pequalnp.com/desk
echo "release:"; curl -sS -X POST "$DESK/release?lease=2bca2c42-a6cb-45a2-afe9-a2c6866e814d&reason=out_of_time"; echo
curl -sS "$DESK/next?handle=mt211211&level=solid&kind=prove" -o out/next.json; echo "next $?"
python3 -c "
import json;d=json.load(open('out/next.json'));g=d.get('gap') or {}
print(json.dumps({k:g.get(k) for k in ('id','title','statement','imports','sketch','context')},ensure_ascii=False)[:6000]); print(json.dumps(d.get('lease')))
print(d.get('note'))"
