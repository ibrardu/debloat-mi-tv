# TV Debloat Log — MiTV_MOOQ0 (192.168.8.161)

Device: `MiTV_MOOQ0` (product `croods`), MediaTek Amelie platform.
Connected via `adb connect 192.168.8.161:5555`.

Rule followed throughout: **only `pm disable-user --user 0`, never `pm uninstall`.**
Every entry below can be undone with the exact `pm enable` command listed.

## Baseline (before any changes) — captured 2026-09-02

- `meminfo-before.txt`, `packages-system-before.txt`, `packages-disabled-before.txt`, `packages-all-before.txt`
- Total RAM: 1,740,488K / Free RAM: 571,039K / Used RAM: 1,296,260K
- System packages: 122, Disabled packages: 0, Total packages: 126

## Untouchable list — additions found during testing

| Package | Why |
|---|---|
| `com.xiaomi.android.tvsetup.partnercustomizer` | Confirmed to control hardware remote button routing (Input/Settings/Info/Xiaomi/Channel). Disabling it breaks direct hardware button presses, even though on-screen navigation to the same functions still works. **Do not disable.** |
| `com.expressvpn.vpn` | User relies on this for split-tunnel VPN access to Indian OTT apps (Zee5/Hotstar). Was briefly disabled as part of Batch 2, immediately re-enabled at user's request. **Keep enabled.** |

## Platform notes

This is a Xiaomi/MiTV device on MediaTek's "croods/Amelie" platform, not TCL as the
original checklist assumed. Untouchable-list packages were re-mapped to this
platform's equivalents:
- Inputs/HDMI stack: `com.mediatek.tv.service`, `com.mediatek.tvinput`, `com.mediatek.wwtv.tvcenter`
- Suspected quick-settings/Inputs panel: `com.xiaomi.tvqs.overseas` (not touched, unverified)
- Home screen (this device has no `launcherx`): `com.google.android.tvlauncher`
- Live TV/EPG data: `com.android.providers.tv`

## Batch 1 — disabled 2026-09-02

| Package | What it was | Undo command |
|---|---|---|
| fusion.android.tv.demo | Retail store demo-mode app | `adb shell pm enable fusion.android.tv.demo` |
| mediatek.factorymenu.ui | Factory test/diagnostics menu | `adb shell pm enable mediatek.factorymenu.ui` |
| com.android.dreams.basic | Stock Android screensaver | `adb shell pm enable com.android.dreams.basic` |
| com.mitv.dream | Xiaomi ambient-mode screensaver | `adb shell pm enable com.mitv.dream` |
| com.mstar.android.tv.disclaimercustomization | One-time legal disclaimer screen | `adb shell pm enable com.mstar.android.tv.disclaimercustomization` |
| com.mediatek.wwtv.setupwizard | MediaTek first-run setup wizard | `adb shell pm enable com.mediatek.wwtv.setupwizard` |
| com.xiaomi.mitv.manualhelp | Built-in "user manual" app | `adb shell pm enable com.xiaomi.mitv.manualhelp` |
| com.xiaomo.tv.milegal | Legal/licenses screen | `adb shell pm enable com.xiaomo.tv.milegal` |
| com.xiaomi.statistic | Xiaomi telemetry/analytics | `adb shell pm enable com.xiaomi.statistic` |

**Regression found and fixed 2026-09-02.** After the initial 10-package Batch 1,
the remote's dedicated hardware buttons (Input, Settings, Info, Xiaomi button,
Channel) stopped responding directly — though navigating to the same functions
on-screen via the joystick/d-pad and pressing select still worked. HDMI, Netflix,
YouTube, sound, and on-screen keyboard were unaffected.

