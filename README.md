# tv-fix

ADB debloat session for a Xiaomi MiTV_MOOQ0 (MediaTek "croods/Amelie" platform)
Android TV: removing ad/recommendation rows, disabling unused factory apps, and
replacing the stock Google TV home screen with [FLauncher](https://github.com/dbeley/flauncher).

Everything was done with `pm disable-user --user 0` only — no `pm uninstall`,
no rooting, no bootloader unlock. Every change is reversible.

See [tv-debloat/DEBLOAT-LOG.md](tv-debloat/DEBLOAT-LOG.md) for the full batch-by-batch
log (including a hardware-remote-button regression that was found and fixed),
[tv-debloat/kapatilanlar.txt](tv-debloat/kapatilanlar.txt) for the flat list of
disabled packages, [tv-debloat/ORIGINAL-PROMPT.md](tv-debloat/ORIGINAL-PROMPT.md)
for the original task instructions this session followed, and
[tv-debloat/undo-all.sh](tv-debloat/undo-all.sh) to revert everything.
