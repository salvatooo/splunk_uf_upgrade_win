@echo off

set VERSION=8.2.8-da25d08d5d3e
set UPGRADE_FILE="%~dp0\splunkforwarder-%VERSION%-x64-release.msi"
set MANIFEST_FILE=splunkforwarder-%VERSION%-windows-64-manifest
set LOG_FILE=%SPLUNK_HOME%\var\log\splunk\uf_upgrade-%VERSION%.log

:: Check for MANIFEST_FILE file in SPLUNK_HOME
IF EXIST "%SPLUNK_HOME%\%MANIFEST_FILE%" (
   echo [%date% %time%] %SPLUNK_HOME%\%MANIFEST_FILE% exists...exiting >> "%LOG_FILE%"
   exit 1
) ELSE (
   echo [%date% %time%] %SPLUNK_HOME%\%MANIFEST_FILE% does not exists, proceed to upgrade...  >> "%LOG_FILE%"
   echo [%date% %time%] Stopping Splunk UniversalForwarder...  >> "%LOG_FILE%""
   "%SPLUNK_HOME%\bin\splunk.exe" stop
   echo [%date% %time%] Going to run msiexec.exe /i %UPGRADE_FILE% /L*V "%SPLUNK_HOME%\var\log\splunk\uf_msi-%VERSION%.log" AGREETOLICENSE=Yes /quiet >> "%LOG_FILE%"
   msiexec.exe /i %UPGRADE_FILE% /L*V "%SPLUNK_HOME%\var\log\splunk\uf_msi-%VERSION%.log" AGREETOLICENSE=Yes /quiet
)
