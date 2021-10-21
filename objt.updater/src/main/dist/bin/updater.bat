SET JAVA_DIR=".\..\..\java\windows-x64\bin"
SET LIB_DIR=.\..\lib

%JAVA_DIR%\java -Xms64M -Xmx512M -classpath ".;%LIB_DIR%\*" objt.updater.core.Updater updater.properties updater.xml