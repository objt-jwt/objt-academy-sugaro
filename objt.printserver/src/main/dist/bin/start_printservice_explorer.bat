@echo off
REM
REM  Objective PrintService Explorer startup script (without java servicewrapper)
REM

ECHO ====================================================================
ECHO Objective PrintService Explorer Startup
ECHO ====================================================================

REM --------------------------------------------------------------------
REM Path settings
REM --------------------------------------------------------------------
SET OBJT_JRE=./../../java/windows-i586

SET OBJT_DIR=.
SET OBJT_LIB=./../lib
SET OBJT_TMP=./../tmp

REM --------------------------------------------------------------------
REM  Build Classpath
REM --------------------------------------------------------------------
SET OBJT_CLASSPATH=%OBJT_LIB%
REM add all jars in lib
setLocal EnableDelayedExpansion
FOR %%i in ("%OBJT_LIB%\*.jar") do set OBJT_CLASSPATH=!OBJT_CLASSPATH!;%%i

SET OBJT_CLASSPATH=%OBJT_CLASSPATH%;%OBJT_DIR%

REM --------------------------------------------------------------------
REM  Java Option & Properties
REM --------------------------------------------------------------------
SET JAVA_OPTIONS=-server -XX:+UseG1GC -Xmx256m

REM --------------------------------------------------------------------
REM  Application & arguments
REM --------------------------------------------------------------------
SET APPLICATION=objt.printserver.PrintServiceExplorer

REM --------------------------------------------------------------------
REM Start java process
REM --------------------------------------------------------------------

CALL "%OBJT_JRE%\bin\java.exe" %JAVA_OPTIONS% -classpath "%OBJT_CLASSPATH%" %APPLICATION%
