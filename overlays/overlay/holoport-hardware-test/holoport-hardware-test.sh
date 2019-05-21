#!@bash@/bin/bash

PATH=@path@:$PATH

if [ "$(whoami)" != "root" ]; then
  echo "HoloPort hardware test requires root."
  exit 1
fi

case "$1" in
  holoport)
    cpu=2
    ;;
  holoport-plus)
    cpu=4
    ;;
  *)
    echo "Usage: $0 {holoport,holoport-plus}"
    exit 1
    ;;
esac

set -euo pipefail
shopt -s extglob

log=$(mktemp)

lshw -C cpu -C memory >> "$log"

stress-ng \
  --cpu "$cpu" \
  --io 3 \
  --vm-bytes 1g \
  --timeout 1m \
  --hdd 4 \
  --tz \
  --verbose \
  --verify \
  --metrics-brief >> "$log"

max_test_estimate=0

for hd in /dev/disk/by-id/ata!(*-part*); do
  smartctl -X "$hd" &>> /dev/null
  smartctl -i "$hd" &>> "$log"

  test_estimate=$(smartctl -t short -d ata "$hd" | grep 'Please wait' | awk '{print $3}')
  if [ "$test_estimate" -gt "$max_test_estimate" ]; then
    max_test_estimate=$test_estimate
  fi
done

echo "Waiting $max_test_estimate minutes for SMART tests to complete"
sleep "${max_test_estimate}m"

for hd in /dev/disk/by-id/ata*; do
  smartctl -d ata "$hd" &>> "$log"
done

for _ in {1..10}; do
  sleep .01
  echo -n -e \\a
done

echo "$log"
less "$log"
