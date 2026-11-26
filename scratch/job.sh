set -u
DESK=https://pequalnp.com/desk
echo "release:"; curl -sS -X POST "$DESK/release?lease=cde966ed-7dc7-4d1b-9710-ebb304766183&reason=exhausted&program=c2215b4af4c610cdf9318993c65c11fd8fc29c8c63b69cab74de23c3f0b13b75"; echo
curl -sS "$DESK/next?handle=mt211211&kind=prove" -o out/next.json; echo "next $?"
cat out/next.json; echo
