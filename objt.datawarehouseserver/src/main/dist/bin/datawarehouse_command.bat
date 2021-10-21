SET JAVA_DIR=".\..\java\windows-x64\bin"
SET LIB_DIR=.\..\lib

%JAVA_DIR%\java -classpath ".;%LIB_DIR%\dce.jar" dce.remote.util.cmd.RemoteCmd TCP localhost:59300 objt.datawarehouse %1