@ECHO OFF
SET JAVA_DIR=".\..\..\java\windows-x64\bin"
SET CONFIG_DIR=.\..\config
SET LIB_DIR=.\..\lib

%JAVA_DIR%\java -Xms64M -Xmx512M -classpath ".;%CONFIG_DIR%;%LIB_DIR%\*" objt.dbbackuprestore.DatabaseBackup dbbackuprestore.properties

:EXIT