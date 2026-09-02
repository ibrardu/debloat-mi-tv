My Xiaomi Android TV was drowning in ads and "recommended for you" rows I never
asked for. Instead of rooting it (which drops the Widevine cert and kills
Netflix HD), I handed an AI coding agent a prompt and had it debloat the TV
over plain ADB — nothing but `pm disable-user`, fully reversible, no
uninstalls.

What actually happened:
→ Measured RAM and packages before touching anything
→ Disabled 32 factory/bloat packages in small, tested batches
→ Hit a real regression along the way — one package turned out to control the
  remote's hardware Input/Settings/Info buttons. The agent caught it,
  bisected it down to the exact package, and fixed it before continuing
→ Swapped the ad-laden stock Google TV home screen for FLauncher (open
  source, just a clean app grid) — the OEM had hidden the "set default
  launcher" option in Settings, so it went through ADB's Role Manager instead
→ Verified everything survived a full reboot

Prompt adapted from Mert Çobanov's excellent guide: https://tv.cobanov.dev/

Full before/after, the complete log (including the regression + fix), and a
one-command undo script are here: [repo link]

#AndroidTV #ADB #AI #Debloat
