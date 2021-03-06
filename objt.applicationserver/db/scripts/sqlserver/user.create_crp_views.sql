-- SQL Server CRP views --

-- MAXDATE FUNCTION (GREATEST FUNCTION DOES NOT EXIST FOR SQL SERVER)
-- for n columns this function is used in cascade

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'dbo.MaxDate') AND type = (N'FN'))
DROP FUNCTION dbo.MaxDate
GO

CREATE FUNCTION dbo.MaxDate(@value1 DATETIME2 = '', @value2 DATETIME2 = '') -- DATETIME2 = '' > use '1900-01-01 00:00:00.000' as default value
RETURNS DATETIME2 AS
BEGIN
  DECLARE @Result DATETIME2
  SET @value1 = ISNULL(@value1,'')
  SET @value2 = ISNULL(@value2,'')
  IF (@value1 >= @value2) SET @Result = @value1
  ELSE SET @Result = @value2
  RETURN @Result
END
GO

-- CAPACITYALLOCATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CAPACITYALLOCATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CAPACITYALLOCATIONS
GO

CREATE VIEW DCEREPORT_CAPACITYALLOCATIONS
AS
SELECT capacityallocation.OID OID,
       employee.OID EMPLOYEE_OID,
       shiftcapacityreq.PLANNINGCELLOID PLANNINGCELL_OID,
       shiftcapacity.DTS DTS,
       leveledskill.SKILLOID SKILL_OID,
       leveledskill.SKILLLEVEL SKILL_LEVEL,
       shiftcapacity.SHIFTOID SHIFT_TYPE_OID,
       shiftcapacity.DTSSTART SHIFT_DTSSTART,
       shiftcapacity.DTSSTOP SHIFT_DTSSTOP,
       capacityallocation.QTYALLOCATED QTY_ALLOCATED,
       dbo.MaxDate(dbo.MaxDate(dbo.MaxDate(capacityallocation.DTSUPDATE, shiftcapacity.DTSUPDATE), shiftcapacityreq.DTSUPDATE), leveledskill.DTSUPDATE) AS DTSUPDATE,
       capacityallocation.DTSUPDATE AS DTSUPDATE_1,
       shiftcapacity.DTSUPDATE AS DTSUPDATE_2,
       shiftcapacityreq.DTSUPDATE AS DTSUPDATE_3,
       leveledskill.DTSUPDATE AS DTSUPDATE_4
FROM OBJT_CAPACITYALLOCATION capacityallocation WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK),
     OBJT_SHIFTCAPACITY shiftcapacity WITH (NOLOCK),
     OBJT_SHIFTCAPACITYREQUIREMENT shiftcapacityreq WITH (NOLOCK),
     OBJT_LEVELEDSKILL leveledskill WITH (NOLOCK)
WHERE capacityallocation.SHIFTCAPACITYREQOID = shiftcapacityreq.OID
AND   capacityallocation.SHIFTCAPACITYOID = shiftcapacity.OID
AND   shiftcapacityreq.CAPACITYELEMENTOID = leveledskill.OID
AND   shiftcapacity.CAPACITYELEMENTOID = employee.OID
GO

-- CAPICITYALLOCATION ANOMALIES --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CAPALLOC_ANOMALIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CAPALLOC_ANOMALIES
GO

CREATE VIEW DCEREPORT_CAPALLOC_ANOMALIES
AS
SELECT capacityanomaly.OID OID,
       capacityanomaly.OWNEROID CAPACITY_ALLOCATION_OID,
       capacityanomaly.ANOMALYREASONOID CAP_ANOMALY_REASON_OID,
       capacityanomaly.DESCRIPTION DESCRIPTION,
       capacityanomaly.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALY capacityanomaly WITH (NOLOCK)
WHERE capacityanomaly.OWNERCLASSNAME = 'objt.crp.bo.capacitymgt.CapacityAllocation'
GO

