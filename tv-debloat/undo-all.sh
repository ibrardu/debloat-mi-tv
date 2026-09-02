#!/bin/bash
# Re-enables every package this debloat session disabled, and restores default animation speeds.
# Usage: bash undo-all.sh   (requires adb connected to the TV: adb connect 192.168.8.161:5555)

PKGS=(
  fusion.android.tv.demo
  mediatek.factorymenu.ui
  com.android.dreams.basic
  com.mitv.dream
  com.mstar.android.tv.disclaimercustomization
  com.mediatek.wwtv.setupwizard
  com.xiaomi.mitv.manualhelp
  com.xiaomo.tv.milegal
  com.xiaomi.statistic
  com.google.android.feedback
  com.google.android.onetimeinitializer
  com.google.android.tvrecommendations
  com.google.android.tv.frameworkpackagestubs
  com.google.android.backdrop
  com.google.android.marvin.talkback
  com.google.android.partnersetup
  com.google.android.boot.appsplashscreen
  com.mitv.tvhome.michannel
  com.mitv.tvhome.mitvplus
  com.google.android.tvlauncher
  com.xiaomi.mimusic2
  com.xiaomi.amazon.alexa
  com.google.android.play.games
  com.mitv.tvlock
  com.android.providers.calendar
  com.android.providers.contacts
  com.android.providers.contacts.auto_generated_rro_product__
  com.android.printspooler
  com.android.htmlviewer
  com.android.soundpicker
  com.android.statementservice
  com.android.wallpaperbackup
)

for pkg in "${PKGS[@]}"; do
  adb shell pm enable "$pkg"
done

adb shell settings put global window_animation_scale 1
adb shell settings put global transition_animation_scale 1
adb shell settings put global animator_duration_scale 1

echo "Done. Reboot the TV to fully restore the original Google TV home screen: adb reboot"