Per rule 7, all 10 were re-enabled, then re-disabled one at a time to isolate the
cause:
- `mediatek.factorymenu.ui` disabled alone → buttons OK
- `com.mediatek.wwtv.setupwizard` also disabled → buttons OK
- `com.xiaomi.android.tvsetup.partnercustomizer` also disabled → **buttons broke**
- `com.xiaomi.android.tvsetup.partnercustomizer` re-enabled alone → buttons OK again (confirmed twice)

**Root cause: `com.xiaomi.android.tvsetup.partnercustomizer` intercepts/maps the
hardware key codes for Input/Settings/Info/Xiaomi/Channel on this remote.** It has
been moved to the untouchable list and is permanently re-enabled — do not disable it.

The other 9 original Batch 1 packages were then disabled together and the full
test suite (hardware buttons, HDMI, Netflix, YouTube, sound, keyboard) passed.
Batch 1 is considered complete with this final set of 9 (table above, minus the
`partnercustomizer` row).

## Batch 2 — disabled 2026-09-02

| Package | What it was | Undo command |
|---|---|---|
| com.google.android.feedback | Google diagnostic feedback agent | `adb shell pm enable com.google.android.feedback` |
| com.google.android.onetimeinitializer | One-time Google account setup helper | `adb shell pm enable com.google.android.onetimeinitializer` |
| com.google.android.tvrecommendations | Powers the "Recommended for you" row on the home screen | `adb shell pm enable com.google.android.tvrecommendations` |
| com.google.android.tv.frameworkpackagestubs | Stub handler app | `adb shell pm enable com.google.android.tv.frameworkpackagestubs` |
| com.google.android.backdrop | Ambient photo/screensaver content service | `adb shell pm enable com.google.android.backdrop` |
| com.google.android.marvin.talkback | Accessibility screen reader (unused) | `adb shell pm enable com.google.android.marvin.talkback` |
| com.google.android.partnersetup | OEM partner setup wizard | `adb shell pm enable com.google.android.partnersetup` |
| com.google.android.boot.appsplashscreen | Boot splash screen config helper | `adb shell pm enable com.google.android.boot.appsplashscreen` |

**Status: confirmed working.** Recommendation row reduced, remote/HDMI/Netflix/
YouTube/sound/keyboard all fine.

## Batch 3 — ad-source hunt — disabled 2026-09-02

| Package | What it was | Undo command |
|---|---|---|
| com.mitv.tvhome.michannel | Xiaomi "MiChannel" home-screen content service | `adb shell pm enable com.mitv.tvhome.michannel` |
| com.mitv.tvhome.mitvplus | Xiaomi "MiTV Plus" home-screen content service | `adb shell pm enable com.mitv.tvhome.mitvplus` |