-- SHIFT CAPACITYREQUIREMENTS

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHIFTCAPREQUIREMENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHIFTCAPREQUIREMENTS
GO

CREATE VIEW DCEREPORT_SHIFTCAPREQUIREMENTS
AS
SELECT shiftcapacityreq.OID OID,
       shiftcapacityreq.PLANNINGCELLOID PLANNINGCELL_OID,
       calendarday.DTS DTS,
       leveledskill.SKILLOID SKILL_OID,
       leveledskill.SKILLLEVEL SKILL_LEVEL,
       shift.OID SHIFT_TYPE_OID,
       calendarshift.DTSSTART SHIFT_DTSSTART,
       calendarshift.DTSSTOP SHIFT_DTSSTOP,
       shiftcapacityreq.QTYREQUIRED QTYREQUIRED,
       shiftcapacityreq.QTYALLOCATED QTYALLOCATED,
       dbo.MaxDate(dbo.MaxDate(shiftcapacityreq.DTSUPDATE, calendarshift.DTSUPDATE), leveledskill.DTSUPDATE) AS DTSUPDATE,
       shiftcapacityreq.DTSUPDATE AS DTSUPDATE_1,
       calendarshift.DTSUPDATE AS DTSUPDATE_2,
       leveledskill.DTSUPDATE AS DTSUPDATE_3
FROM OBJT_SHIFTCAPACITYREQUIREMENT shiftcapacityreq WITH (NOLOCK),
     OBJT_SHIFT shift WITH (NOLOCK),
     OBJT_CALENDARSHIFT calendarshift WITH (NOLOCK),
     OBJT_CALENDARDAY calendarday WITH (NOLOCK),
     OBJT_LEVELEDSKILL leveledskill WITH (NOLOCK)
WHERE shiftcapacityreq.CALENDARSHIFTOID = calendarshift.OID
AND   calendarshift.SHIFTOID = shift.OID
AND   shiftcapacityreq.CAPACITYELEMENTOID = leveledskill.OID
AND   calendarshift.CALENDARDAYOID = calendarday.OID
GO

-- SHIFT CAPACITYREQUIREMENT ANOMALIES --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHFTCAPREQ_ANOMALIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHFTCAPREQ_ANOMALIES
GO

CREATE VIEW DCEREPORT_SHFTCAPREQ_ANOMALIES
AS
SELECT capacityanomaly.OID OID,
       capacityanomaly.OWNEROID SHIFT_CAPREQUIREMENT_OID,
       capacityanomaly.ANOMALYREASONOID CAP_ANOMALY_REASON_OID,
       capacityanomaly.DESCRIPTION DESCRIPTION,
       capacityanomaly.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALY capacityanomaly WITH (NOLOCK)
WHERE capacityanomaly.OWNERCLASSNAME = 'objt.crp.bo.capacitymgt.ShiftCapacityRequirement'
GO

-- SHIFT CAPACITYREQUIREMENT LINK --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHIFT_CAPREQ_LINK') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHIFT_CAPREQ_LINK
GO

CREATE VIEW DCEREPORT_SHIFT_CAPREQ_LINK
AS
SELECT capacityreqlink.OID OID,
       capacityreq.OID CAPACITYREQUIREMENT_OID,
       shiftcapacityreq.OID SHIFT_CAPREQUIREMENT_OID,
       capacityreqlink.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYREQUIREMENTLINK capacityreqlink WITH (NOLOCK),
     OBJT_SHIFTCAPACITYREQUIREMENT shiftcapacityreq WITH (NOLOCK),
     OBJT_CAPACITYREQUIREMENT capacityreq WITH (NOLOCK)
WHERE capacityreqlink.PARENTOID = capacityreq.OID
AND capacityreqlink.CHILDOID = shiftcapacityreq.OID
GO

-- CAPACITYREQUIREMENTS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CAPREQUIREMENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CAPREQUIREMENTS
GO

