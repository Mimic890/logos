#!/usr/bin/env fish
# Rebuild CHECKSUMS.sha256 and manage its OpenTimestamps proof.
#
# Usage:
#   scripts/stamp.fish [stamp]   rebuild checksums and create a new timestamp
#   scripts/stamp.fish upgrade   complete a pending timestamp
#   scripts/stamp.fish verify    verify the timestamp

set -l root (realpath (status dirname)/..)
set -l checksums CHECKSUMS.sha256
set -l proof $checksums.ots

function fail
    echo "stamp: $argv" >&2
    exit 1
end

if not command -q ots
    fail "'ots' not found. Install it with: pip install opentimestamps-client"
end

cd $root; or fail "cannot enter $root"

set -l cmd stamp
if set -q argv[1]
    set cmd $argv[1]
end

switch $cmd
    case stamp
        if not test -d logos
            fail "logos/ directory not found"
        end

        set -l files (find logos -type f ! -name .gitkeep | LC_ALL=C sort)
        if test (count $files) -eq 0
            fail "no files in logos/ to stamp"
        end

        sha256sum -- $files >$checksums.tmp; or fail "sha256sum failed"
        mv $checksums.tmp $checksums
        echo "Wrote $checksums ("(count $files)" files)"

        rm -f $proof
        ots stamp $checksums; or fail "ots stamp failed"
        echo "Created $proof (run 'scripts/stamp.fish upgrade' in a few hours)"
    case upgrade
        test -f $proof; or fail "$proof not found"
        ots upgrade $proof
    case verify
        test -f $proof; or fail "$proof not found"
        ots verify $proof
    case '*'
        fail "unknown command '$cmd' (expected: stamp, upgrade, verify)"
end