Result: removed the "Sponsored" text label, confirmed no functional impact
(Xiaomi remote button still works fine). But a promotional/recommendation banner
(e.g. suggesting apps not installed, like Disney+) still appears on the home
screen. Conclusion: this banner is baked into `com.google.android.tvlauncher`
itself (the stock Google TV launcher's own discovery row), not a separate
disableable service. **Decision: stop hunting, replace the launcher with
FLauncher instead of disabling more packages.**

Note: `com.expressvpn.vpn` was briefly disabled in Batch 2 and immediately
re-enabled — user needs it for split-tunnel VPN to Indian OTT apps. See
untouchable list above.

## Launcher swap — FLauncher — 2026-09-02

1. User installed FLauncher (`me.efesser.flauncher`) from the Play Store.
2. This OEM build hides the "default Home app" picker in Settings entirely, so
   two ADB steps were needed instead of the usual Settings UI flow:
   - `adb shell cmd role add-role-holder --user 0 android.app.role.HOME me.efesser.flauncher`
     (registers FLauncher as the Home role holder — this is the modern Android
     equivalent of "set as default launcher")
   - Verified with `adb shell dumpsys role | grep -A3 android.app.role.HOME`
3. Confirmed FLauncher itself launches and renders correctly
   (`adb shell am start -n me.efesser.flauncher/.MainActivity`) — clean app grid,
   no ads, no recommendation rows.
4. Home button still opened the old launcher until the old launcher's activity
   task was cleared. Disabled `com.google.android.tvlauncher` (with user's
   explicit approval, since FLauncher was already confirmed installed and
   working, satisfying the original precondition for this step):
   `adb shell pm disable-user --user 0 com.google.android.tvlauncher`
   Undo: `adb shell pm enable com.google.android.tvlauncher`
5. Result: Home button now opens FLauncher directly. The promotional/ad banner
   (e.g. "Dark Matter" / Disney+ suggestion) that persisted through Batches 1–3
   is gone, confirming it was part of the old launcher's own UI, not a separate
   background service.

**Status: CONFIRMED after full reboot.** FLauncher persists as the home screen,
ad/recommendation banner is gone, all functionality (hardware remote buttons,
HDMI, Netflix, YouTube, sound, keyboard) intact.

## Animation speed + cache trim — 2026-09-02

```
adb shell settings put global window_animation_scale 0.5
adb shell settings put global transition_animation_scale 0.5
adb shell settings put global animator_duration_scale 0.5
adb shell pm trim-caches 1G
```

## After measurements — captured 2026-09-02 (post-reboot)

- Total RAM: 1,740,488K / Free RAM: 589,808K / Used RAM: 1,274,126K
- System packages: 122, Disabled packages: 20, Total packages: 127

## Batch 4 — unused Group 2 apps — disabled 2026-09-02

User confirmed via review of the original Group 2 list that these two are unused:

| Package | What it was | Undo command |
|---|---|---|
| com.xiaomi.mimusic2 | Mi Music player app | `adb shell pm enable com.xiaomi.mimusic2` |
| com.xiaomi.amazon.alexa | Alexa voice/app integration | `adb shell pm enable com.xiaomi.amazon.alexa` |

**Status: CONFIRMED.** Hardware remote buttons, Netflix, YouTube, and sound all working.

## Batch 5 — remaining Group 2 items — disabled 2026-09-02

User reviewed the rest of the original Group 2 list. Kept enabled: Google
Assistant/search bar (`katniss`), text-to-speech (`tts`), Xiaomi TV Manager
(`tvmanager`), OTA update service (`updateservice`), Mi account cloud sync
(`overseaservice`) — all confirmed in use.

Disabled:

| Package | What it was | Undo command |
|---|---|---|
| com.google.android.play.games | Play Games (unused) | `adb shell pm enable com.google.android.play.games` |
| com.mitv.tvlock | Parental/TV lock feature (unused) | `adb shell pm enable com.mitv.tvlock` |
| com.android.providers.calendar | Calendar sync provider | `adb shell pm enable com.android.providers.calendar` |
| com.android.providers.contacts | Contacts sync provider | `adb shell pm enable com.android.providers.contacts` |
| com.android.providers.contacts.auto_generated_rro_product__ | Contacts provider theme overlay | `adb shell pm enable com.android.providers.contacts.auto_generated_rro_product__` |
| com.android.printspooler | Print spooler | `adb shell pm enable com.android.printspooler` |
| com.android.htmlviewer | Local HTML file viewer (not used by WebView/Play Services) | `adb shell pm enable com.android.htmlviewer` |
| com.android.soundpicker | System sound picker | `adb shell pm enable com.android.soundpicker` |
| com.android.statementservice | App-link domain verification | `adb shell pm enable com.android.statementservice` |
| com.android.wallpaperbackup | Wallpaper backup | `adb shell pm enable com.android.wallpaperbackup` |

**Status: CONFIRMED.** Netflix playback, Prime Video, HDMI, sound, keyboard, and hardware remote buttons all tested working.

## One-command undo

Run `bash undo-all.sh` in this folder (requires `adb connect 192.168.8.161:5555`
first) to re-enable every package this session disabled and restore default
animation speeds, then `adb reboot`.
