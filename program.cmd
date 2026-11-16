@echo off
rem Load ADC_8.sof into the board over JTAG (lost at power-off).
cd /d "%~dp0"
C:\altera_lite\25.1std\quartus\bin64\quartus_pgm -l
C:\altera_lite\25.1std\quartus\bin64\quartus_pgm -c "USB-Blaster [USB-0]" -m JTAG -o "p;ADC_8.sof@1"
