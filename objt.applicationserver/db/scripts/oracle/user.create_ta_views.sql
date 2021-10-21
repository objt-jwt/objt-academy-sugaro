-- Oracle TA views --

-- COSTCENTERS --

CREATE OR REPLACE VIEW DCEREPORT_COSTCENTERS
AS
SELECT /*+ FIRST_ROWS(30) */ costcenter.OID OID,
       costcenter.NAME NAME,
       costcenter.DESCRIPTION DESCRIPTION,
       costcenter.ID ID,
       costcenter.DTSVALIDFROM DTSVALIDFROM,
       costcenter.DTSVALIDUNTIL DTSVALIDUNTIL,
       costcenter.DTSUPDATE DTSUPDATE
FROM OBJT_COSTCENTER costcenter
/

-- PLANNED ATTENDANCES --

CREATE OR REPLACE VIEW DCEREPORT_PLANNED_ATTENDANCES       
AS
SELECT /*+ FIRST_ROWS(30) */ attendanceoperation.OID OID,
       employee.OID EMPLOYEE_OID,
       attendanceoperation.NAME NAME,
       attendanceoperation.DESCRIPTION DESCRIPTION,
	     attendanceoperation.CATEGORY CATEGORY,
       attendanceoperation.DTSPLANNEDSTART DTSSTART,
       attendanceoperation.DTSPLANNEDSTOP DTSSTOP,
       attendanceoperation.ATTENDANCECODEOID DAY_CODE_OID,
       attendanceoperation.DTSVALIDFROM DTSVALIDFROM,
       attendanceoperation.DTSVALIDUNTIL DTSVALIDUNTIL,
       attendanceoperation.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEOPERATION attendanceoperation,
     OBJT_EMPLOYEE employee
WHERE attendanceoperation.BOTYPE = 0
AND attendanceoperation.EMPLOYEEOID = employee.OID
/

-- DAY CODES --

CREATE OR REPLACE VIEW DCEREPORT_DAY_CODES
AS
SELECT /*+ FIRST_ROWS(30) */ attendancecode.OID OID,
       attendancecode.NAME NAME,
       attendancecode.DESCRIPTION DESCRIPTION,
       attendancecode.ID ID,
       CASE WHEN (attendancecode.CODEUNIT = 0) THEN 'H:M'
            WHEN (attendancecode.CODEUNIT = 1) THEN 'd'
            WHEN (attendancecode.CODEUNIT = 2) THEN '#' END AS UNIT,
       CASE WHEN (attendancecode.BOTYPE = 0) THEN 'ATTENDANCE'
            WHEN (attendancecode.BOTYPE = 1) THEN 'ABSENCE'
            WHEN (attendancecode.BOTYPE = 2) THEN 'SPECIAL' END AS TYPE,
       attendancecodelink.PARENTOID BALANCE_CODE_OID,
       attendancecodelink.TRANSFERFACTOR TRANSFER_FACTOR,
       CAST(CASE WHEN (attendancecodelink.TRANSFERTYPE = 0) THEN 'INCREMENT'
            WHEN (attendancecodelink.TRANSFERTYPE = 1) THEN 'DECREMENT' END AS VARCHAR(9)) AS TRANSFER_TYPE,
       attendancecode.DTSVALIDFROM DTSVALIDFROM,
       attendancecode.DTSVALIDUNTIL DTSVALIDUNTIL,
       attendancecode.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCECODE attendancecode
  LEFT OUTER JOIN OBJT_ATTENDANCECODELINK attendancecodelink ON attendancecode.OID = attendancecodelink.CHILDOID AND attendancecodelink.BOTYPE = 1 -- transfer type --
WHERE attendancecode.BOTYPE != 3 -- no Counter code --
/
-- BALANCE CODES --

CREATE OR REPLACE VIEW DCEREPORT_BALANCE_CODES     
AS
SELECT /*+ FIRST_ROWS(30) */ balancecode.OID OID,
       balancecode.NAME NAME,
       balancecode.DESCRIPTION DESCRIPTION,
       balancecode.ID ID,
       CASE WHEN (balancecode.CODEUNIT = 0) THEN 'H:M'
            WHEN (balancecode.CODEUNIT = 1) THEN 'd'
            WHEN (balancecode.CODEUNIT = 2) THEN '#' END AS UNIT,
       balancecode.DTSVALIDFROM DTSVALIDFROM,
       balancecode.DTSVALIDUNTIL DTSVALIDUNTIL,
       balancecode.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCECODE balancecode
