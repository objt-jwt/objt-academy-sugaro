IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_CAPACITYALLOCATIONS') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_CAPACITYALLOCATIONS
GO

CREATE TABLE DCEREPORT_CAPACITYALLOCATIONS
(
  OID                  BIGINT NOT NULL,
  EMPLOYEE_OID         BIGINT,
  PLANNINGCELL_OID     BIGINT,
  DTS                  DATETIME2,
  SKILL_OID            BIGINT,
  SKILL_LEVEL          INT,
  SHIFT_TYPE_OID       BIGINT,
  SHIFT_DTSSTART       DATETIME2,
  SHIFT_DTSSTOP        DATETIME2,
  QTY_ALLOCATED        FLOAT,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_CAPACITYALLOCATIONS
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_CAPACITYALLOCATIONS_EMPLOYEE_OID ON DCEREPORT_CAPACITYALLOCATIONS(EMPLOYEE_OID)
GO

CREATE INDEX IDCEREPORT_CAPACITYALLOCATIONS_PLANNINGCELL_OID ON DCEREPORT_CAPACITYALLOCATIONS(PLANNINGCELL_OID)
GO

CREATE INDEX IDCEREPORT_CAPACITYALLOCATIONS_SKILL_OID ON DCEREPORT_CAPACITYALLOCATIONS(SKILL_OID)
GO

CREATE INDEX IDCEREPORT_CAPACITYALLOCATIONS_SHIFT_TYPE_OID ON DCEREPORT_CAPACITYALLOCATIONS(SHIFT_TYPE_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_CAPALLOC_ANOMALIES') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_CAPALLOC_ANOMALIES
GO

CREATE TABLE DCEREPORT_CAPALLOC_ANOMALIES
(
  OID                  BIGINT NOT NULL,
  CAPACITY_ALLOCATION_OID BIGINT,
  CAP_ANOMALY_REASON_OID BIGINT,
  DESCRIPTION          VARCHAR(255),
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_CAPALLOC_ANOMALIES
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_CAPALLOC_ANOMALIES_CAPACITY_ALLOCATION_OID ON DCEREPORT_CAPALLOC_ANOMALIES(CAPACITY_ALLOCATION_OID)
GO

CREATE INDEX IDCEREPORT_CAPALLOC_ANOMALIES_CAP_ANOMALY_REASON_OID ON DCEREPORT_CAPALLOC_ANOMALIES(CAP_ANOMALY_REASON_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_SHIFTCAPREQUIREMENTS') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_SHIFTCAPREQUIREMENTS
GO

CREATE TABLE DCEREPORT_SHIFTCAPREQUIREMENTS
(
  OID                  BIGINT NOT NULL,
  PLANNINGCELL_OID     BIGINT,
  DTS                  DATETIME2,
  SKILL_OID            BIGINT,
  SKILL_LEVEL          INT,
  SHIFT_TYPE_OID       BIGINT,
  SHIFT_DTSSTART       DATETIME2,
  SHIFT_DTSSTOP        DATETIME2,
  QTYREQUIRED          FLOAT,
  QTYALLOCATED         FLOAT,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_SHIFTCAPREQUIREMENTS
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_SHIFTCAPREQUIREMENTS_PLANNINGCELL_OID ON DCEREPORT_SHIFTCAPREQUIREMENTS(PLANNINGCELL_OID)
GO

CREATE INDEX IDCEREPORT_SHIFTCAPREQUIREMENTS_SKILL_OID ON DCEREPORT_SHIFTCAPREQUIREMENTS(SKILL_OID)
GO

CREATE INDEX IDCEREPORT_SHIFTCAPREQUIREMENTS_SHIFT_TYPE_OID ON DCEREPORT_SHIFTCAPREQUIREMENTS(SHIFT_TYPE_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_SHFTCAPREQ_ANOMALIES') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_SHFTCAPREQ_ANOMALIES
GO

CREATE TABLE DCEREPORT_SHFTCAPREQ_ANOMALIES
(
  OID                  BIGINT NOT NULL,
  SHIFT_CAPREQUIREMENT_OID BIGINT,
  CAP_ANOMALY_REASON_OID BIGINT,
  DESCRIPTION          VARCHAR(255),
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_SHFTCAPREQ_ANOMALIES
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_SHFTCAPREQ_ANOMALIES_SHIFT_CAPREQUIREMENT_OID ON DCEREPORT_SHFTCAPREQ_ANOMALIES(SHIFT_CAPREQUIREMENT_OID)
GO

CREATE INDEX IDCEREPORT_SHFTCAPREQ_ANOMALIES_CAP_ANOMALY_REASON_OID ON DCEREPORT_SHFTCAPREQ_ANOMALIES(CAP_ANOMALY_REASON_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_SHIFT_CAPREQ_LINK') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_SHIFT_CAPREQ_LINK
GO

CREATE TABLE DCEREPORT_SHIFT_CAPREQ_LINK
(
  OID                  BIGINT NOT NULL,
  CAPACITYREQUIREMENT_OID BIGINT,
  SHIFT_CAPREQUIREMENT_OID BIGINT,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_SHIFT_CAPREQ_LINK
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAPREQ_LINK_CAPACITYREQUIREMENT_OID ON DCEREPORT_SHIFT_CAPREQ_LINK(CAPACITYREQUIREMENT_OID)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAPREQ_LINK_SHIFT_CAPREQUIREMENT_OID ON DCEREPORT_SHIFT_CAPREQ_LINK(SHIFT_CAPREQUIREMENT_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_CAPREQUIREMENTS') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_CAPREQUIREMENTS
GO

CREATE TABLE DCEREPORT_CAPREQUIREMENTS
(
  OID                  BIGINT NOT NULL,
  PLANNINGCELL_OID     BIGINT,
  SKILL_OID            BIGINT,
  SKILL_LEVEL          INT,
  DTSSTART             DATETIME2,
  DTSSTOP              DATETIME2,
  QTYREQUIRED          FLOAT,
  PROCESSRESOURCE_OID  BIGINT,
  REFERENCE_OID        BIGINT,
  TYPE                 VARCHAR(16),
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_CAPREQUIREMENTS
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_CAPREQUIREMENTS_PLANNINGCELL_OID ON DCEREPORT_CAPREQUIREMENTS(PLANNINGCELL_OID)
GO

CREATE INDEX IDCEREPORT_CAPREQUIREMENTS_SKILL_OID ON DCEREPORT_CAPREQUIREMENTS(SKILL_OID)
GO

CREATE INDEX IDCEREPORT_CAPREQUIREMENTS_PROCESSRESOURCE_OID ON DCEREPORT_CAPREQUIREMENTS(PROCESSRESOURCE_OID)
GO

CREATE INDEX IDCEREPORT_CAPREQUIREMENTS_REFERENCE_OID ON DCEREPORT_CAPREQUIREMENTS(REFERENCE_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_SHIFT_CAPACITIES') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_SHIFT_CAPACITIES
GO

CREATE TABLE DCEREPORT_SHIFT_CAPACITIES
(
  OID                  BIGINT NOT NULL,
  EMPLOYEE_OID         BIGINT,
  DTS                  DATETIME2,
  SHIFT_TYPE_OID       BIGINT,
  SHIFT_DTSSTART       DATETIME2,
  SHIFT_DTSSTOP        DATETIME2,
  QTYAVAILABLE         FLOAT,
  QTYREMAINING         FLOAT,
  QTYALLOCATED         FLOAT,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_SHIFT_CAPACITIES
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAPACITIES_EMPLOYEE_OID ON DCEREPORT_SHIFT_CAPACITIES(EMPLOYEE_OID)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAPACITIES_SHIFT_TYPE_OID ON DCEREPORT_SHIFT_CAPACITIES(SHIFT_TYPE_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_SHIFT_CAP_ANOMALIES') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_SHIFT_CAP_ANOMALIES
GO

CREATE TABLE DCEREPORT_SHIFT_CAP_ANOMALIES
(
  OID                  BIGINT NOT NULL,
  SHIFT_CAPREQUIREMENT_OID BIGINT,
  CAP_ANOMALY_REASON_OID BIGINT,
  DESCRIPTION          VARCHAR(255),
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_SHIFT_CAP_ANOMALIES
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAP_ANOMALIES_SHIFT_CAPREQUIREMENT_OID ON DCEREPORT_SHIFT_CAP_ANOMALIES(SHIFT_CAPREQUIREMENT_OID)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAP_ANOMALIES_CAP_ANOMALY_REASON_OID ON DCEREPORT_SHIFT_CAP_ANOMALIES(CAP_ANOMALY_REASON_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_SHIFT_CAP_LINK') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_SHIFT_CAP_LINK
GO

CREATE TABLE DCEREPORT_SHIFT_CAP_LINK
(
  OID                  BIGINT NOT NULL,
  SHIFT_CAPACITY_OID   BIGINT,
  CAPACITY_OID         BIGINT,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_SHIFT_CAP_LINK
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAP_LINK_SHIFT_CAPACITY_OID ON DCEREPORT_SHIFT_CAP_LINK(SHIFT_CAPACITY_OID)
GO

CREATE INDEX IDCEREPORT_SHIFT_CAP_LINK_CAPACITY_OID ON DCEREPORT_SHIFT_CAP_LINK(CAPACITY_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_CAPACITIES') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_CAPACITIES
GO

CREATE TABLE DCEREPORT_CAPACITIES
(
  OID                  BIGINT NOT NULL,
  EMPLOYEE_OID         BIGINT,
  DTSSTART             DATETIME2,
  DTSSTOP              DATETIME2,
  REFERENCE_OID        BIGINT,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_CAPACITIES
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_CAPACITIES_EMPLOYEE_OID ON DCEREPORT_CAPACITIES(EMPLOYEE_OID)
GO

CREATE INDEX IDCEREPORT_CAPACITIES_REFERENCE_OID ON DCEREPORT_CAPACITIES(REFERENCE_OID)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_CAP_ANOMALY_REASONS') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_CAP_ANOMALY_REASONS
GO

CREATE TABLE DCEREPORT_CAP_ANOMALY_REASONS
(
  OID                  BIGINT NOT NULL,
  NAME                 VARCHAR(64),
  DESCRIPTION          VARCHAR(255),
  TYPE                 VARCHAR(7),
  DTSVALIDFROM         DATETIME2,
  DTSVALIDUNTIL        DATETIME2,
  DTSUPDATE            DATETIME2,
  CONSTRAINT PK_DCEREPORT_CAP_ANOMALY_REASONS
  PRIMARY KEY (OID)
)
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('DCEREPORT_PLANNINGCELLS') AND OBJECTPROPERTY(ID, 'IsUserTable') = 1)
DROP TABLE DCEREPORT_PLANNINGCELLS
GO

CREATE TABLE DCEREPORT_PLANNINGCELLS
(
  OID                  BIGINT NOT NULL,
  NAME                 VARCHAR(64),
  DESCRIPTION          VARCHAR(255),
  COSTCENTER_OID       BIGINT,
  DTSVALIDFROM         DATETIME2,
  DTSVALIDUNTIL        DATETIME2,
  DTSUPDATE            DATETIME2,
  USRDTS1              DATETIME2,
  USRDTS2              DATETIME2,
  USRDTS3              DATETIME2,
  USRDTS4              DATETIME2,
  USRDTS5              DATETIME2,
  USRFLG1              CHAR(1),
  USRFLG2              CHAR(1),
  USRFLG3              CHAR(1),
  USRFLG4              CHAR(1),
  USRFLG5              CHAR(1),
  USRNUM1              FLOAT,
  USRNUM2              FLOAT,
  USRNUM3              FLOAT,
  USRNUM4              FLOAT,
  USRNUM5              FLOAT,
  USRTXT1              VARCHAR(255),
  USRTXT2              VARCHAR(255),
  USRTXT3              VARCHAR(255),
  USRTXT4              VARCHAR(255),
  USRTXT5              VARCHAR(255),
  CONSTRAINT PK_DCEREPORT_PLANNINGCELLS
  PRIMARY KEY (OID)
)
GO

CREATE INDEX IDCEREPORT_PLANNINGCELLS_COSTCENTER_OID ON DCEREPORT_PLANNINGCELLS(COSTCENTER_OID)
GO
