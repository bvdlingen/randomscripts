@echo off

# /MIR: mirror directory option: it removes/purges files from the destination that no longer exist in the source
# /MT: the multithreading option
# /copy:DATSOU Copy Data, Attributes, Time Stamps, Security, Owner, aUditing information
# /E Copy subdirectories recursively, (including empty ones.)
# /ZB Use ‘restartable’ mode, and if this fails use ‘backup’ mode
# /copy:DATSOU Copy Data, Attributes, Time Stamps, Security, Owner, aUditing information
# /R:3 Retry three times, if you don’t specify this, it will retry one million times!
# /W:3 Wait time between the retries above
# /log Will output the log to the folder we created above
# /V: output in verbose (detailed) mode

cls
:start
echo start 

robocopy \\fs01\d$\FOLDER\ \\nas01\share\ /e /zb /copy:DATSOU /MIR /r:1 /w:1 /log:c:\users\%username%\desktop\robocopy\%date%.log /V /MT:32

goto start
