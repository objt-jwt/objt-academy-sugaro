-- Oracle CRP views --

-- CAPACITYALLOCATIONS --

CREATE OR REPLACE VIEW DCEREPORT_CAPACITYALLOCATIONS
AS
SELECT /*+ FIRST_ROWS(30) */ capacityallocation.OID OID,
       employee.OID EMPLOYEE_OID,
       shiftcapacityreq.PLANNINGCELLOID PLANNINGCELL_OID,
       shiftcapacity.DTS DTS,
       leveledskill.SKILLOID SKILL_OID,
       leveledskill.SKILLLEVEL SKILL_LEVEL,
       shiftcapacity.SHIFTOID SHIFT_TYPE_OID,
       shiftcapacity.DTSSTART SHIFT_DTSSTART,
       shiftcapacity.DTSSTOP SHIFT_DTSSTOP,
       capacityallocation.QTYALLOCATED QTY_ALLOCATED,
       CAST(GREATEST(capacityallocation.DTSUPDATE, shiftcapacity.DTSUPDATE, shiftcapacityreq.DTSUPDATE, leveledskill.DTSUPDATE) AS DATE) DTSUPDATE,
       capacityallocation.DTSUPDATE AS DTSUPDATE_1,
       shiftcapacity.DTSUPDATE AS DTSUPDATE_2,
       shiftcapacityreq.DTSUPDATE AS DTSUPDATE_3,
       leveledskill.DTSUPDATE AS DTSUPDATE_4
FROM OBJT_CAPACITYALLOCATION capacityallocation,
     OBJT_EMPLOYEE employee,
     OBJT_SHIFTCAPACITY shiftcapacity,
     OBJT_SHIFTCAPACITYREQUIREMENT shiftcapacityreq,
     OBJT_LEVELEDSKILL leveledskill
WHERE capacityallocation.SHIFTCAPACITYREQOID = shiftcapacityreq.OID
AND   capacityallocation.SHIFTCAPACITYOID = shiftcapacity.OID
AND   shiftcapacityreq.CAPACITYELEMENTOID = leveledskill.OID
AND   shiftcapacity.CAPACITYELEMENTOID = employee.OID
/

-- CAPICITYALLOCATION ANOMALIES --

CREATE OR REPLACE VIEW DCEREPORT_CAPALLOC_ANOMALIES
AS
SELECT /*+ FIRST_ROWS(30) */ capacityanomaly.OID OID,
       capacityanomaly.OWNEROID CAPACITY_ALLOCATION_OID,
       capacityanomaly.ANOMALYREASONOID CAP_ANOMALY_REASON_OID,
       capacityanomaly.DESCRIPTION DESCRIPTION,
       capacityanomaly.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALY capacityanomaly
WHERE capacityanomaly.OWNERCLASSNAME = 'objt.crp.bo.capacitymgt.CapacityAllocation'
/

-- SHIFT CAPACITYREQUIREMENTS

CREATE OR REPLACE VIEW DCEREPORT_SHIFTCAPREQUIREMENTS
AS
SELECT /*+ FIRST_ROWS(30) */ shiftcapacityreq.OID OID,
       shiftcapacityreq.PLANNINGCELLOID PLANNINGCELL_OID,
       calendarday.DTS DTS,
       leveledskill.SKILLOID SKILL_OID,
       leveledskill.SKILLLEVEL SKILL_LEVEL,
       shift.OID SHIFT_TYPE_OID,
       calendarshift.DTSSTART SHIFT_DTSSTART,
       calendarshift.DTSSTOP SHIFT_DTSSTOP,
       shiftcapacityreq.QTYREQUIRED QTYREQUIRED,
       shiftcapacityreq.QTYALLOCATED QTYALLOCATED,
       CAST(GREATEST(shiftcapacityreq.DTSUPDATE, calendarshift.DTSUPDATE, leveledskill.DTSUPDATE) AS DATE) DTSUPDATE,
       shiftcapacityreq.DTSUPDATE AS DTSUPDATE_1,
       calendarshift.DTSUPDATE AS DTSUPDATE_2,
       leveledskill.DTSUPDATE AS DTSUPDATE_3
FROM OBJT_SHIFTCAPACITYREQUIREMENT shiftcapacityreq,
     OBJT_SHIFT shift,
     OBJT_CALENDARSHIFT calendarshift,
     OBJT_CALENDARDAY calendarday,
     OBJT_LEVELEDSKILL leveledskill
