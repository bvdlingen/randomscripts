@echo off

rem This batch file copies the `FOLDER` directory from the `fs01\d$` volume to the `nas01\share` share.

rem Define the source and destination folders.
set source_folder="\\fs01\d$\FOLDER"
set destination_folder="\\nas01\share"

rem Enable delayed expansion.
setlocal enabledelayedexpansion

rem Copy the files and directories recursively, including empty ones.
rem Mirror the directory, removing/purging files from the destination that no longer exist in the source.
rem Copy Data, Attributes, Time Stamps, Security, Owner, and Auditing information.
rem Use restartable mode, and if this fails use backup mode.
rem Retry three times, with a 1-second wait between retries.
rem Output the log to the `robocopy` folder on the user's desktop.
rem Output in verbose (detailed) mode.
rem Use 32 threads to copy the files.
robocopy /e /zb /copy:DATSOU /MIR /r:3 /w:1 /log:c:\users\%username%\desktop\robocopy\%date%.log /V /MT:32 ^
  "%source_folder%" "%destination_folder%"

rem Exit the batch file.
goto eof