CREATE VIEW DCEREPORT_CAPREQUIREMENTS
AS
SELECT capacityreq.OID OID,
       capacityreq.PLANNINGCELLOID PLANNINGCELL_OID,
       leveledskill.SKILLOID SKILL_OID,
       leveledskill.SKILLLEVEL SKILL_LEVEL,
       capacityreq.DTSSTART DTSSTART,
       capacityreq.DTSSTOP DTSSTOP,
       capacityreq.QTYREQUIRED QTYREQUIRED,
       CASE WHEN (capacityreq.BOTYPE = 0) THEN NULL
            WHEN (capacityreq.BOTYPE = 1) THEN NULL
            WHEN (capacityreq.BOTYPE = 2) THEN capacityreq.RESOURCEOID END AS PROCESSRESOURCE_OID,
       CASE WHEN (capacityreq.BOTYPE = 0) THEN capacityreq.RESOURCEOID
            WHEN (capacityreq.BOTYPE = 1) THEN NULL
            WHEN (capacityreq.BOTYPE = 2) THEN capacityreq.REFOID END AS REFERENCE_OID,
       CASE WHEN (capacityreq.BOTYPE = 0) THEN 'MANUAL'
            WHEN (capacityreq.BOTYPE = 1) THEN 'BASE REQUIREMENT'
            WHEN (capacityreq.BOTYPE = 2) THEN 'PRODUCTION' END AS TYPE,
       dbo.MaxDate(capacityreq.DTSUPDATE, leveledskill.DTSUPDATE) AS DTSUPDATE,
       capacityreq.DTSUPDATE AS DTSUPDATE_1,
       leveledskill.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_CAPACITYREQUIREMENT capacityreq WITH (NOLOCK),
     OBJT_LEVELEDSKILL leveledskill WITH (NOLOCK)
WHERE capacityreq.CAPACITYELEMENTOID = leveledskill.OID
GO

-- SHIFT CAPACITIES --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHIFT_CAPACITIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHIFT_CAPACITIES
GO

CREATE VIEW DCEREPORT_SHIFT_CAPACITIES
AS
SELECT shiftcapacity.OID OID,
       employee.OID EMPLOYEE_OID,
       shiftcapacity.DTS DTS,
       shiftcapacity.SHIFTOID SHIFT_TYPE_OID,
       shiftcapacity.DTSSTART SHIFT_DTSSTART,
       shiftcapacity.DTSSTOP SHIFT_DTSSTOP,
       shiftcapacity.QTYTARGETAVAILABLE QTYAVAILABLE,
       shiftcapacity.QTYACTUALAVAILABLE QTYREMAINING,
       shiftcapacity.QTYTARGETALLOCATED QTYALLOCATED,
       shiftcapacity.DTSUPDATE DTSUPDATE
FROM OBJT_SHIFTCAPACITY shiftcapacity WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK)
WHERE shiftcapacity.CAPACITYELEMENTOID = employee.OID
GO

-- SHIFT CAPACITY ANOMALIES --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHIFT_CAP_ANOMALIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHIFT_CAP_ANOMALIES
GO

CREATE VIEW DCEREPORT_SHIFT_CAP_ANOMALIES
AS
SELECT capacityanomaly.OID OID,
       capacityanomaly.OWNEROID SHIFT_CAPREQUIREMENT_OID,
       capacityanomaly.ANOMALYREASONOID CAP_ANOMALY_REASON_OID,
       capacityanomaly.DESCRIPTION DESCRIPTION,
       capacityanomaly.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALY capacityanomaly WITH (NOLOCK)
WHERE capacityanomaly.OWNERCLASSNAME = 'objt.crp.bo.capacitymgt.ShiftCapacity'
GO

-- SHIFT CAPACITY LINK --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHIFT_CAP_LINK') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHIFT_CAP_LINK
GO