WHERE shiftcapacityreq.CALENDARSHIFTOID = calendarshift.OID
AND   calendarshift.SHIFTOID = shift.OID
AND   shiftcapacityreq.CAPACITYELEMENTOID = leveledskill.OID
AND   calendarshift.CALENDARDAYOID = calendarday.OID
/

-- SHIFT CAPACITYREQUIREMENT ANOMALIES --

CREATE OR REPLACE VIEW DCEREPORT_SHFTCAPREQ_ANOMALIES
AS
SELECT /*+ FIRST_ROWS(30) */ capacityanomaly.OID OID,
       capacityanomaly.OWNEROID SHIFT_CAPREQUIREMENT_OID,
       capacityanomaly.ANOMALYREASONOID CAP_ANOMALY_REASON_OID,
       capacityanomaly.DESCRIPTION DESCRIPTION,
       capacityanomaly.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALY capacityanomaly
WHERE capacityanomaly.OWNERCLASSNAME = 'objt.crp.bo.capacitymgt.ShiftCapacityRequirement'
/

-- SHIFT CAPACITYREQUIREMENT LINK --

CREATE OR REPLACE VIEW DCEREPORT_SHIFT_CAPREQ_LINK
AS
SELECT /*+ FIRST_ROWS(30) */ capacityreqlink.OID OID,
       capacityreq.OID CAPACITYREQUIREMENT_OID,
       shiftcapacityreq.OID SHIFT_CAPREQUIREMENT_OID,
       capacityreqlink.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYREQUIREMENTLINK capacityreqlink,
     OBJT_SHIFTCAPACITYREQUIREMENT shiftcapacityreq,
     OBJT_CAPACITYREQUIREMENT capacityreq
WHERE capacityreqlink.PARENTOID = capacityreq.OID
AND capacityreqlink.CHILDOID = shiftcapacityreq.OID
/

-- CAPACITYREQUIREMENTS --

CREATE OR REPLACE VIEW DCEREPORT_CAPREQUIREMENTS
AS
SELECT /*+ FIRST_ROWS(30) */ capacityreq.OID OID,
       capacityreq.PLANNINGCELLOID PLANNINGCELL_OID,
       leveledskill.SKILLOID SKILL_OID,
       leveledskill.SKILLLEVEL SKILL_LEVEL,
       capacityreq.DTSSTART DTSSTART,
       capacityreq.DTSSTOP DTSSTOP,
       capacityreq.QTYREQUIRED QTYREQUIRED,
       CAST(CASE WHEN (capacityreq.BOTYPE = 0) THEN NULL
                 WHEN (capacityreq.BOTYPE = 1) THEN NULL
                 WHEN (capacityreq.BOTYPE = 2) THEN capacityreq.RESOURCEOID END AS NUMBER(19)) AS PROCESSRESOURCE_OID,
       CAST(CASE WHEN (capacityreq.BOTYPE = 0) THEN capacityreq.RESOURCEOID
                 WHEN (capacityreq.BOTYPE = 1) THEN NULL
                 WHEN (capacityreq.BOTYPE = 2) THEN capacityreq.REFOID END AS NUMBER(19)) AS REFERENCE_OID,
       CASE WHEN (capacityreq.BOTYPE = 0) THEN 'MANUAL'
            WHEN (capacityreq.BOTYPE = 1) THEN 'BASE REQUIREMENT'
            WHEN (capacityreq.BOTYPE = 2) THEN 'PRODUCTION' END AS TYPE,
       CAST(GREATEST(capacityreq.DTSUPDATE, leveledskill.DTSUPDATE) AS DATE) DTSUPDATE,
       capacityreq.DTSUPDATE AS DTSUPDATE_1,
       leveledskill.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_CAPACITYREQUIREMENT capacityreq,
     OBJT_LEVELEDSKILL leveledskill
WHERE capacityreq.CAPACITYELEMENTOID = leveledskill.OID
/

