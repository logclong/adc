@echo off
rem Full compile of the Lab 8 project (ADC_8). Output: ADC_8.sof in this folder, log in build.log.
cd /d "%~dp0"
C:\altera_lite\25.1std\quartus\bin64\quartus_sh --flow compile ADC_8 > build.log 2>&1
findstr /B /C:"Error" build.log
findstr /C:"Full Compilation was" build.log
