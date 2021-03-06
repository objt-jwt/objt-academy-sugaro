--
-- CREATE PROJECT TABLESPACE
--
CREATE TABLESPACE OBJTDATA
    LOGGING 
    DATAFILE 'C:\data\oraclexe\OBJT.ora' SIZE
    25M AUTOEXTEND
    ON NEXT  10M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT  AUTO;

-- CREATE PROJECT USER
CREATE USER OBJT PROFILE DEFAULT
    IDENTIFIED BY OBJT
    DEFAULT TABLESPACE OBJTDATA
    QUOTA UNLIMITED ON OBJT
    ACCOUNT UNLOCK;

GRANT OBJT_DEVELOPER TO OBJT;

