#!/bin/sh

# ref. http://mk.hatenablog.com/entry/2016/09/24/082145

set -ex

hdiutil attach "/Applications/Install macos Sierra.app/Contents/SharedSupport/InstallESD.dmg" -noverify -nobrowse -mountpoint /Volumes/esd
hdiutil create -o Sierra.cdr -size 7316m -layout SPUD -fs HFS+J
hdiutil attach Sierra.cdr.dmg -noverify -nobrowse -mountpoint /Volumes/iso
asr restore -source /Volumes/esd/BaseSystem.dmg -target /Volumes/iso -noprompt -noverify -erase
rm /Volumes/OS\ X\ Base\ System/System/Installation/Packages
cp -rp /Volumes/esd/Packages /Volumes/OS\ X\ Base\ System/System/Installation
cp -rp /Volumes/esd/BaseSystem.chunklist /Volumes/OS\ X\ Base\ System/
cp -rp /Volumes/esd/BaseSystem.dmg /Volumes/OS\ X\ Base\ System/
hdiutil detach /Volumes/esd
hdiutil detach /Volumes/OS\ X\ Base\ System
hdiutil convert Sierra.cdr.dmg -format UDTO -o Sierra.iso
mv Sierra.iso.cdr Sierra.iso
rm Sierra.cdr.dmg