-- SHIFT CAPACITIES --
CREATE OR REPLACE VIEW DCEREPORT_SHIFT_CAPACITIES
AS
SELECT /*+ FIRST_ROWS(30) */ shiftcapacity.OID OID,
       employee.OID EMPLOYEE_OID,
       shiftcapacity.DTS DTS,
       shiftcapacity.SHIFTOID SHIFT_TYPE_OID,
       shiftcapacity.DTSSTART SHIFT_DTSSTART,
       shiftcapacity.DTSSTOP SHIFT_DTSSTOP,
       shiftcapacity.QTYTARGETAVAILABLE QTYAVAILABLE,
       shiftcapacity.QTYACTUALAVAILABLE QTYREMAINING,
       shiftcapacity.QTYTARGETALLOCATED QTYALLOCATED,
       shiftcapacity.DTSUPDATE DTSUPDATE
FROM OBJT_SHIFTCAPACITY shiftcapacity,
     OBJT_EMPLOYEE employee
WHERE shiftcapacity.CAPACITYELEMENTOID = employee.OID
/

-- SHIFT CAPACITY ANOMALIES --

CREATE OR REPLACE VIEW DCEREPORT_SHIFT_CAP_ANOMALIES
AS
SELECT /*+ FIRST_ROWS(30) */ capacityanomaly.OID OID,
       capacityanomaly.OWNEROID SHIFT_CAPREQUIREMENT_OID,
       capacityanomaly.ANOMALYREASONOID CAP_ANOMALY_REASON_OID,
       capacityanomaly.DESCRIPTION DESCRIPTION,
       capacityanomaly.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALY capacityanomaly
WHERE capacityanomaly.OWNERCLASSNAME = 'objt.crp.bo.capacitymgt.ShiftCapacity'
/

-- SHIFT CAPACITY LINK --

CREATE OR REPLACE VIEW DCEREPORT_SHIFT_CAP_LINK
AS
SELECT /*+ FIRST_ROWS(30) */ capacitylink.OID OID,
       shiftcapacity.OID SHIFT_CAPACITY_OID,
       capacity.OID CAPACITY_OID,
       capacitylink.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYLINK capacitylink,
     OBJT_SHIFTCAPACITY shiftcapacity,
     OBJT_CAPACITY capacity
WHERE capacitylink.PARENTOID = capacity.OID
AND capacitylink.CHILDOID = shiftcapacity.OID
/

-- CAPACITIES --

CREATE OR REPLACE VIEW DCEREPORT_CAPACITIES
AS
SELECT /*+ FIRST_ROWS(30) */ capacity.OID OID,
       employee.OID EMPLOYEE_OID,
       capacity.DTSSTART DTSSTART,
       capacity.DTSSTOP DTSSTOP,
       capacity.REFOID REFERENCE_OID,
       capacity.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITY capacity,
     OBJT_EMPLOYEE employee
WHERE capacity.CAPACITYELEMENTOID = employee.OID
/


-- CAPACITY ANOMALY REASONS --

CREATE OR REPLACE VIEW DCEREPORT_CAP_ANOMALY_REASONS
AS
SELECT /*+ FIRST_ROWS(30) */ anomalyreason.OID OID,
       anomalyreason.name NAME,
       anomalyreason.description DESCRIPTION,
       CASE WHEN (anomalyreason.BOTYPE = 0) THEN 'ERROR'
            WHEN (anomalyreason.BOTYPE = 1) THEN 'WARNING'
            WHEN (anomalyreason.BOTYPE = 2) THEN 'INFO' END AS TYPE,
       anomalyreason.DTSVALIDFROM DTSVALIDFROM,
       anomalyreason.DTSVALIDUNTIL DTSVALIDUNTIL,
       anomalyreason.DTSUPDATE DTSUPDATE
FROM OBJT_CAPACITYANOMALYREASON anomalyreason
/

-- PLANNING CELLS --

CREATE OR REPLACE VIEW DCEREPORT_PLANNINGCELLS
AS
SELECT /*+ FIRST_ROWS(30) */ planningcell.OID OID,
       planningcell.NAME NAME,
       planningcell.DESCRIPTION DESCRIPTION,
       CAST((SELECT costcenter.OID FROM OBJT_COSTCENTER costcenter,
                                   OBJT_RESOURCELINK link
        WHERE link.CHILDOID = planningcell.OID
        AND link.PARENTOID = costcenter.OID) AS NUMBER(19)) AS COSTCENTER_OID,
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
FROM OBJT_PLANNINGCELL planningcell
/