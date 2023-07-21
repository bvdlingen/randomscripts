 

# Remove SentinelOne from macOS

This document explains how to remove SentinelOne from macOS. This procedure saved me several times when beta-testing new MacOS versions .


## Introduction

SentinelOne is a EDR cybersecurity solution that provides protection against malware, ransomware, and other threats. It's great.
However, in some cases, you may need to remove SentinelOne from your Mac. For example when eta-testing new MacOS versions, or when it's your macbook and you are leaving a employer with a SentinelOne contract.


## Instructions

To remove SentinelOne from macOS, you will need to follow these steps:

1. Boot your Mac into Recovery Mode.
2. Open Terminal.
3. Run the following command to remove the kernel extension:


rm -rf /Library/Extensions/Sentinel.kext


**Note:** A kernel extension is a piece of software that runs in the kernel, which is the core of macOS. It is important to remove the kernel extension before removing any other SentinelOne components, as the kernel extension may prevent other components from being removed.

4. Run the following commands to remove the services and agent components:


launchctl remove com.sentinelone.sentineld-helper
launchctl remove com.sentinelone.sentineld-updater
launchctl remove com.sentinelone.sentineld
launchctl remove com.sentinelone.sentineld-guard

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


5. Restart your Mac.

## Conclusion

These instructions have explained how to remove SentinelOne from macOS. If you have any questions, please contact SentinelOne support.

**Additional Notes:**

* If you are unable to boot into Recovery Mode, you can also remove SentinelOne by using a third-party uninstaller.
* Be sure to back up your data before removing SentinelOne, as some files may be deleted during the removal process.
* If you have any problems removing SentinelOne, please contact SentinelOne support for assistance.


I hope these improvements are helpful. Let me know if you have any other questions.
