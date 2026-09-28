@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Guc Planlari Kurulumu - Denge / Oyun / Pil v8.6 Final
color 0A
cd /d "%~dp0"

set "DENGELI=381b4222-f694-41f0-9685-ff5bb260df2e"
set "DENGE=5d1b8f42-7a3c-4e91-b6d0-2c94a17e35f1"
set "OYUN=8e4a2c73-1f5b-4d86-9a02-6b3d7c81e4a9"
set "PIL=2f9c6b15-c8d4-47e3-a15f-0d7b3e92a648"

set "EPP=36687f9e-e3a5-4dbf-b1dc-15eb381c6863"
set "EPP1=36687f9e-e3a5-4dbf-b1dc-15eb381c6864"

set "RAPOR=%~dp0guc-planlari-rapor.txt"
set "PLAN_HATA=0"
set "KISAYOL_HATA=0"
set "FARKLI=0"
set "KRITIK_YAZMA_HATASI=0"
set "OPSIYONEL_YAZMA_HATASI=0"
set "ESKI_PLAN="

if exist "%RAPOR%" del /f /q "%RAPOR%" >nul 2>&1

net session >nul 2>&1
if errorlevel 1 (
    echo [!] Bu kurulum icin Yonetici yetkisi gerekiyor. Yonetici olarak baslatiliyor...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

(
echo ============================================================
echo GUC PLANLARI KURULUM RAPORU
echo Tarih: %date% %time%
echo ============================================================
echo.
) > "%RAPOR%"

for /f "tokens=2 delims=:" %%A in ('powercfg /getactivescheme 2^>nul') do (
    for /f "tokens=1" %%B in ("%%A") do set "ESKI_PLAN=%%B"
)

if defined ESKI_PLAN (
    echo [*] Eski aktif plan: !ESKI_PLAN! >> "%RAPOR%"
)

call :PlanHazirla "%DENGE%" "Denge"
if errorlevel 1 set "PLAN_HATA=1"
call :PlanHazirla "%OYUN%" "Oyun"
if errorlevel 1 set "PLAN_HATA=1"
call :PlanHazirla "%PIL%" "Pil"
if errorlevel 1 set "PLAN_HATA=1"

if "!PLAN_HATA!"=="1" goto :FAIL_INIT

:: ============================================================
:: 1. DENGE PLANI (Dengeli-Serin / Fisilti Sessizligi)
:: ============================================================
call :AyarKritik %DENGE% SUB_PROCESSOR PROCTHROTTLEMIN 5
call :AyarKritik %DENGE% SUB_PROCESSOR PROCTHROTTLEMAX 100
call :AyarKritik %DENGE% SUB_PROCESSOR PERFBOOSTMODE 0
call :AyarKritik %DENGE% SUB_PROCESSOR %EPP% 60
call :AyarOpsiyonel %DENGE% SUB_PROCESSOR %EPP1% 60
call :AyarKritik %DENGE% SUB_PROCESSOR CPMINCORES 10
call :AyarKritik %DENGE% SUB_PROCESSOR CPMAXCORES 100
call :AyarOpsiyonelAC %DENGE% SUB_PROCESSOR SYSCOOLPOL 1
call :AyarOpsiyonelDC %DENGE% SUB_PROCESSOR SYSCOOLPOL 0

:: ============================================================
:: 2. OYUN PLANI (Tam Performans / Bosta Sakin)
:: ============================================================
call :AyarKritik %OYUN% SUB_PROCESSOR PROCTHROTTLEMIN 5
call :AyarKritik %OYUN% SUB_PROCESSOR PROCTHROTTLEMAX 100
call :AyarKritik %OYUN% SUB_PROCESSOR PERFBOOSTMODE 2
call :AyarKritik %OYUN% SUB_PROCESSOR %EPP% 0
call :AyarOpsiyonel %OYUN% SUB_PROCESSOR %EPP1% 0
call :AyarKritik %OYUN% SUB_PROCESSOR CPMINCORES 100
call :AyarKritik %OYUN% SUB_PROCESSOR CPMAXCORES 100
call :AyarOpsiyonel %OYUN% SUB_PROCESSOR SYSCOOLPOL 1
call :AyarOpsiyonel %OYUN% SUB_USB USBSELECTIVE 0
call :AyarOpsiyonel %OYUN% SUB_PCIEXPRESS ASPM 0

:: ============================================================
:: 3. PIL PLANI (Maksimum Tasarruf ve Pil Korumasi)
:: ============================================================
call :AyarKritik %PIL% SUB_PROCESSOR PROCTHROTTLEMIN 5
call :AyarKritik %PIL% SUB_PROCESSOR PROCTHROTTLEMAX 100
call :AyarKritik %PIL% SUB_PROCESSOR PERFBOOSTMODE 0
call :AyarKritik %PIL% SUB_PROCESSOR %EPP% 70
call :AyarOpsiyonel %PIL% SUB_PROCESSOR %EPP1% 80
call :AyarKritik %PIL% SUB_PROCESSOR CPMINCORES 10
call :AyarKritik %PIL% SUB_PROCESSOR CPMAXCORES 100
call :AyarOpsiyonel %PIL% SUB_PROCESSOR SYSCOOLPOL 0
call :AyarOpsiyonel %PIL% SUB_VIDEO VIDEONORMALLEVEL 40
call :AyarOpsiyonel %PIL% SUB_VIDEO VIDEOIDLE 120
call :AyarOpsiyonel %PIL% SUB_SLEEP STANDBYIDLE 300
call :AyarOpsiyonel %PIL% SUB_USB USBSELECTIVE 1
call :AyarOpsiyonel %PIL% SUB_PCIEXPRESS ASPM 2

:: ============================================================
:: KISAYOLLARIN MASAUSTUNE YAZILMASI
:: ============================================================
powershell -NoProfile -Command ^
"$err=0; $d=[Environment]::GetFolderPath('Desktop'); $w=New-Object -ComObject WScript.Shell; foreach($p in @(@('Denge','%DENGE%'),@('Oyun','%OYUN%'),@('Pil','%PIL%'))){ $f=Join-Path $d ($p[0]+'.lnk'); $s=$w.CreateShortcut($f); $s.TargetPath=($env:SystemRoot+'\System32\powercfg.exe'); $s.Arguments='-setactive '+$p[1]; $s.WorkingDirectory=$env:SystemRoot+'\System32'; $s.WindowStyle=7; $s.Save(); if(Test-Path $f){Write-Host ('    Kisayol hazir: '+$p[0])}else{Write-Host ('    [!] Kisayol HATASI: '+$p[0]); $err=1} }; if($err -eq 1){exit 5}"

if errorlevel 5 (
    set "KISAYOL_HATA=1"
    echo [UYARI] Bazi kisayollar masaustune eklenemedi. >> "%RAPOR%"
)

call :DogrulaPlan %DENGE%
call :DogrulaPlan %OYUN%
call :DogrulaPlan %PIL%

(
echo.
echo ============================================================
echo TAM POWERCFG QUERY RAPORU
echo ============================================================
powercfg /query %DENGE%
powercfg /query %OYUN%
powercfg /query %PIL%
) >> "%RAPOR%" 2>&1

if not "!FARKLI!"=="0" goto :FAIL_VALIDATION
if not "!KRITIK_YAZMA_HATASI!"=="0" goto :FAIL_VALIDATION
goto :SUCCESS_END

:SUCCESS_END
powercfg /setactive %DENGE% >nul 2>&1
if errorlevel 1 (
    echo [HATA] Denge plani aktif edilemedi! >> "%RAPOR%"
    if defined ESKI_PLAN powercfg /setactive !ESKI_PLAN! >nul 2>&1
    pause
    endlocal
    exit /b 3
)

echo.
echo ============================================================
echo KURULUM BASARIYLA TAMAMLANDI!
echo Masaustune Denge, Oyun ve Pil kisayollari eklendi.
echo Denge plani varsayilan olarak aktiflestirildi.
echo ============================================================
pause
endlocal
exit /b 0

:FAIL_INIT
echo KURULUM BASARISIZ (Hazirlik Asamasi)
if defined ESKI_PLAN powercfg /setactive !ESKI_PLAN! >nul 2>&1
pause
endlocal
exit /b 1

:FAIL_VALIDATION
echo DOGRULAMA BASARISIZ (Kritik Ayar Uyumsuzlugu)
echo Ayrintilar icin guc-planlari-rapor.txt dosyasina bakin.
if defined ESKI_PLAN powercfg /setactive !ESKI_PLAN! >nul 2>&1
pause
endlocal
exit /b 2

:PlanHazirla
set "PGUID=%~1"
set "PNAME=%~2"
powercfg /list | find /i "%PGUID%" >nul 2>&1
if errorlevel 1 (
    powercfg -duplicatescheme %DENGELI% %PGUID% >nul 2>&1
    if errorlevel 1 exit /b 1
)
powercfg -changename %PGUID% "%PNAME%" "Ozel guc plani - %PNAME%" >nul 2>&1
exit /b 0

:AyarKritik
powercfg /setacvalueindex %~1 %~2 %~3 %~4 >nul 2>&1
if errorlevel 1 set /a KRITIK_YAZMA_HATASI+=1
powercfg /setdcvalueindex %~1 %~2 %~3 %~4 >nul 2>&1
if errorlevel 1 set /a KRITIK_YAZMA_HATASI+=1
exit /b 0

:AyarOpsiyonel
powercfg /setacvalueindex %~1 %~2 %~3 %~4 >nul 2>&1
if errorlevel 1 set /a OPSIYONEL_YAZMA_HATASI+=1
powercfg /setdcvalueindex %~1 %~2 %~3 %~4 >nul 2>&1
if errorlevel 1 set /a OPSIYONEL_YAZMA_HATASI+=1
exit /b 0

:AyarOpsiyonelAC
powercfg /setacvalueindex %~1 %~2 %~3 %~4 >nul 2>&1
if errorlevel 1 set /a OPSIYONEL_YAZMA_HATASI+=1
exit /b 0

:AyarOpsiyonelDC
powercfg /setdcvalueindex %~1 %~2 %~3 %~4 >nul 2>&1
if errorlevel 1 set /a OPSIYONEL_YAZMA_HATASI+=1
exit /b 0

:DogrulaPlan
powercfg /query %~1 2>nul | find /i "Power Setting GUID" >nul 2>&1
if errorlevel 1 set /a FARKLI+=1
exit /b 0