WHERE balancecode.BOTYPE = 3 -- Counter code --
/
-- ACCESS OPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_ACCESS_OPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */ accessoperation.OID OID,
       accessoperation.EMPLOYEEOID EMPLOYEE_OID,
       accessoperation.ACCESSBADGEOID ACCESSBADGE_OID,
       accessoperation.DTSSTART DTSSTART,
       accessoperation.DTSSTOP DTSSTOP,
       accessoperation.DTSVALIDFROM DTSVALIDFROM,
       accessoperation.DTSVALIDUNTIL DTSVALIDUNTIL,
       accessoperation.STATUS STATUS,
       accessoperation.DEVICEOID ACCESSREADERDEVICE_OID,
       accessoperation.ACCESSGATEOID ACCESSGATE_OID,
       accessoperation.ACCESSAREAOID ACCESSAREA_OID,
       accessoperation.DTSUPDATE DTSUPDATE
FROM OBJT_ACCESSOPERATION accessoperation
/

-- ACCESS BADGE --

CREATE OR REPLACE VIEW DCEREPORT_ACCESS_BADGES
AS
SELECT /*+ FIRST_ROWS(30) */ accessbadge.OID OID,
       accessbadge.NAME ID,
       accessbadge.DESCRIPTION DESCRIPTION,
       CASE WHEN (accessbadge.STATUS = 0) THEN 'VALID'
            WHEN (accessbadge.STATUS = 1) THEN 'INVALID'
            WHEN (accessbadge.STATUS = 2) THEN 'LOST' END AS STATUS,
       accessbadge.DTSSTART DTSSTART,
       accessbadge.DTSSTOP DTSSTOP,
       accessbadge.DTSVALIDFROM DTSVALIDFROM,
       accessbadge.DTSVALIDUNTIL DTSVALIDUNITL,
       accessbadge.DTSUPDATE DTSUPDATE
FROM OBJT_ACCESSBADGE accessbadge
/

-- ACCESS READER DEVICES --

CREATE OR REPLACE VIEW DCEREPORT_ACCESS_READERDEVICES
AS
SELECT /*+ FIRST_ROWS(30) */ accessreaderdevice.OID OID,
       accessreaderdevice.NAME NAME,
       accessreaderdevice.DESCRIPTION DESCRIPTION,
       CASE WHEN (accessreaderdevice.BOTYPE = 0) THEN 'IN'
            WHEN (accessreaderdevice.BOTYPE = 1) THEN 'OUT' END AS ACCESSTYPE,
       accessreaderdevice.DEVICEADDRESS DEVICEADDRESS,
       accessreaderdevice.DTSUPDATE DTSUPDATE
FROM OBJT_ACCESSREADERDEVICE accessreaderdevice
WHERE accessreaderdevice.BOTYPE IN(0,1) -- Access readers --
/
-- ACCESS GATES --

CREATE OR REPLACE VIEW DCEREPORT_ACCESS_GATES
AS
SELECT /*+ FIRST_ROWS(30) */ accessgate.OID OID,
       accessgate.NAME NAME,
       accessgate.DESCRIPTION DESCRIPTION,
       accessgate.DTSUPDATE DTSUPDATE
FROM OBJT_ACCESSGATE accessgate
/

-- ACCESS AREA --

CREATE OR REPLACE VIEW DCEREPORT_ACCESS_AREAS
AS
SELECT /*+ FIRST_ROWS(30) */ accessarea.OID OID,
       accessarea.NAME NAME,
       accessarea.DESCRIPTION DESCRIPTION,
       accessarea.EVACUATIONZONE EVACUATIONZONE,
       accessarea.DTSUPDATE DTSUPDATE
FROM OBJT_ACCESSAREA accessarea
/

-- DEPARTMENTS_EMPLOYEES --

