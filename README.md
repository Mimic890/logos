# logos

Logos for projects by **Mikhail Vyacheslavovich Romanov** (Mikhail Romanov),
known as **Mimic** — [github.com/Mimic890](https://github.com/Mimic890).

All logos are original work. They are **not** covered by the licenses of the
projects they represent — see [LICENSE](LICENSE). All rights reserved.

## Logos

| Project | Preview | Created |
| ------- | ------- | ------- |
| [hyprvpn](logos/hyprvpn/) | <img src="logos/hyprvpn/svg/hyprvpn-mark.svg" height="48" alt="hyprvpn"> | 2026-10-14 |
<!-- | [example](logos/example/) | <img src="logos/example/logo.svg" height="48" alt="example"> | 2026-01-01 | -->

## Layout

```
logos/<project>/svg/   vector masters
logos/<project>/png/   raster exports (sizes 32–2048)
logos/<project>/src/   design sources (.ai)
```

## Proof of authorship

Authorship and creation dates are backed by several independent records:

- **`CHECKSUMS.sha256`** — SHA-256 hashes of every file in `logos/`.
- **OpenTimestamps** — `CHECKSUMS.sha256.ots` anchors the checksum file in the
  Bitcoin blockchain, proving that every listed file existed no later than the
  block time. Verify with `ots verify CHECKSUMS.sha256.ots`.
- **Signed commits** — every commit is signed by the author.
- **GitHub history** — the public repository history at
  [github.com/Mimic890/logos](https://github.com/Mimic890/logos).

## Adding a logo

1. Put the files into `logos/<project>/` (`svg/`, `png/`, `src/`).
2. Add a row to the table above.
3. Run `scripts/stamp.fish` to rebuild `CHECKSUMS.sha256` and create a new
   timestamp
   (requires `pip install opentimestamps-client`).
4. Commit with a signed commit and push.
5. A few hours later, once the timestamp is confirmed in Bitcoin, run
   `scripts/stamp.fish upgrade` and commit the updated `.ots` file.
