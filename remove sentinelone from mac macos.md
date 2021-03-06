# remove SentinelOne from MacOS

In case SentinelOne is causing issues, for example when you just upgraded your macbook, this procedure can be used to completely remove SentinerOne.

Running mojave and Safari and system preferences are crashing?
https://discussions.apple.com/thread/8553181

Another use case could be when you can't remove SentinelOne the normal way. This happened me once running Mojave (uninstall started from management tooling, MacOS just reboots instantly).

## In a hurry?

If you are in a hurry follow these steps.
Caveats:
1. Will work if you know your way around
2. not a complete removal.

* Boot your Mac directly in Recovery OS

this example assumes your volume label is "Macintosh HD"
You may need to unlock it first make sure the disk is mounted, will not be mounted automatically if disk encryption is used (which you should have)


* In Recovery OS, chroot to your system volume. 
```
chroot /Volumes/Macintosh\ HD/
```
* Now remove the kernel extention using this command:
```
rm -rf /Library/Extensions/Sentinel.kext
```



## Not in a hurry?
### Boot in recovery mode
* Boot the system in revocery mode 
```
Command (⌘)-R: Start up from the built-in macOS Recovery system. 
```
Or 
```
use Option-Command-R or Shift-Option-Command-R to start up from macOS Recovery over the Internet. macOS Recovery installs different versions of macOS, depending on the key combination you use while starting up. 
```

* Select Disk utility
https://support.apple.com/library/content/dam/edam/applecare/images/en_US/macos/highsierra/macos-high-sierra-recovery-mode-reinstall.jpg

mount / activeer disk

sluit disk utility


verwijderen sentinelone mac os x macos




Command (⌘)-R: Start up from the built-in macOS Recovery system. 

Or use Option-Command-R or Shift-Option-Command-R to start up from macOS Recovery over the Internet. macOS Recovery installs different versions of macOS, depending on the key combination you use while starting up. If your Mac is using a firmware password, you're asked to enter the password.

selecteer disk utility
https://support.apple.com/library/content/dam/edam/applecare/images/en_US/macos/highsierra/macos-high-sierra-recovery-mode-reinstall.jpg

mount / activeer disk

sluit disk utility

start terminal
http://i.i.cbsi.com/cnwk.1d/i/tim/2011/08/03/Recovery1.png

type 
sudo su
chroot /Volume/Macntosh HD/
https://www.howtogeek.com/wp-content/uploads/2017/12/mounted-volumes.png.pagespeed.ce.fu4JlUoWsx.png
wellich is de disk al gemount, deze stap is vooral belangrijk wanneer de disk versleuteld is. 

controleer of het de goede disk is door ls te doen in /Users
controleer of je mag schrijven door echo bla > /test

nu kun je de services, drivers (kext) en agent componenten verwijderen

### Kernel extention removal
This is in fact the only essential step
(feitelijk is dit de belangrijkste, enige essentiele stap)

```
rm -rf /Library/Extensions/Sentinel.kext
rm -rf /Library/Extensions/Sentinel.kext/Contents
rm -rf /Library/Extensions/Sentinel.kext/Contents/Info.plist
rm -rf /Library/Extensions/Sentinel.kext/Contents/MacOS
rm -rf /Library/Extensions/Sentinel.kext/Contents/MacOS/Sentinel
rm -rf /Library/Extensions/Sentinel.kext/Contents/Resources
rm -rf /Library/Extensions/Sentinel.kext/Contents/Resources/en.lproj
rm -rf /Library/Extensions/Sentinel.kext/Contents/Resources/en.lproj/InfoPlist.strings
rm -rf /Library/Extensions/Sentinel.kext/Contents/_CodeSignature
rm -rf /Library/Extensions/Sentinel.kext/Contents/_CodeSignature/CodeResources
```

### Remove the services

```
launchctl remove com.sentinelone.sentineld-helper
launchctl remove com.sentinelone.sentineld-updater
launchctl remove com.sentinelone.sentineld
launchctl remove com.sentinelone.sentineld-guard
```

### Agent removal and cleanup

```
rm -rf /Library/LaunchAgents/com.sentinelone.agent.plist
rm -rf /Library/LaunchDaemons/com.sentinelone.sentineld-guard.plist
rm -rf /Library/LaunchDaemons/com.sentinelone.sentineld-helper.plist
rm -rf /Library/LaunchDaemons/com.sentinelone.sentineld-updater.plist
rm -rf /Library/LaunchDaemons/com.sentinelone.sentineld.plist
rm -rf /Library/Preferences/Logging/Subsystems/com.sentinelone.sentinelctl.plist
rm -rf /Library/Preferences/Logging/Subsystems/com.sentinelone.sentineld-guard.plist
rm -rf /Library/Preferences/Logging/Subsystems/com.sentinelone.sentineld-helper.plist
rm -rf /Library/Preferences/Logging/Subsystems/com.sentinelone.sentineld-updater.plist
rm -rf /Library/Preferences/Logging/Subsystems/com.sentinelone.sentineld.plist
rm -rf /Library/Sentinel
rm -rf /Library/Sentinel/sentinel-agent.bundle
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Resources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Sentinel
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/A
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/A/Resources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/A/Resources/Info.plist
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/A/Sentinel
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/A/_CodeSignature
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/A/_CodeSignature/CodeResources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/Sentinel.framework/Versions/Current
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Frameworks/sentinel.dylib
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Info.plist
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Info.plist
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/MacOS
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/MacOS/SentinelAgent
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/AppIcon.icns
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/Assets.car
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/Base.lproj
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/Base.lproj/MainMenu.nib
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/CellView.nib
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/DebugMenu.nib
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/MenuPopupView.nib
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/divider.tiff
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/en.lproj
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/en.lproj/InfoPlist.strings
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/en.lproj/Localizable.strings
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/greenBadge.tiff
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/logo.tiff
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/Resources/redBadge.tiff
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/_CodeSignature
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/SentinelAgent.app/Contents/_CodeSignature/CodeResources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sdiagnose
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentineld
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentineld_guard
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentineld_helper
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentineld_updater
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/COPYRIGHT
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets/arbiter.db
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets/arbiter.db.sig
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets/signatures.db
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets/signatures.db.sig
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets/whitelist-ext.db
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/assets/whitelist-ext.db.sig
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/common.sb
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/en.lproj
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/en.lproj/InfoPlist.strings
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/guard.sb
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/helper.sb
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/sentinel-labs.cer
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/sentineld.sb
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/sentinelone.cer
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/uninstall.sh
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/Resources/whitelist-ext.json
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/_CodeSignature
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/_CodeSignature/CodeDirectory
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/_CodeSignature/CodeRequirements
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/_CodeSignature/CodeRequirements-1
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/_CodeSignature/CodeResources
rm -rf /Library/Sentinel/sentinel-agent.bundle/Contents/_CodeSignature/CodeSignature
rm -rf /private/etc/asl/com.sentinelone.sentinel
rm -rf /usr/local/share/man/man1/sentinelctl.1
```


## Authors

* **Bert van der Lingen 

