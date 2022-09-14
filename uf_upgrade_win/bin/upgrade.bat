@echo off
:: ########################################################
:: This is a Splunk App to upgrade UF via deployment server
:: Author: Raymond Ang
:: Date: 14 Sept 2022
:: ########################################################

:: Set the version to upgrade to
set VERSION=8.2.8-da25d08d5d3e

:: No changes required from here onwards
set UPGRADE_FILE=%~dp0\splunkforwarder-%VERSION%-x64-release.msi
set MANIFEST_FILE=splunkforwarder-%VERSION%-windows-64-manifest
set LOG_FILE=%SPLUNK_HOME%\var\log\splunk\uf_upgrade-%VERSION%.log
set MSILOG_FILE=%SPLUNK_HOME%\var\log\splunk\uf_msi-%VERSION%.log

:: Check if MANIFEST_FILE exists in SPLUNK_HOME
IF EXIST "%SPLUNK_HOME%\%MANIFEST_FILE%" (
   echo [%date% %time%] %SPLUNK_HOME%\%MANIFEST_FILE% exists...exiting >> "%LOG_FILE%"
   exit 1
) ELSE (
   :: Check if an upgrade has been attempted before and failed
   IF EXIST "%MSILOG_FILE%" (
      echo [%date% %time%] %MSILOG_FILE% exists. An upgrade has been attempted and failed...exiting >> "%LOG_FILE%"
      exit 1
   ) ELSE (
      echo [%date% %time%] %SPLUNK_HOME%\%MANIFEST_FILE% does not exists, proceed to upgrade...  >> "%LOG_FILE%"
      echo [%date% %time%] Stopping Splunk UniversalForwarder...  >> "%LOG_FILE%"
      "%SPLUNK_HOME%\bin\splunk.exe" stop
      echo [%date% %time%] Going to run msiexec.exe /i "%UPGRADE_FILE%" /L*V "%MSILOG_FILE%" AGREETOLICENSE=Yes /quiet >> "%LOG_FILE%"
      msiexec.exe /i "%UPGRADE_FILE%" /L*V "%MSILOG_FILE%" AGREETOLICENSE=Yes /quiet
   )
)