CREATE OR REPLACE VIEW OBJTREP_DEPT_EMPLOYEES
AS
SELECT /*+ FIRST_ROWS(30) */ employee_department_link.OID OID,
       department.NAME NAME,
       department.DESCRIPTION DESCRIPTION,
       employee.OID EMPLOYEE_OID,
       employee.NAME EMPLOYEE_NAME,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee_department_link.DTSVALIDFROM EMP_DEP_LINK_DTSVALIDFROM,
       employee_department_link.DTSVALIDUNTIL EMP_DEP_LINK_DTSVALIDUNTIL,
       CAST(GREATEST(department.DTSUPDATE, employee.DTSUPDATE) AS DATE) DTSUPDATE,
       department.DTSUPDATE AS DTSUPDATE_1,
       employee.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_DEPARTMENT department,
     OBJT_EMPLOYEE employee,
     OBJT_RESOURCELINK employee_department_link
WHERE employee_department_link.CHILDOID = employee.OID
AND employee_department_link.PARENTOID = department.OID
/

-- ANOMALY REASONS --

CREATE OR REPLACE VIEW OBJTREP_ANOMALYREASONS
AS
SELECT /*+ FIRST_ROWS(30) */ reason.OID OID,
       reason.NAME NAME,
       reason.DESCRIPTION DESCRIPTION,
       reason.BOTYPE TYPE,
       reason.DTSUPDATE DTSUPDATE
FROM OBJT_REASON reason
/

-- ATTENDANCE PERIODS --

CREATE OR REPLACE VIEW OBJTREP_ATTENDANCEPERIODS
AS
SELECT /*+ FIRST_ROWS(30) */ period.OID OID,
       period.EMPLOYEEOID EMPLOYEE_OID,
       period.DTSSTART DTSSTART,
       period.DTSSTOP DTSSTOP,
       period.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEPERIOD period
/

-- PERIOD ATTENDANCE COUNTERS --

CREATE OR REPLACE VIEW OBJTREP_BALANCE_COUNTERS
AS
SELECT /*+ FIRST_ROWS(30) */ attcounter.OID OID,
       attcounter.EMPLOYEEOID EMPLOYEE_OID,
       attcounter.ATTENDANCECODEOID BALANCE_CODE_OID,
       attcounter.ATTENDANCEPERIODOID PERIOD_OID,
       attcounter.QTYTARGET START_VALUE,
       attcounter.VALUE END_VALUE,
       attcounter.QTYPLANNED PLANNED_VALUE,
       attcounter.DTSUPDATE DTSUPDATE
FROM OBJT_PERIODATTENDANCECOUNTER attcounter
/

-- DAY ATTENDANCE COUNTERS --

CREATE OR REPLACE VIEW OBJTREP_DAY_COUNTERS
AS
SELECT /*+ FIRST_ROWS(30) */ dayattendancecounter.OID OID,
       dayattendancecounter.EMPLOYEEOID EMPLOYEE_OID,
       dayattendancecounter.ATTENDANCECODEOID DAY_CODE_OID,
       attendanceday.DTS DTS,
       dayattendancecounter.VALUE DURATION,
       dayattendancecounter.DTSUPDATE DTSUPDATE
FROM OBJT_DAYATTENDANCECOUNTER dayattendancecounter,
     OBJT_ATTENDANCEDAY attendanceday
WHERE dayattendancecounter.ATTENDANCEDAYOID = attendanceday.OID
AND attendanceday.EMPLOYEEOID = dayattendancecounter.EMPLOYEEOID
/

-- DAY ATTENDANCE COUNTER COST DETAILS --

CREATE OR REPLACE VIEW OBJTREP_DAYATTCNTRCOSTDTLS
AS
SELECT /*+ FIRST_ROWS(30) */ counterdetail.OID OID,
       dayattendancecounter.EMPLOYEEOID EMPLOYEE_OID,
       dayattendancecounter.ATTENDANCECODEOID DAY_CODE_OID,
       counterdetail.COSTCENTEROID COSTCENTER_OID,
       counterdetail.USRTXT1 USRTXT1,
       counterdetail.USRTXT2 USRTXT2,
       counterdetail.USRTXT3 USRTXT3,
       counterdetail.USRTXT4 USRTXT4,
       counterdetail.USRTXT5 USRTXT5,
       attendanceday.DTS DTS,
       counterdetail.VALUE DURATION,
       counterdetail.DTSUPDATE DTSUPDATE
