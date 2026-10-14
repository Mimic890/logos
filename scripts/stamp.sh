#!/usr/bin/env bash
# Rebuild CHECKSUMS.sha256 and manage its OpenTimestamps proof.
#
# Usage:
#   scripts/stamp.sh [stamp]   rebuild checksums and create a new timestamp
#   scripts/stamp.sh upgrade   complete a pending timestamp
#   scripts/stamp.sh verify    verify the timestamp

set -euo pipefail

checksums=CHECKSUMS.sha256
proof=$checksums.ots

fail() {
    echo "stamp: $*" >&2
    exit 1
}

command -v ots >/dev/null 2>&1 ||
    fail "'ots' not found. Install it with: pip install opentimestamps-client"

cd "$(dirname "${BASH_SOURCE[0]}")/.." || fail "cannot enter repository root"

cmd=${1:-stamp}

case $cmd in
    stamp)
        [[ -d logos ]] || fail "logos/ directory not found"

        files=()
        while IFS= read -r -d '' f; do
            files+=("$f")
        done < <(find logos -type f ! -name .gitkeep -print0 | LC_ALL=C sort -z)
        (( ${#files[@]} > 0 )) || fail "no files in logos/ to stamp"

        sha256sum -- "${files[@]}" >"$checksums.tmp" || fail "sha256sum failed"
        mv "$checksums.tmp" "$checksums"
        echo "Wrote $checksums (${#files[@]} files)"

        rm -f "$proof"
        ots stamp "$checksums" || fail "ots stamp failed"
        echo "Created $proof (run 'scripts/stamp.sh upgrade' in a few hours)"
        ;;
    upgrade)
        [[ -f $proof ]] || fail "$proof not found"
        ots upgrade "$proof"
        ;;
    verify)
        [[ -f $proof ]] || fail "$proof not found"
        ots verify "$proof"
        ;;
    *)
        fail "unknown command '$cmd' (expected: stamp, upgrade, verify)"
        ;;
esac