CREATE VIEW DCEREPORT_SHIFT_CAP_LINK
AS
SELECT capacitylink.OID OID,
       shiftcapacity.OID SHIFT_CAPACITY_OID,
       capacity.OID CAPACITY_OID,
       capacitylink.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYLINK capacitylink WITH (NOLOCK),
     OBJT_SHIFTCAPACITY shiftcapacity WITH (NOLOCK),
     OBJT_CAPACITY capacity WITH (NOLOCK)
WHERE capacitylink.PARENTOID = capacity.OID
AND capacitylink.CHILDOID = shiftcapacity.OID
GO

-- CAPACITIES --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CAPACITIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CAPACITIES
GO

CREATE VIEW DCEREPORT_CAPACITIES
AS
SELECT capacity.OID OID,
       employee.OID EMPLOYEE_OID,
       capacity.DTSSTART DTSSTART,
       capacity.DTSSTOP DTSSTOP,
       capacity.REFOID REFERENCE_OID,
       capacity.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITY capacity WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK)
WHERE capacity.CAPACITYELEMENTOID = employee.OID
GO


-- CAPACITY ANOMALY REASONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CAP_ANOMALY_REASONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CAP_ANOMALY_REASONS
GO

CREATE VIEW DCEREPORT_CAP_ANOMALY_REASONS
AS
SELECT anomalyreason.OID OID,
       anomalyreason.name NAME,
       anomalyreason.description DESCRIPTION,
       CASE WHEN (anomalyreason.BOTYPE = 0) THEN 'ERROR'
            WHEN (anomalyreason.BOTYPE = 1) THEN 'WARNING'
            WHEN (anomalyreason.BOTYPE = 2) THEN 'INFO' END AS TYPE,
       anomalyreason.DTSVALIDFROM DTSVALIDFROM,
       anomalyreason.DTSVALIDUNTIL DTSVALIDUNTIL,
       anomalyreason.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALYREASON anomalyreason WITH (NOLOCK)
GO

-- PLANNING CELLS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_PLANNINGCELLS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_PLANNINGCELLS
GO

CREATE VIEW DCEREPORT_PLANNINGCELLS
AS
SELECT planningcell.OID OID,
       planningcell.NAME NAME,
       planningcell.DESCRIPTION DESCRIPTION,
       (SELECT costcenter.OID FROM OBJT_COSTCENTER costcenter,
                                   OBJT_RESOURCELINK link
        WHERE link.CHILDOID = planningcell.OID
        AND link.PARENTOID = costcenter.OID) AS COSTCENTER_OID,
       planningcell.DTSVALIDFROM DTSVALIDFROM,
       planningcell.DTSVALIDUNTIL DTSVALIDUNTIL,
       planningcell.DTSUPDATE DTSUPDATE,
       planningcell.USRDTS1 USRDTS1,
       planningcell.USRDTS2 USRDTS2,
       planningcell.USRDTS3 USRDTS3,
       planningcell.USRDTS4 USRDTS4,
       planningcell.USRDTS5 USRDTS5,
       planningcell.USRFLG1 USRFLG1,
       planningcell.USRFLG2 USRFLG2,
       planningcell.USRFLG3 USRFLG3,
       planningcell.USRFLG4 USRFLG4,
       planningcell.USRFLG5 USRFLG5,
       planningcell.USRNUM1 USRNUM1,
       planningcell.USRNUM2 USRNUM2,
       planningcell.USRNUM3 USRNUM3,
       planningcell.USRNUM4 USRNUM4,
       planningcell.USRNUM5 USRNUM5,
       planningcell.USRTXT1 USRTXT1,
       planningcell.USRTXT2 USRTXT2,
       planningcell.USRTXT3 USRTXT3,
       planningcell.USRTXT4 USRTXT4,
       planningcell.USRTXT5 USRTXT5
FROM OBJT_PLANNINGCELL planningcell WITH (NOLOCK)
GO