FROM OBJT_DAYATTENDANCECOUNTRCSTDTL counterdetail,
     OBJT_DAYATTENDANCECOUNTER dayattendancecounter,
     OBJT_ATTENDANCEDAY attendanceday
WHERE counterdetail.DAYATTENDANCECOUNTEROID = dayattendancecounter.OID
AND dayattendancecounter.ATTENDANCEDAYOID = attendanceday.OID
AND attendanceday.EMPLOYEEOID = dayattendancecounter.EMPLOYEEOID
/

-- ATTENDANCE EVENTS --

CREATE OR REPLACE VIEW OBJTREP_CLOCKINGEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ clockevent.OID OID,
       clockevent.EMPLOYEEOID EMPLOYEE_OID,
       clockevent.DEVICEOID DEVICE_OID,
       clockevent.DTS DTS,
       clockevent.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEEVENT clockevent
WHERE clockevent.CATEGORY = 'ATTENDANCE'
/

-- INFO EVENTS --

CREATE OR REPLACE VIEW OBJTREP_INFOEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ infoevent.OID OID,
       infoevent.EMPLOYEEOID EMPLOYEE_OID,
       infoevent.DEVICEOID DEVICE_OID,
       infoevent.DTS DTS,
       infoevent.USRTXT1 USRTXT1,
       infoevent.USRTXT2 USRTXT2,
       infoevent.USRTXT3 USRTXT3,
       infoevent.USRTXT4 USRTXT4,
       infoevent.USRTXT5 USRTXT5,
       infoevent.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEEVENT infoevent
WHERE infoevent.CATEGORY = 'INFO'
/

-- COSTCENTER EVENTS --

CREATE OR REPLACE VIEW OBJTREP_COSTCENTEREVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ costcenterevent.OID OID,
       costcenterevent.EMPLOYEEOID EMPLOYEE_OID,
       costcenterevent.DEVICEOID DEVICE_OID,
       costcenterevent.COSTCENTEROID COSTCENTER_OID,
       costcenterevent.DTS DTS,
       costcenterevent.USRTXT1 USRTXT1,
       costcenterevent.USRTXT2 USRTXT2,
       costcenterevent.USRTXT3 USRTXT3,
       costcenterevent.USRTXT4 USRTXT4,
       costcenterevent.USRTXT5 USRTXT5,
       costcenterevent.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEEVENT costcenterevent
WHERE costcenterevent.CATEGORY = 'COSTCENTER'
/

-- ACTUAL ATTENDANCES --

CREATE OR REPLACE VIEW OBJTREP_ACTUAL_ATTENDANCES
AS
SELECT /*+ FIRST_ROWS(30) */ attendance.OID OID,
       attendance.EMPLOYEEOID EMPLOYEE_OID,
       attendance.NAME NAME,
       attendance.DESCRIPTION DESCRIPTION,
       attendance.CATEGORY CATEGORY,
       attendance.DTSSTART DTSSTART,
       attendance.DTSSTOP DTSSTOP,
       attendance.ATTENDANCECODEOID DAY_CODE_OID,
       attendance.DTSVALIDFROM DTSVALIDFROM,
       attendance.DTSVALIDUNTIL DTSVALIDUNTIL,
       attendance.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEOPERATION attendance
WHERE attendance.BOTYPE = 1
/

-- ANOMALIES --

CREATE OR REPLACE VIEW OBJTREP_ANOMALIES
AS
SELECT /*+ FIRST_ROWS(30) */ anomaly.OID OID,
       attendanceday.EMPLOYEEOID EMPLOYEE_OID,
       anomaly.REASONOID REASON_OID,
       anomaly.DESCRIPTION DESCRIPTION,
       attendanceday.DTS DTS,
       anomaly.DTSVALIDUNTIL DTSVALIDUNTIL,
       anomaly.DTSUPDATE DTSUPDATE
FROM OBJT_ATTENDANCEDAYANOMALY anomaly,
     OBJT_ATTENDANCEDAY attendanceday
WHERE anomaly.ATTENDANCEDAYOID = attendanceday.OID
/
