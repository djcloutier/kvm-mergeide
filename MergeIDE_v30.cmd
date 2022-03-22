@echo off

rem Fenster-Titel

 title MergeIDE v3.0

rem Windows-Verzeichnis auslesen / abfragen

 cls

 echo.
 echo Achtung:
 echo.
 echo In Rettungsumgebungen ist oft NICHT Laufwerk C:,
 echo sondern Laufwerk D: das Windows-Laufwerk.
 echo.
 
 if exist C:\Windows set MergeideDrive=C:
 if exist D:\Windows set MergeideDrive=D:
 if exist E:\Windows set MergeideDrive=E:
 if exist F:\Windows set MergeideDrive=F:
 
 echo Per Automatik wurde Windows auf dem Laufwerk %MergeideDrive% gefunden.
 echo.
 echo Hinweis:
 echo.
 echo Die Automatik sucht Windows nur auf den Laufwerken C: bis F:.
 echo Dual- und Multi-Boot-Umgebungen werden nicht beruecksichtigt!
 echo.

 echo Bitte bestaetigen Sie, 
 echo das Windows auf Laufwerk %MergeideDrive% installiert ist oder
 echo geben Sie das richtige Laufwerk an.
 echo.
 set /p MergeideDrive=[Laufwerk + ENTER] 
 
rem Betriebssystem auswaehlen

 cls

 echo.
 echo Betriebssystem auswaehlen:
 echo.
 echo [1] Microsoft Windows XP, Server 2003 (R2)
 echo [2] Microsoft Windows Vista, 7, 8, Server 2008 (R2), Server 2012
 echo.
 echo Hinweis:
 echo.
 echo 32- oder 64-bit spielen fuer MergeIDE keine Rolle.
 echo.
 
 set bs=2
 set /p bs=Ihre Wahl [Vorgabe: 2] : 
 
rem Registrierung sichern

 cls
 
 echo.
 echo Registrierung sichern ...
 echo.

 copy %MergeideDrive%\Windows\system32\config\SYSTEM %MergeideDrive%\Windows\system32\config\SYSTEM.bak

rem Registrierung laden

 echo.
 echo Registrierung laden ...
 echo.

 reg LOAD HKLM\SYSTEM_00 %MergeideDrive%\Windows\system32\config\SYSTEM

rem CurrentControlSet auslesen

 echo.
 echo CurrentControlSet auslesen ...
 echo.
 
 for /f "tokens=3" %%i in ('reg query HKLM\SYSTEM_00\Select /v Current') do set ccs=%%i
 
 set ccs=%ccs:~2,1%

rem MergeIDE und AHCI

 echo.
 echo MergeIDE importieren und AHCI aktivieren ...
 echo.
 
 if %ccs%==1 reg import MergeIDE-AHCI-001.reg
 if %ccs%==2 reg import MergeIDE-AHCI-002.reg
 if %ccs%==3 reg import MergeIDE-AHCI-003.reg

 if %bs%==1 goto 1
 if %bs%==2 goto 2

rem MergeIDE fuer Windows XP / Server 2003 (R2)
:1

 rem Treiber sichern
 
 echo.
 echo Treiber sichern ...
 echo.
 
 copy %MergeideDrive%\Windows\System32\Drivers\Atapi.sys %MergeideDrive%\Windows\System32\Drivers\Atapi.bak
 copy %MergeideDrive%\Windows\System32\Drivers\Intelide.sys %MergeideDrive%\Windows\System32\Drivers\Intelide.bak
 copy %MergeideDrive%\Windows\System32\Drivers\Pciide.sys %MergeideDrive%\Windows\System32\Drivers\Pciide.bak
 copy %MergeideDrive%\Windows\System32\Drivers\Pciidex.sys %MergeideDrive%\Windows\System32\Drivers\Pciidex.bak
 
 rem Treiber entpacken und kopieren
 
  echo.
  echo Treiber entpacken ...
  echo.
  
  if exist "%MergeideDrive%\windows\driver cache\i386\sp3.cab" goto sp3 
  if exist "%MergeideDrive%\windows\driver cache\i386\sp2.cab" goto sp2
  if exist "%MergeideDrive%\windows\driver cache\i386\sp1.cab" goto sp1
  if exist "%MergeideDrive%\windows\driver cache\i386\driver.cab" goto keinsp

  :keinsp
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Atapi.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Intelide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Pciide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Pciidex.sys %MergeideDrive%\Windows\System32\Drivers
   goto ende

  :sp1
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp1.cab" -F:Atapi.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp1.cab" -F:Intelide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Pciide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp1.cab" -F:Pciidex.sys %MergeideDrive%\Windows\System32\Drivers
   goto ende

  :sp2
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp2.cab" -F:Atapi.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp2.cab" -F:Intelide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Pciide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp2.cab" -F:Pciidex.sys %MergeideDrive%\Windows\System32\Drivers
   goto ende

  :sp3
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp3.cab" -F:Atapi.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp3.cab" -F:Intelide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\driver.cab" -F:Pciide.sys %MergeideDrive%\Windows\System32\Drivers
   expand "%MergeideDrive%\Windows\Driver Cache\I386\sp3.cab" -F:Pciidex.sys %MergeideDrive%\Windows\System32\Drivers
   goto ende

rem MergeIDE fuer Windows Vista / 7 / 8 / Server 2008 (R2) / Server 2012
:2

 rem Nothing to do yet.

rem Ende
:ende

rem Registrierung entladen

 echo.
 echo Registrierung entladen ...
 echo.

 reg UNLOAD HKLM\SYSTEM_00
 
 echo.
 pause
