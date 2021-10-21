DROP USER OBJT CASCADE;

CREATE USER OBJT IDENTIFIED BY OBJT
  DEFAULT TABLESPACE OBJTDATA
  TEMPORARY TABLESPACE TEMP;

GRANT UNLIMITED TABLESPACE TO OBJT;

GRANT CREATE SESSION TO OBJT;

GRANT CREATE ANY TABLE TO OBJT;
GRANT DROP ANY TABLE TO OBJT;
GRANT ALTER ANY TABLE TO OBJT;
GRANT SELECT ANY TABLE TO OBJT;
GRANT INSERT ANY TABLE TO OBJT;
GRANT DELETE ANY TABLE TO OBJT;
GRANT UPDATE ANY TABLE TO OBJT;
GRANT COMMENT ANY TABLE TO OBJT;
GRANT LOCK ANY TABLE TO OBJT;
GRANT BACKUP ANY TABLE TO OBJT;

GRANT CREATE ANY VIEW TO OBJT;
GRANT DROP ANY VIEW TO OBJT;

GRANT CREATE ANY SEQUENCE TO OBJT;
GRANT DROP ANY SEQUENCE TO OBJT;
GRANT ALTER ANY SEQUENCE TO OBJT;

GRANT CREATE PUBLIC SYNONYM TO OBJT;
GRANT DROP PUBLIC SYNONYM TO OBJT;

GRANT CREATE ANY PROCEDURE TO OBJT;
GRANT DROP ANY PROCEDURE TO OBJT;
GRANT EXECUTE ANY PROCEDURE TO OBJT;

exit;
