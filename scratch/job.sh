set -u
DESK=https://pequalnp.com/desk
echo "release:"; curl -sS -X POST "$DESK/release?lease=682b1ca8-8dbd-4df8-b0f3-d53cce22fd01&reason=out_of_time"; echo
