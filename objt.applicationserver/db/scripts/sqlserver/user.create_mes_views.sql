-- SQL Server MES views --

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

-- DEPARTMENTS_CHILDDEPARTMENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DEPARTMENT_CHILDDEP') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DEPARTMENT_CHILDDEP
GO

CREATE VIEW DCEREPORT_DEPARTMENT_CHILDDEP
AS
SELECT department.OID OID,
       department.NAME NAME,
       department.DESCRIPTION DESCRIPTION,
       childdepartment.OID CHILDDEPARTMENT_OID,
       childdepartment.NAME CHILDDEPARTMENT_NAME,
       childdepartment.DESCRIPTION CHILDDEPARTMENT_DESCRIPTION,
       dbo.MaxDate(department.DTSUPDATE, childdepartment.DTSUPDATE) AS DTSUPDATE,
       department.DTSUPDATE AS DTSUPDATE_1,
       childdepartment.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_DEPARTMENT department WITH (NOLOCK),
     OBJT_RESOURCELINK dep_childdep_link WITH (NOLOCK),
     OBJT_DEPARTMENT childdepartment WITH (NOLOCK)
WHERE department.OID = dep_childdep_link.PARENTOID
AND dep_childdep_link.CHILDOID = childdepartment.OID
GO

-- DEPARTMENTS_PROCESSRESOURCES --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DEPARTMENT_RESRCS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DEPARTMENT_RESRCS
GO

CREATE VIEW DCEREPORT_DEPARTMENT_RESRCS
AS
SELECT department.OID OID,
       department.NAME NAME,
       department.DESCRIPTION DESCRIPTION,
       processresource.OID PROCESSRESOURCE_OID,
       processresource.NAME PROCESSRESOURCE_NAME,
       processresource.DESCRIPTION PROCESSRESOURCE_DESCRIPTION,
       CASE WHEN (processresource.CLASSOID = 9000000000000010923) THEN 'MACHINE'
             WHEN (processresource.CLASSOID = 9000000000000037041) THEN 'WORKCENTER' END AS PROCESSRESOURCE_TYPE,
       dbo.MaxDate(department.DTSUPDATE, processresource.DTSUPDATE) AS DTSUPDATE,
       department.DTSUPDATE AS DTSUPDATE_1,
       processresource.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_DEPARTMENT department WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_RESOURCELINK resource_department_link WITH (NOLOCK)
WHERE (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND resource_department_link.PARENTOID = department.OID
AND resource_department_link.CHILDOID = processresource.OID
GO

-- TOOLS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_TOOLS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_TOOLS
GO

CREATE VIEW DCEREPORT_TOOLS
AS
SELECT tool.OID OID,
       uom.OID UOM_OID,
       tool.NAME NAME,
       tool.DESCRIPTION DESCRIPTION,
       uom.SYMBOL UOM,
       tool.ID ID,
       tool.CATEGORY CATEGORY,
       tool.DTSVALIDFROM DTSVALIDFROM,
       tool.DTSVALIDUNTIL DTSVALIDUNTIL,
       tool.DTSUPDATE DTSUPDATE,
       tool.USRDTS1 USRDTS1,
       tool.USRDTS2 USRDTS2,
       tool.USRDTS3 USRDTS3,
       tool.USRDTS4 USRDTS4,
       tool.USRDTS5 USRDTS5,
       tool.USRFLG1 USRFLG1,
       tool.USRFLG2 USRFLG2,
       tool.USRFLG3 USRFLG3,
       tool.USRFLG4 USRFLG4,
       tool.USRFLG5 USRFLG5,
       tool.USRNUM1 USRNUM1,
       tool.USRNUM2 USRNUM2,
       tool.USRNUM3 USRNUM3,
       tool.USRNUM4 USRNUM4,
       tool.USRNUM5 USRNUM5,
       tool.USRTXT1 USRTXT1,
       tool.USRTXT2 USRTXT2,
       tool.USRTXT3 USRTXT3,
       tool.USRTXT4 USRTXT4,
       tool.USRTXT5 USRTXT5
FROM  OBJT_ITEM tool WITH (NOLOCK),
      OBJT_ITEMUOMLINK tool_uom_link WITH (NOLOCK),
      OBJT_UOM uom WITH (NOLOCK)
WHERE tool.BOTYPE = 10
AND tool.OID = tool_uom_link.ITEMOID
AND tool_uom_link.SEQ = 0
AND tool_uom_link.UOMOID = uom.OID
GO

-- RESOURCETRAINS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_RESOURCETRAINS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_RESOURCETRAINS
GO

CREATE VIEW DCEREPORT_RESOURCETRAINS
AS
SELECT resourcetrain.OID OID,
       resourcetrain.NAME NAME,
       resourcetrain.DESCRIPTION DESCRIPTION,
       resourcetrain.DTSVALIDFROM DTSVALIDFROM,
       resourcetrain.DTSVALIDUNTIL DTSVALIDUNTIL,
       resourcetrain.DTSUPDATE DTSUPDATE,
       resourcetrain.USRDTS1 USRDTS1,
       resourcetrain.USRDTS2 USRDTS2,
       resourcetrain.USRDTS3 USRDTS3,
       resourcetrain.USRDTS4 USRDTS4,
       resourcetrain.USRDTS5 USRDTS5,
       resourcetrain.USRFLG1 USRFLG1,
       resourcetrain.USRFLG2 USRFLG2,
       resourcetrain.USRFLG3 USRFLG3,
       resourcetrain.USRFLG4 USRFLG4,
       resourcetrain.USRFLG5 USRFLG5,
       resourcetrain.USRNUM1 USRNUM1,
       resourcetrain.USRNUM2 USRNUM2,
       resourcetrain.USRNUM3 USRNUM3,
       resourcetrain.USRNUM4 USRNUM4,
       resourcetrain.USRNUM5 USRNUM5,
       resourcetrain.USRTXT1 USRTXT1,
       resourcetrain.USRTXT2 USRTXT2,
       resourcetrain.USRTXT3 USRTXT3,
       resourcetrain.USRTXT4 USRTXT4,
       resourcetrain.USRTXT5 USRTXT5
FROM OBJT_RESOURCETRAIN resourcetrain WITH (NOLOCK)
GO

-- RESOURCETRAINS_PROCESSRESOURCES --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_RESOURCETRAIN_RESRCS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_RESOURCETRAIN_RESRCS
GO

CREATE VIEW DCEREPORT_RESOURCETRAIN_RESRCS
AS
SELECT resourcetrain.OID OID,
       resourcetrain.NAME NAME,
       resourcetrain.DESCRIPTION DESCRIPTION,
       processresource.OID PROCESSRESOURCE_OID,
       processresource.NAME PROCESSRESOURCE_NAME,
       processresource.DESCRIPTION PROCESSRESOURCE_DESCRIPTION,
       CASE WHEN (processresource.CLASSOID = 9000000000000010923) THEN 'MACHINE'
            WHEN (processresource.CLASSOID = 9000000000000037041) THEN 'WORKCENTER' END AS PROCESSRESOURCE_TYPE,
       dbo.MaxDate(resourcetrain.DTSUPDATE, processresource.DTSUPDATE) AS DTSUPDATE,
       resourcetrain.DTSUPDATE AS DTSUPDATE_1,
       processresource.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_RESOURCETRAIN resourcetrain WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_RESOURCELINK resource_resourcetrain_link WITH (NOLOCK)
WHERE (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND resource_resourcetrain_link.PARENTOID = resourcetrain.OID
AND resource_resourcetrain_link.CHILDOID = processresource.OID
GO

-- EQUIPMENTMODULES --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_EQUIPMENTMODULES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_EQUIPMENTMODULES
GO

CREATE VIEW DCEREPORT_EQUIPMENTMODULES
AS
SELECT equipmentmodule.OID OID,
       equipmentmodule.NAME NAME,
       equipmentmodule.DESCRIPTION DESCRIPTION,
       equipmentmodule.CATEGORY CATEGORY,
       resource_module_link.PARENTOID PROCESSRESOURCE_OID,
       equipmentmodule.DTSVALIDFROM DTSVALIDFROM,
       equipmentmodule.DTSVALIDUNTIL DTSVALIDUNTIL,
       equipmentmodule.DTSUPDATE DTSUPDATE,
       equipmentmodule.USRDTS1 USRDTS1,
       equipmentmodule.USRDTS2 USRDTS2,
       equipmentmodule.USRDTS3 USRDTS3,
       equipmentmodule.USRDTS4 USRDTS4,
       equipmentmodule.USRDTS5 USRDTS5,
       equipmentmodule.USRFLG1 USRFLG1,
       equipmentmodule.USRFLG2 USRFLG2,
       equipmentmodule.USRFLG3 USRFLG3,
       equipmentmodule.USRFLG4 USRFLG4,
       equipmentmodule.USRFLG5 USRFLG5,
       equipmentmodule.USRNUM1 USRNUM1,
       equipmentmodule.USRNUM2 USRNUM2,
       equipmentmodule.USRNUM3 USRNUM3,
       equipmentmodule.USRNUM4 USRNUM4,
       equipmentmodule.USRNUM5 USRNUM5,
       equipmentmodule.USRTXT1 USRTXT1,
       equipmentmodule.USRTXT2 USRTXT2,
       equipmentmodule.USRTXT3 USRTXT3,
       equipmentmodule.USRTXT4 USRTXT4,
       equipmentmodule.USRTXT5 USRTXT5
FROM OBJT_EQUIPMENTMODULE equipmentmodule WITH (NOLOCK),
     OBJT_RESOURCELINK resource_module_link WITH (NOLOCK)
WHERE equipmentmodule.OID = resource_module_link.CHILDOID
GO

-- ISPRESENTOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_ISPRESENTOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_ISPRESENTOPERATIONS
GO

CREATE VIEW DCEREPORT_ISPRESENTOPERATIONS
AS
SELECT ispresentoperation.OID OID,
       ispresentoperation.DTSSTART DTSSTART,
       ispresentoperation.DTSSTOP DTSSTOP,
       ispresentoperation.STATUS STATUS,
       employee.OID EMPLOYEE_OID,
       processresource.OID PROCESSRESOURCE_OID,
       ispresentoperation.DTSUPDATE DTSUPDATE
FROM OBJT_ISPRESENTOPERATION ispresentoperation WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK)
WHERE ispresentoperation.EMPLOYEEOID =  employee.OID
AND ispresentoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
GO

-- DIRECT TASKS --
-- aggregation of direct tasks on machines and workcenter, for workcenter the qtyproduced and qtyscrap are left joined
-- if qtyproduced and/or qtyscrap are null they are shown as '0' using an ISNULL statement
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DIRECT_TASKS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DIRECT_TASKS
GO

CREATE VIEW DCEREPORT_DIRECT_TASKS
AS
SELECT manoperation.OID OID,
       manoperation.DTSSTART DTSSTART,
       manoperation.DTSSTOP DTSSTOP,
       manoperation.STATUS STATUS,
       manoperation.RESOURCEALLOCATION ALLOCATION,
       manoperation.FTE FTE,
       productionorder.OID PRODUCTIONORDER_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       processresource.OID PROCESSRESOURCE_OID,
       manoperation.OPERATIONOID ACTIVITY_OID,
       employee.OID EMPLOYEE_OID,
       machineop_productiveitq.ITEMOID ITEM_OID,
       ISNULL(manop_productiveitq.VALUE, 0) AS QTY,
       ISNULL(manop_productiveitq.QTYINCOMPLETE, 0) AS QTYINCOMPLETE,
       ISNULL(manop_productiveitq.QTYNRFT, 0) AS QTYNRFT,
       ISNULL(manop_productiveitq.QTYSCRAP, 0) AS QTYREJECT,
       ISNULL(manop_productiveitq.QTYREJECTED, 0) AS QTYREJECTED,
       ISNULL(manop_productiveitq.QTYREWORKED, 0) AS QTYREWORKED,
       ISNULL(manop_productiveitq.QTYREWORKABLE, 0) AS QTYREWORKABLE,
       ISNULL(manop_productiveitq.QTYDIRECTREWORK, 0) AS QTYDIRECTREWORK,
       ISNULL(manop_productiveitq.QTYINDIRECTREWORK, 0) AS QTYINDIRECTREWORK,
       uom.SYMBOL UOM,
       dbo.MaxDate(manoperation.DTSUPDATE, manop_productiveitq.DTSUPDATE) AS DTSUPDATE
FROM (OBJT_MANOPERATION manoperation WITH (NOLOCK)
      LEFT OUTER JOIN OBJT_OPERATIONITEMQTYLINK manop_proditq_link WITH (NOLOCK) ON manop_proditq_link.OPERATIONOID = manoperation.OID AND manop_proditq_link.ITEMQTYCLASSNAME = 'objt.mes.bo.productionmgt.ProductiveItemQty')
        LEFT OUTER JOIN OBJT_PRODUCTIVEITEMQTY manop_productiveitq WITH (NOLOCK) ON manop_proditq_link.ITEMQTYOID = manop_productiveitq.OID,
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link WITH (NOLOCK),
     OBJT_PRODUCTIVEITEMQTY machineop_productiveitq WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE manoperation.BOTYPE = 1 -- DIRECT
AND manoperation.EMPLOYEEOID = employee.OID
AND manoperation.MACHINEOPERATIONOID = machineoperation.OID
AND manoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND machineoperation.OID = machineop_proditq_link.OPERATIONOID
AND machineop_proditq_link.ITEMQTYOID = machineop_productiveitq.OID
AND machineop_productiveitq.BOTYPE IN(0,5) -- PRIMARY (PHANTOM) OUTPUT
AND machineop_productiveitq.UOMOID = uom.OID
AND (manop_productiveitq.BOTYPE IS NULL OR manop_productiveitq.BOTYPE IN(0,5))
GO

-- ACTIVITIES (DIRECT MANUALOPERATIONS) --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_ACTIVITIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_ACTIVITIES
GO

CREATE VIEW DCEREPORT_ACTIVITIES
AS
SELECT manualoperation.OID OID,
       manualoperation.NAME NAME,
       manualoperation.DESCRIPTION DESCRIPTION,
       manualoperation.ID ID,
       manualoperation.PRIORITY PRIORITY,
       CAST(CASE WHEN (manualoperation.OPERATIONOPTION & 1 = 1) THEN 'F' ELSE 'T' END AS CHAR(1)) AS PRODUCTIVE,
       manualoperation.DTSVALIDFROM DTSVALIDFROM,
       manualoperation.DTSVALIDUNTIL DTSVALIDUNTIL,
       manualoperation.DTSUPDATE DTSUPDATE
FROM OBJT_MANUALOPERATION manualoperation WITH (NOLOCK)
WHERE manualoperation.BOTYPE = 1 -- DIRECT
GO

-- ALLOCATION DETAILS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_ALLOCATIONDETAILS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_ALLOCATIONDETAILS
GO

CREATE VIEW DCEREPORT_ALLOCATIONDETAILS
AS
SELECT allocationdetail.OID OID,
       allocationdetail.MANOPERATIONOID TASK_OID,
       allocationdetail.RESOURCEALLOCATION RESOURCEALLOCATION,
       allocationdetail.DTSSTART DTSSTART,
       allocationdetail.DTSSTOP DTSSTOP,
       allocationdetail.DTSUPDATE DTSUPDATE
FROM OBJT_MANOPERATIONALLOCATIONDTL allocationdetail WITH (NOLOCK)
GO

-- INDIRECT TASKS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INDIRECT_TASKS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INDIRECT_TASKS
GO

CREATE VIEW DCEREPORT_INDIRECT_TASKS
AS
SELECT manoperation.OID OID,
       manoperation.DTSSTART DTSSTART,
       manoperation.DTSSTOP DTSSTOP,
       manoperation.STATUS STATUS,
       manoperation.RESOURCEALLOCATION ALLOCATION,
       manoperation.FTE FTE,
       manoperation.OPERATIONOID MANUALOPERATION_OID,
       processresource.OID PROCESSRESOURCE_OID,
       employee.OID EMPLOYEE_OID,
       manoperation.DTSUPDATE DTSUPDATE
FROM OBJT_MANOPERATION manoperation WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK)
WHERE manoperation.BOTYPE = 0 -- INDIRECT
AND manoperation.EMPLOYEEOID = employee.OID
AND manoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
GO

-- INDIRECT MANUALOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MANUALOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MANUALOPERATIONS
GO

CREATE VIEW DCEREPORT_MANUALOPERATIONS
AS
SELECT manualoperation.OID OID,
       manualoperation.NAME NAME,
       manualoperation.DESCRIPTION DESCRIPTION,
       manualoperation.PRIORITY PRIORITY,
       operationgroup.NAME GROUP_NAME,
       operationgroup.DESCRIPTION GROUP_DESCRIPTION,
       manualoperation.DTSVALIDFROM DTSVALIDFROM,
       manualoperation.DTSVALIDUNTIL DTSVALIDUNTIL,
       dbo.MaxDate(manualoperation.DTSUPDATE, operationgroup.DTSUPDATE) AS DTSUPDATE,
       manualoperation.DTSUPDATE AS DTSUPDATE_1,
       operationgroup.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_MANUALOPERATION manualoperation WITH (NOLOCK),
     OBJT_OPERATIONLINK manualoperation_grouplink WITH (NOLOCK),
     OBJT_OPERATIONGROUP operationgroup WITH (NOLOCK)
WHERE manualoperation.BOTYPE = 0 -- INDIRECT
AND manualoperation_grouplink.CHILDOID = manualoperation.OID
AND manualoperation_grouplink.PARENTOID = operationgroup.OID
GO

-- ALARMS --
-- currently only for machines (machineoid on dceoperationmgt_operation)
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_ALARMS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_ALARMS
GO

CREATE VIEW DCEREPORT_ALARMS
AS
SELECT alarm.OID OID,
       alarm.NAME NAME,
       alarm.DESCRIPTION DESCRIPTION,
       alarm.SEVERITY SEVERITY,
       alarm.DTSSTART DTSSTART,
       alarm.DTSSTOP DTSSTOP,
       alarm.STATUS STATUS,
       alarm.RESOURCEOID PROCESSRESOURCE_OID,
       alarm.EQUIPMENTMODULEOID EQUIPMENTMODULE_OID,
       alarm.DTSUPDATE DTSUPDATE,
       alarm.USRDTS1 USRDTS1,
       alarm.USRDTS2 USRDTS2,
       alarm.USRDTS3 USRDTS3,
       alarm.USRDTS4 USRDTS4,
       alarm.USRDTS5 USRDTS5,
       alarm.USRFLG1 USRFLG1,
       alarm.USRFLG2 USRFLG2,
       alarm.USRFLG3 USRFLG3,
       alarm.USRFLG4 USRFLG4,
       alarm.USRFLG5 USRFLG5,
       alarm.USRNUM1 USRNUM1,
       alarm.USRNUM2 USRNUM2,
       alarm.USRNUM3 USRNUM3,
       alarm.USRNUM4 USRNUM4,
       alarm.USRNUM5 USRNUM5,
       alarm.USRTXT1 USRTXT1,
       alarm.USRTXT2 USRTXT2,
       alarm.USRTXT3 USRTXT3,
       alarm.USRTXT4 USRTXT4,
       alarm.USRTXT5 USRTXT5
FROM OBJT_ALARM alarm WITH (NOLOCK)
GO

-- INTERRUPTOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INTERRUPTOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INTERRUPTOPERATIONS
GO

CREATE VIEW DCEREPORT_INTERRUPTOPERATIONS
AS
SELECT interruptoperation.OID OID,
       interruptoperation.DTSSTART DTSSTART,
       interruptoperation.DTSSTOP DTSSTOP,
       interruptoperation.STATUS STATUS,
       interruptoperation.REASONOID REASON_OID,
       interruptoperation.DESCRIPTION DESCRIPTION,
       processresource.OID PROCESSRESOURCE_OID,
       (SELECT TOP 1 machineoperation.OID FROM OBJT_OPERATIONLINK machineop_interruptop_link WITH (NOLOCK),
                                               OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK)
                                          WHERE interruptoperation.OID = machineop_interruptop_link.CHILDOID
                                          AND machineop_interruptop_link.PARENTOID = machineoperation.OID) AS MACHINEOPERATION_OID,
       (SELECT TOP 1 alarm.OID FROM OBJT_OPERATIONLINK interruptop_alarm_link WITH (NOLOCK),
                                    OBJT_ALARM alarm WITH (NOLOCK)
                               WHERE interruptoperation.OID = interruptop_alarm_link.PARENTOID
                               AND interruptop_alarm_link.CHILDOID = alarm.OID) AS ALARM_OID,
       interruptoperation.DTSUPDATE DTSUPDATE
FROM OBJT_INTERRUPTOPERATION interruptoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK)
WHERE interruptoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
GO

-- INTERRUPT REASONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INTERRUPTREASONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INTERRUPTREASONS
GO

CREATE VIEW DCEREPORT_INTERRUPTREASONS
AS
SELECT reason.OID OID,
       reason.NAME NAME,
       reason.DESCRIPTION DESCRIPTION,
       reason.OEECATEGORY OEECATEGORY,
       reason.SEVERITY SEVERITY,
       reasongroup.NAME REASONGROUP_NAME,
       reasongroup.DESCRIPTION REASONGROUP_DESCRIPTION,
       reason.DTSVALIDFROM DTSVALIDFROM,
       reason.DTSVALIDUNTIL DTSVALIDUNTIL,
       dbo.MaxDate(reason.DTSUPDATE, reasongroup.DTSUPDATE) AS DTSUPDATE,
       reason.USRDTS1 USRDTS1,
       reason.USRDTS2 USRDTS2,
       reason.USRDTS3 USRDTS3,
       reason.USRDTS4 USRDTS4,
       reason.USRDTS5 USRDTS5,
       reason.USRFLG1 USRFLG1,
       reason.USRFLG2 USRFLG2,
       reason.USRFLG3 USRFLG3,
       reason.USRFLG4 USRFLG4,
       reason.USRFLG5 USRFLG5,
       reason.USRNUM1 USRNUM1,
       reason.USRNUM2 USRNUM2,
       reason.USRNUM3 USRNUM3,
       reason.USRNUM4 USRNUM4,
       reason.USRNUM5 USRNUM5,
       reason.USRTXT1 USRTXT1,
       reason.USRTXT2 USRTXT2,
       reason.USRTXT3 USRTXT3,
       reason.USRTXT4 USRTXT4,
       reason.USRTXT5 USRTXT5,
       reason.DTSUPDATE AS DTSUPDATE_1,
       reasongroup.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_INTERRUPTREASON reason WITH (NOLOCK),
     OBJT_INTERRUPTREASONGROUP reasongroup WITH (NOLOCK)
WHERE reason.GROUPOID = reasongroup.OID
GO

-- REJECTOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_REJECTOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_REJECTOPERATIONS
GO

CREATE VIEW DCEREPORT_REJECTOPERATIONS
AS
SELECT scrapoperation.OID OID,
       scrapoperation.BOTYPE TYPE,
       scrapoperation.DTSSTART DTSSTART,
       scrapoperation.DTSSTOP DTSSTOP,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       CAST (NULL AS BIGINT) DIRECT_TASK_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       CAST (NULL AS BIGINT) EMPLOYEE_OID,
       scrapitemqty.ITEMOID ITEM_OID,
       scrapitemqty.REASONOID REASON_OID,
       scrapitemqty.QTYNRFT QTYNRFT,
       (scrapitemqty.VALUE - scrapitemqty.QTYREWORKED) QTYREJECT,
       scrapitemqty.VALUE QTYREJECTED,
       scrapitemqty.QTYSETUP QTYREJECTED_SETUP,
       scrapitemqty.QTYLOAD QTYREJECTED_LOAD,
       scrapitemqty.QTYRUN QTYREJECTED_RUN,
       scrapitemqty.QTYUNLOAD QTYREJECTED_UNLOAD,
       scrapitemqty.QTYRESET QTYREJECTED_RESET,
       scrapitemqty.QTYREWORKED QTYREWORKED,
       scrapitemqty.QTYREWORKABLE QTYREWORKABLE,
       uom.SYMBOL UOM,
       scrapoperation.DTSUPDATE DTSUPDATE
FROM OBJT_SCRAPOPERATION scrapoperation WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_SCRAPITEMQTY scrapitemqty WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE scrapoperation.MACHINEOPERATIONOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND scrapoperation.OID = scrapitemqty.SCRAPOPERATIONOID
AND scrapitemqty.UOMOID = uom.OID
GO

-- REWORKOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_REWORKOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_REWORKOPERATIONS
GO

CREATE VIEW DCEREPORT_REWORKOPERATIONS
AS
SELECT reworkoperation.OID OID,
       reworkoperation.DTSSTART DTSSTART,
       reworkoperation.DTSSTOP DTSSTOP,
       scrapoperation.OID REJECTOPERATION_OID,
       reworkoperation.MANOPERATIONOID DIRECT_TASK_OID,
       employee.OID EMPLOYEE_OID,
       reworkitemqty.ITEMOID ITEM_OID,
       reworkitemqty.REASONOID REASON_OID,
       reworkoperation.DESCRIPTION DESCRIPTION,
       reworkitemqty.VALUE QTYREWORKED,
       uom.SYMBOL UOM,
       reworkoperation.DTSUPDATE DTSUPDATE
FROM OBJT_REWORKOPERATION reworkoperation WITH (NOLOCK),
     OBJT_SCRAPOPERATION scrapoperation WITH (NOLOCK),
     OBJT_REWORKITEMQTY reworkitemqty WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE reworkoperation.SCRAPOPERATIONOID = scrapoperation.OID
AND reworkoperation.OID = reworkitemqty.REWORKOPERATIONOID
AND reworkitemqty.UOMOID = uom.OID
AND reworkoperation.EMPLOYEEOID = employee.OID
GO

-- REJECT REASONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_REJECTREASONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_REJECTREASONS
GO

CREATE VIEW DCEREPORT_REJECTREASONS
AS
SELECT reason.OID OID,
       reason.NAME NAME,
       reason.DESCRIPTION DESCRIPTION,
       reason.CATEGORY CATEGORY,
       reasongroup.NAME REASONGROUP_NAME,
       reasongroup.DESCRIPTION REASONGROUP_DESCRIPTION,
       reasongroup.BOTYPE REASONGROUP_TYPE,
       reasongroup.CATEGORY REASONGROUP_CATEGORY,
       reason.DTSVALIDFROM DTSVALIDFROM,
       reason.DTSVALIDUNTIL DTSVALIDUNTIL,
       dbo.MaxDate(reason.DTSUPDATE, reasongroup.DTSUPDATE) AS DTSUPDATE,
       reason.USRDTS1 USRDTS1,
       reason.USRDTS2 USRDTS2,
       reason.USRDTS3 USRDTS3,
       reason.USRDTS4 USRDTS4,
       reason.USRDTS5 USRDTS5,
       reason.USRFLG1 USRFLG1,
       reason.USRFLG2 USRFLG2,
       reason.USRFLG3 USRFLG3,
       reason.USRFLG4 USRFLG4,
       reason.USRFLG5 USRFLG5,
       reason.USRNUM1 USRNUM1,
       reason.USRNUM2 USRNUM2,
       reason.USRNUM3 USRNUM3,
       reason.USRNUM4 USRNUM4,
       reason.USRNUM5 USRNUM5,
       reason.USRTXT1 USRTXT1,
       reason.USRTXT2 USRTXT2,
       reason.USRTXT3 USRTXT3,
       reason.USRTXT4 USRTXT4,
       reason.USRTXT5 USRTXT5,
       reason.DTSUPDATE AS DTSUPDATE_1,
       reasongroup.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_SCRAPREASON reason WITH (NOLOCK),
     OBJT_SCRAPREASONGROUP reasongroup WITH (NOLOCK)
WHERE reason.GROUPOID = reasongroup.OID
GO

-- MAINTENANCE --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MAINTENANCE_TASKS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MAINTENANCE_TASKS
GO

CREATE VIEW DCEREPORT_MAINTENANCE_TASKS
AS
SELECT manoperation.OID OID,
       manoperation.DTSSTART DTSSTART,
       manoperation.DTSSTOP DTSSTOP,
       manoperation.STATUS STATUS,
       manoperation.RESOURCEALLOCATION ALLOCATION,
       manoperation.FTE FTE,
       maintenanceorder.OID MAINTENANCEORDER_OID,
       maintenanceorder.ID MAINTENANCEORDER_ID,
       maintenanceoperation.OID MAINTENANCEOPERATION_OID,
       maintenanceoperation.NAME MAINTENANCEOPERATION_NAME,
       processresource.OID PROCESSRESOURCE_OID,
       employee.OID EMPLOYEE_OID,
       dbo.MaxDate(dbo.MaxDate(manoperation.DTSUPDATE, maintenanceoperation.DTSUPDATE), maintenanceorder.DTSUPDATE) AS DTSUPDATE,
       manoperation.DTSUPDATE AS DTSUPDATE_1,
       maintenanceoperation.DTSUPDATE AS DTSUPDATE_2,
       maintenanceorder.DTSUPDATE AS DTSUPDATE_3
FROM OBJT_MANOPERATION manoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_EMPLOYEE employee WITH (NOLOCK),
     OBJT_OPERATIONLINK manop_maintop_link WITH (NOLOCK),
     OBJT_MAINTENANCEOPERATION maintenanceoperation WITH (NOLOCK),
     OBJT_MAINTENANCEORDER maintenanceorder WITH (NOLOCK)
WHERE manoperation.BOTYPE = 2 -- MAINTENANCE
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND manoperation.PROCESSUNITOID = processresource.OID
AND manoperation.EMPLOYEEOID = employee.OID
AND manoperation.OID = manop_maintop_link.CHILDOID
AND maintenanceoperation.OID = manop_maintop_link.PARENTOID
AND maintenanceorder.OID = maintenanceoperation.MAINTENANCEORDEROID
GO

-- PRODUCTIONOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_PRODUCTIONOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_PRODUCTIONOPERATIONS
GO

CREATE VIEW DCEREPORT_PRODUCTIONOPERATIONS
AS
SELECT productionoperation.OID OID,
       productionoperation.NAME NAME,
       productionoperation.DESCRIPTION DESCRIPTION,
       productionorder.OID PRODUCTIONORDER_OID,
       productionoperation.DTSPLANNEDSTART DTSPLANNEDSTART,
       productionoperation.DTSPLANNEDSTOP DTSPLANNEDSTOP,
       productionoperation.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       productionoperation.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       productionoperation.DTSSTART DTSSTART,
       productionoperation.DTSSTOP DTSSTOP,
       productionoperation.STATUS STATUS,
       productionoperation.USRDTS1 USRDTS1,
       productionoperation.USRDTS2 USRDTS2,
       productionoperation.USRDTS3 USRDTS3,
       productionoperation.USRDTS4 USRDTS4,
       productionoperation.USRDTS5 USRDTS5,
       productionoperation.USRDTS6 USRDTS6,
       productionoperation.USRDTS7 USRDTS7,
       productionoperation.USRDTS8 USRDTS8,
       productionoperation.USRDTS9 USRDTS9,
       productionoperation.USRDTS10 USRDTS10,
       productionoperation.USRDTS11 USRDTS11,
       productionoperation.USRDTS12 USRDTS12,
       productionoperation.USRDTS13 USRDTS13,
       productionoperation.USRDTS14 USRDTS14,
       productionoperation.USRDTS15 USRDTS15,
       productionoperation.USRDTS16 USRDTS16,
       productionoperation.USRDTS17 USRDTS17,
       productionoperation.USRDTS18 USRDTS18,
       productionoperation.USRDTS19 USRDTS19,
       productionoperation.USRDTS20 USRDTS20,
       productionoperation.USRDTS21 USRDTS21,
       productionoperation.USRDTS22 USRDTS22,
       productionoperation.USRDTS23 USRDTS23,
       productionoperation.USRDTS24 USRDTS24,
       productionoperation.USRDTS25 USRDTS25,
       productionoperation.USRDTS26 USRDTS26,
       productionoperation.USRDTS27 USRDTS27,
       productionoperation.USRDTS28 USRDTS28,
       productionoperation.USRDTS29 USRDTS29,
       productionoperation.USRDTS30 USRDTS30,
       productionoperation.USRFLG1 USRFLG1,
       productionoperation.USRFLG2 USRFLG2,
       productionoperation.USRFLG3 USRFLG3,
       productionoperation.USRFLG4 USRFLG4,
       productionoperation.USRFLG5 USRFLG5,
       productionoperation.USRFLG6 USRFLG6,
       productionoperation.USRFLG7 USRFLG7,
       productionoperation.USRFLG8 USRFLG8,
       productionoperation.USRFLG9 USRFLG9,
       productionoperation.USRFLG10 USRFLG10,
       productionoperation.USRFLG11 USRFLG11,
       productionoperation.USRFLG12 USRFLG12,
       productionoperation.USRFLG13 USRFLG13,
       productionoperation.USRFLG14 USRFLG14,
       productionoperation.USRFLG15 USRFLG15,
       productionoperation.USRFLG16 USRFLG16,
       productionoperation.USRFLG17 USRFLG17,
       productionoperation.USRFLG18 USRFLG18,
       productionoperation.USRFLG19 USRFLG19,
       productionoperation.USRFLG20 USRFLG20,
       productionoperation.USRFLG21 USRFLG21,
       productionoperation.USRFLG22 USRFLG22,
       productionoperation.USRFLG23 USRFLG23,
       productionoperation.USRFLG24 USRFLG24,
       productionoperation.USRFLG25 USRFLG25,
       productionoperation.USRFLG26 USRFLG26,
       productionoperation.USRFLG27 USRFLG27,
       productionoperation.USRFLG28 USRFLG28,
       productionoperation.USRFLG29 USRFLG29,
       productionoperation.USRFLG30 USRFLG30,
       productionoperation.USRNUM1 USRNUM1,
       productionoperation.USRNUM2 USRNUM2,
       productionoperation.USRNUM3 USRNUM3,
       productionoperation.USRNUM4 USRNUM4,
       productionoperation.USRNUM5 USRNUM5,
       productionoperation.USRNUM6 USRNUM6,
       productionoperation.USRNUM7 USRNUM7,
       productionoperation.USRNUM8 USRNUM8,
       productionoperation.USRNUM9 USRNUM9,
       productionoperation.USRNUM10 USRNUM10,
       productionoperation.USRNUM11 USRNUM11,
       productionoperation.USRNUM12 USRNUM12,
       productionoperation.USRNUM13 USRNUM13,
       productionoperation.USRNUM14 USRNUM14,
       productionoperation.USRNUM15 USRNUM15,
       productionoperation.USRNUM16 USRNUM16,
       productionoperation.USRNUM17 USRNUM17,
       productionoperation.USRNUM18 USRNUM18,
       productionoperation.USRNUM19 USRNUM19,
       productionoperation.USRNUM20 USRNUM20,
       productionoperation.USRNUM21 USRNUM21,
       productionoperation.USRNUM22 USRNUM22,
       productionoperation.USRNUM23 USRNUM23,
       productionoperation.USRNUM24 USRNUM24,
       productionoperation.USRNUM25 USRNUM25,
       productionoperation.USRNUM26 USRNUM26,
       productionoperation.USRNUM27 USRNUM27,
       productionoperation.USRNUM28 USRNUM28,
       productionoperation.USRNUM29 USRNUM29,
       productionoperation.USRNUM30 USRNUM30,
       productionoperation.USRNUM31 USRNUM31,
       productionoperation.USRNUM32 USRNUM32,
       productionoperation.USRNUM33 USRNUM33,
       productionoperation.USRNUM34 USRNUM34,
       productionoperation.USRNUM35 USRNUM35,
       productionoperation.USRNUM36 USRNUM36,
       productionoperation.USRNUM37 USRNUM37,
       productionoperation.USRNUM38 USRNUM38,
       productionoperation.USRNUM39 USRNUM39,
       productionoperation.USRNUM40 USRNUM40,
       productionoperation.USRNUM41 USRNUM41,
       productionoperation.USRNUM42 USRNUM42,
       productionoperation.USRNUM43 USRNUM43,
       productionoperation.USRNUM44 USRNUM44,
       productionoperation.USRNUM45 USRNUM45,
       productionoperation.USRNUM46 USRNUM46,
       productionoperation.USRNUM47 USRNUM47,
       productionoperation.USRNUM48 USRNUM48,
       productionoperation.USRNUM49 USRNUM49,
       productionoperation.USRNUM50 USRNUM50,
       productionoperation.USRNUM51 USRNUM51,
       productionoperation.USRNUM52 USRNUM52,
       productionoperation.USRNUM53 USRNUM53,
       productionoperation.USRNUM54 USRNUM54,
       productionoperation.USRNUM55 USRNUM55,
       productionoperation.USRNUM56 USRNUM56,
       productionoperation.USRNUM57 USRNUM57,
       productionoperation.USRNUM58 USRNUM58,
       productionoperation.USRNUM59 USRNUM59,
       productionoperation.USRNUM60 USRNUM60,
       productionoperation.USRNUM61 USRNUM61,
       productionoperation.USRNUM62 USRNUM62,
       productionoperation.USRNUM63 USRNUM63,
       productionoperation.USRNUM64 USRNUM64,
       productionoperation.USRNUM65 USRNUM65,
       productionoperation.USRTXT1 USRTXT1,
       productionoperation.USRTXT2 USRTXT2,
       productionoperation.USRTXT3 USRTXT3,
       productionoperation.USRTXT4 USRTXT4,
       productionoperation.USRTXT5 USRTXT5,
       productionoperation.USRTXT6 USRTXT6,
       productionoperation.USRTXT7 USRTXT7,
       productionoperation.USRTXT8 USRTXT8,
       productionoperation.USRTXT9 USRTXT9,
       productionoperation.USRTXT10 USRTXT10,
       productionoperation.USRTXT11 USRTXT11,
       productionoperation.USRTXT12 USRTXT12,
       productionoperation.USRTXT13 USRTXT13,
       productionoperation.USRTXT14 USRTXT14,
       productionoperation.USRTXT15 USRTXT15,
       productionoperation.USRTXT16 USRTXT16,
       productionoperation.USRTXT17 USRTXT17,
       productionoperation.USRTXT18 USRTXT18,
       productionoperation.USRTXT19 USRTXT19,
       productionoperation.USRTXT20 USRTXT20,
       productionoperation.USRTXT21 USRTXT21,
       productionoperation.USRTXT22 USRTXT22,
       productionoperation.USRTXT23 USRTXT23,
       productionoperation.USRTXT24 USRTXT24,
       productionoperation.USRTXT25 USRTXT25,
       productionoperation.USRTXT26 USRTXT26,
       productionoperation.USRTXT27 USRTXT27,
       productionoperation.USRTXT28 USRTXT28,
       productionoperation.USRTXT29 USRTXT29,
       productionoperation.USRTXT30 USRTXT30,
       productionoperation.USRTXT31 USRTXT31,
       productionoperation.USRTXT32 USRTXT32,
       productionoperation.USRTXT33 USRTXT33,
       productionoperation.USRTXT34 USRTXT34,
       productionoperation.USRTXT35 USRTXT35,
       productionoperation.USRTXT36 USRTXT36,
       productionoperation.USRTXT37 USRTXT37,
       productionoperation.USRTXT38 USRTXT38,
       productionoperation.USRTXT39 USRTXT39,
       productionoperation.USRTXT40 USRTXT40,
       productionoperation.USRTXT41 USRTXT41,
       productionoperation.USRTXT42 USRTXT42,
       productionoperation.USRTXT43 USRTXT43,
       productionoperation.USRTXT44 USRTXT44,
       productionoperation.USRTXT45 USRTXT45,
       productionoperation.USRTXT46 USRTXT46,
       productionoperation.USRTXT47 USRTXT47,
       productionoperation.USRTXT48 USRTXT48,
       productionoperation.USRTXT49 USRTXT49,
       productionoperation.USRTXT50 USRTXT50,
       productionoperation.USRTXT51 USRTXT51,
       productionoperation.USRTXT52 USRTXT52,
       productionoperation.USRTXT53 USRTXT53,
       productionoperation.USRTXT54 USRTXT54,
       productionoperation.USRTXT55 USRTXT55,
       productionoperation.USRTXT56 USRTXT56,
       productionoperation.USRTXT57 USRTXT57,
       productionoperation.USRTXT58 USRTXT58,
       productionoperation.USRTXT59 USRTXT59,
       productionoperation.USRTXT60 USRTXT60,
       productionoperation.USRTXT61 USRTXT61,
       productionoperation.USRTXT62 USRTXT62,
       productionoperation.USRTXT63 USRTXT63,
       productionoperation.USRTXT64 USRTXT64,
       productionoperation.USRTXT65 USRTXT65,
       processresource.OID PROCESSRESOURCE_OID,
       productionitq.ITEMOID ITEM_OID,
       productionitq.QTYTARGET QTYPLANNED,
       productionitq.QTYFACTOR QTYFACTOR,
       productionitq.QTYUNIT QTYUNIT,
       productionitq.VALUE QTY,
       productionitq.QTYINCOMPLETE QTYINCOMPLETE,
       productionitq.QTYNRFT QTYNRFT,
       productionitq.QTYSCRAP QTYREJECT,
       productionitq.QTYREJECTED QTYREJECTED,
       productionitq.QTYREWORKED QTYREWORKED,
       productionitq.QTYREWORKABLE QTYREWORKABLE,
       uom.SYMBOL UOM,
       dbo.MaxDate(productionoperation.DTSUPDATE, productionitq.DTSUPDATE) AS DTSUPDATE
FROM (OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK)
          LEFT OUTER JOIN OBJT_PROCESSUNIT processresource WITH (NOLOCK)
          ON productionoperation.PROCESSUNITOID  = processresource.OID
          AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK productionop_proditq_link WITH (NOLOCK),
     OBJT_PRODUCTIONITEMQTY productionitq WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND productionoperation.OID = productionop_proditq_link.OPERATIONOID
AND productionop_proditq_link.ITEMQTYOID = productionitq.OID
AND productionitq.BOTYPE IN(0,5) -- PRIMARY (PHANTOM) OUTPUT
AND productionitq.UOMOID = uom.OID
GO

-- MACHINEOPERATIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MACHINEOPERATIONS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MACHINEOPERATIONS
GO

CREATE VIEW DCEREPORT_MACHINEOPERATIONS
AS
SELECT machineoperation.OID OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       machineoperation.DTSPLANNEDSTART DTSPLANNEDSTART,
       machineoperation.DTSPLANNEDSTOP DTSPLANNEDSTOP,
       machineoperation.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       machineoperation.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       machineoperation.DTSSTART DTSSTART,
       machineoperation.DTSSTOP DTSSTOP,
       machineoperation.STATUS STATUS,
       machineoperation.INSTRUCTIONSTATUS INSTRUCTIONSTATUS, -- 0 = OK, 1 = WARNING or 2 = ERROR
       processresource.OID PROCESSRESOURCE_OID,
       productiveitq.ITEMOID ITEM_OID,
       productiveitq.QTYTARGET QTYPLANNED,
       productiveitq.QTYFACTOR QTYFACTOR,
       productiveitq.QTYUNIT QTYUNIT,
       productiveitq.VALUE QTY,
       productiveitq.QTYINCOMPLETE QTYINCOMPLETE,
       productiveitq.QTYNRFT QTYNRFT,
       productiveitq.QTYSCRAP QTYREJECT,
       productiveitq.QTYREJECTED QTYREJECTED,
       productiveitq.QTYREWORKED QTYREWORKED,
       productiveitq.QTYREWORKABLE QTYREWORKABLE,
       uom.SYMBOL UOM,
       dbo.MaxDate(machineoperation.DTSUPDATE, productiveitq.DTSUPDATE) AS DTSUPDATE
FROM OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link WITH (NOLOCK),
     OBJT_PRODUCTIVEITEMQTY productiveitq WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND machineoperation.OID = machineop_proditq_link.OPERATIONOID
AND machineop_proditq_link.ITEMQTYOID = productiveitq.OID
AND productiveitq.BOTYPE IN(0,5) -- PRIMARY (PHANTOM) OUTPUT
AND productiveitq.UOMOID = uom.OID
GO

-- MACHINEOPERATION SEGMENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MACHINEOP_SEGMENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MACHINEOP_SEGMENTS
GO

CREATE VIEW DCEREPORT_MACHINEOP_SEGMENTS
AS
SELECT operationsegment.OID OID,
       operationsegment.NAME NAME,
       operationsegment.DTSSTART DTSSTART,
       operationsegment.DTSSTOP DTSSTOP,
       operationsegment.DTSPLANNEDSTART DTSPLANNEDSTART,
       operationsegment.DTSPLANNEDSTOP DTSPLANNEDSTOP,
       CASE WHEN (operationsegment.OPERATIONOPTION = 0) THEN ((operationsegment.DURATION * ISNULL(uomconv.FACTOR, 1) * productiveitemqty.QTYTARGET)/(productiveitemqty.QTYFACTOR * productiveitemqty.QTYUNIT))
            WHEN (operationsegment.OPERATIONOPTION IN (1, 3)) THEN ((operationsegment.DURATION * ISNULL(uomconv.FACTOR, 1) * productiveitemqty.QTYTARGET)/operationsegment.TARGETDURATIONQTY)
            ELSE operationsegment.DURATION
            END AS TARGETDURATION,
       ISNULL(efficiencyparam.VALUE, 1) EFFICIENCY,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       operationsegment.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONSEGMENT operationsegment WITH (NOLOCK)
     LEFT OUTER JOIN OBJT_UOM fromuom WITH (NOLOCK) ON operationsegment.TARGETDURATIONUOMOID = fromuom.OID
     LEFT OUTER JOIN OBJT_UOM touom WITH (NOLOCK) ON touom.NAME = 'millisecond'
     LEFT OUTER JOIN OBJT_UOMCONVERSION uomconv WITH (NOLOCK) ON uomconv.FROMUOMOID = fromuom.OID AND uomconv.TOUOMOID = touom.OID
     LEFT OUTER JOIN OBJT_PARAMETER efficiencyparam WITH (NOLOCK) ON efficiencyparam.OWNEROID = operationsegment.OID AND efficiencyparam.NAME = 'EFFICIENCY',
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONLINK machineop_segment_oplink WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK machineop_prodveitq_link WITH (NOLOCK),
     OBJT_PRODUCTIVEITEMQTY productiveitemqty WITH (NOLOCK)
WHERE machineoperation.PROCESSUNITOID = processresource.OID
AND processresource.CLASSOID IN (9000000000000010923,9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND machineoperation.OID = machineop_segment_oplink.PARENTOID
AND operationsegment.OID = machineop_segment_oplink.CHILDOID
AND operationsegment.STATUS IN (3,4,8) -- RUNNING, COMPLETE or HELD segments
AND operationsegment.CLASSOID IN (9000000000000091241,9000000000000091243,9000000000000091245,9000000000000091247,9000000000000091239)
AND machineoperation.OID = machineop_prodveitq_link.OPERATIONOID
AND machineop_prodveitq_link.ITEMQTYOID = productiveitemqty.OID
AND machineop_prodveitq_link.SEQ = 0
GO

-- DIRECT TASK SEGMENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DIRECT_TASK_SEGMENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DIRECT_TASK_SEGMENTS
GO

CREATE VIEW DCEREPORT_DIRECT_TASK_SEGMENTS
AS
SELECT operationsegment.OID OID,
       operationsegment.NAME NAME,
       operationsegment.DTSSTART DTSSTART,
       operationsegment.DTSSTOP DTSSTOP,
       operationsegment.STATUS STATUS,
       workcenter.OID WORKCENTER_OID,
       manoperation.OID DIRECT_TASK_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       machineop_productiveitq.ITEMOID ITEM_OID,
       CASE
          WHEN (operationsegment.CLASSOID = 9000000000000091241) THEN ISNULL(manop_productiveitq.QTYSETUP, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091243) THEN ISNULL(manop_productiveitq.QTYLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091245) THEN ISNULL(manop_productiveitq.QTYRUN, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091247) THEN ISNULL(manop_productiveitq.QTYUNLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091239) THEN ISNULL(manop_productiveitq.QTYRESET, 0)
       END AS QTY,
       CASE
          WHEN (operationsegment.CLASSOID = 9000000000000091241) THEN ISNULL(manop_scrapitq.QTYSETUP, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091243) THEN ISNULL(manop_scrapitq.QTYLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091245) THEN ISNULL(manop_scrapitq.QTYRUN, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091247) THEN ISNULL(manop_scrapitq.QTYUNLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091239) THEN ISNULL(manop_scrapitq.QTYRESET, 0)
       END AS QTYREJECTED,
       CASE
          WHEN (operationsegment.CLASSOID = 9000000000000091241) THEN ISNULL(manop_reworkitq.QTYSETUP, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091243) THEN ISNULL(manop_reworkitq.QTYLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091245) THEN ISNULL(manop_reworkitq.QTYRUN, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091247) THEN ISNULL(manop_reworkitq.QTYUNLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091239) THEN ISNULL(manop_reworkitq.QTYRESET, 0)
       END AS QTYREWORKED,
       uom.SYMBOL UOM,
       manoperation.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONSEGMENT operationsegment WITH (NOLOCK),
     ((OBJT_MANOPERATION manoperation WITH (NOLOCK)
      LEFT OUTER JOIN OBJT_OPERATIONITEMQTYLINK manop_proditq_link WITH (NOLOCK) ON manop_proditq_link.OPERATIONOID = manoperation.OID AND manop_proditq_link.ITEMQTYCLASSNAME = 'objt.mes.bo.productionmgt.ProductiveItemQty')
        LEFT OUTER JOIN OBJT_PRODUCTIVEITEMQTY manop_productiveitq WITH (NOLOCK) ON manop_proditq_link.ITEMQTYOID = manop_productiveitq.OID)
          LEFT OUTER JOIN OBJT_SCRAPITEMQTY manop_scrapitq WITH (NOLOCK) ON manop_productiveitq.SCRAPITEMQTYOID = manop_scrapitq.OID
          LEFT OUTER JOIN OBJT_REWORKITEMQTY manop_reworkitq WITH (NOLOCK) ON manop_productiveitq.REWORKITEMQTYOID = manop_reworkitq.OID,
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT workcenter WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONLINK manop_segment_oplink WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link WITH (NOLOCK),
     OBJT_PRODUCTIVEITEMQTY machineop_productiveitq WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE manoperation.PROCESSUNITOID = workcenter.OID
AND manoperation.BOTYPE = 1 -- DIRECT
AND workcenter.CLASSOID = 9000000000000037041
AND manoperation.MACHINEOPERATIONOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND manoperation.OID = manop_segment_oplink.PARENTOID
AND operationsegment.OID = manop_segment_oplink.CHILDOID
AND operationsegment.STATUS IN (3,4,8) -- RUNNING, COMPLETE or HELD segments
AND operationsegment.CLASSOID IN (9000000000000091241,9000000000000091243,9000000000000091245,9000000000000091247,9000000000000091239)
AND machineoperation.OID = machineop_proditq_link.OPERATIONOID
AND machineop_proditq_link.ITEMQTYOID = machineop_productiveitq.OID
AND machineop_productiveitq.BOTYPE IN(0,5) -- PRIMARY (PHANTOM) OUTPUT
AND machineop_productiveitq.UOMOID = uom.OID
AND (manop_productiveitq.BOTYPE IS NULL OR manop_productiveitq.BOTYPE IN(0,5))
GO

-- PRODUCTIONOPERATION QTIES --
-- Displays all the INPUT/OUTPUT productionitemqties of the different productionoperations
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_PRODUCTIONOP_QTIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_PRODUCTIONOP_QTIES
GO

CREATE VIEW DCEREPORT_PRODUCTIONOP_QTIES
AS
SELECT productionitq.OID OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       productionitq.ITEMOID ITEM_OID,
       CASE WHEN (productionitq.BOTYPE = 0) THEN 'PRIMARY OUTPUT'
            WHEN (productionitq.BOTYPE = 1) THEN 'AUXILIARY OUTPUT'
            WHEN (productionitq.BOTYPE = 2) THEN 'INPUT'
            WHEN (productionitq.BOTYPE = 3) THEN 'ADDITIONAL INPUT'
            WHEN (productionitq.BOTYPE = 4) THEN 'TOOL'
            WHEN (productionitq.BOTYPE = 5) THEN 'PRIMARY PHANTOM OUTPUT' END AS TYPE,
       productionitq.QTYTARGET QTYPLANNED,
       productionitq.QTYFACTOR QTYFACTOR,
       productionitq.QTYUNIT QTYUNIT,
       productionitq.VALUE QTY,
       productionitq.QTYINCOMPLETE QTYINCOMPLETE,
       productionitq.QTYNRFT QTYNRFT,
       productionitq.QTYSCRAP QTYREJECT,
       productionitq.QTYREJECTED QTYREJECTED,
       productionitq.QTYREWORKED QTYREWORKED,
       productionitq.QTYREWORKABLE QTYREWORKABLE,
       uom.SYMBOL UOM,
       productionitq.DTSUPDATE DTSUPDATE
FROM OBJT_PRODUCTIONITEMQTY productionitq WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK prodop_proditq_link WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND productionoperation.OID = prodop_proditq_link.OPERATIONOID
AND prodop_proditq_link.ITEMQTYOID = productionitq.OID
AND productionitq.UOMOID = uom.OID
GO

-- MACHINEOPERATION QTIES --
-- Displays all the INPUT/OUTPUT shiftitemqties of the different machineoperations
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MACHINEOP_QTIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MACHINEOP_QTIES
GO

CREATE VIEW DCEREPORT_MACHINEOP_QTIES
AS
SELECT shiftitq.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       productionorder.ID PRODUCTIONORDER_ID,
       shiftitq.CALENDARSHIFTOID SHIFT_OID,
       shiftitq.ITEMOID ITEM_OID,
       CAST(CASE WHEN (shiftitq.BOTYPE = 0) THEN 'PRIMARY OUTPUT'
                 WHEN (shiftitq.BOTYPE = 1) THEN 'AUXILIARY OUTPUT'
                 WHEN (shiftitq.BOTYPE = 2) THEN 'INPUT'
                 WHEN (shiftitq.BOTYPE = 3) THEN 'ADDITIONAL INPUT'
                 WHEN (shiftitq.BOTYPE = 4) THEN 'TOOL'
                 WHEN (shiftitq.BOTYPE = 5) THEN 'PRIMARY PHANTOM OUTPUT' END AS VARCHAR(23)) AS TYPE,
       productiveitq.QTYTARGET QTYPLANNED,
       shiftitq.QTYFACTOR QTYFACTOR,
       shiftitq.QTYUNIT QTYUNIT,
       shiftitq.VALUE QTY,
       shiftitq.QTYINCOMPLETE QTYINCOMPLETE,
       shiftitq.QTYSETUP QTY_SETUP,
       shiftitq.QTYLOAD QTY_LOAD,
       shiftitq.QTYRUN QTY_RUN,
       shiftitq.QTYUNLOAD QTY_UNLOAD,
       shiftitq.QTYRESET QTY_RESET,
       shiftitq.QTYNRFT QTYNRFT,
       (scrapitq.VALUE - scrapitq.QTYREWORKED) QTYREJECT,
       scrapitq.VALUE QTYREJECTED,
       scrapitq.QTYSETUP QTYREJECTED_SETUP,
       scrapitq.QTYLOAD QTYREJECTED_LOAD,
       scrapitq.QTYRUN QTYREJECTED_RUN,
       scrapitq.QTYUNLOAD QTYREJECTED_UNLOAD,
       scrapitq.QTYRESET QTYREJECTED_RESET,
       shiftitq.QTYREWORKED QTYREWORKED,
       shiftitq.QTYREWORKABLE QTYREWORKABLE,
       uom.SYMBOL UOM,
       CAST(CASE WHEN (shiftitq.BOTYPE IN(2,3)) THEN
                      CASE WHEN (productiveitq.WIPTYPE = 0) THEN 'BACKFLUSH'
                          WHEN (productiveitq.WIPTYPE = 3) THEN 'DETAILED'
                 END
                 WHEN (shiftitq.BOTYPE IN(0,1,5)) THEN
                      CASE WHEN (productiveitq.WIPTYPE = 0) THEN 'NONE'
                          WHEN (productiveitq.WIPTYPE = 1) THEN 'BULK'
                          WHEN (productiveitq.WIPTYPE = 2) THEN 'CONTAINER'
                          WHEN (productiveitq.WIPTYPE = 5) THEN 'PACKAGING'
                 END
       END AS VARCHAR(10)) AS WIP_TYPE,
       shiftitq.DTSUPDATE DTSUPDATE
FROM OBJT_SHIFTITEMQTY shiftitq WITH (NOLOCK)
       LEFT OUTER JOIN OBJT_SCRAPITEMQTY scrapitq WITH (NOLOCK) ON shiftitq.SCRAPITEMQTYOID = scrapitq.OID,
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK machineop_shiftitq_link WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link WITH (NOLOCK),
     OBJT_PRODUCTIVEITEMQTY productiveitq WITH (NOLOCK),
     OBJT_ITEMQTYLINK productiveitq_shiftitq_link WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.OID = machineop_shiftitq_link.OPERATIONOID
AND machineop_shiftitq_link.ITEMQTYOID = shiftitq.OID
AND shiftitq.UOMOID = uom.OID
AND machineoperation.OID = machineop_proditq_link.OPERATIONOID
AND machineop_proditq_link.ITEMQTYOID = productiveitq.OID
AND productiveitq_shiftitq_link.PARENTOID = productiveitq.OID
AND productiveitq_shiftitq_link.CHILDOID = shiftitq.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1)  -- TYPE_MES_PRODUCTION/TYPE_MES_TEST
GO


-- DIRECT TASK QTIES --
-- Displays all the INPUT/OUTPUT shiftitemqties of the different direct tasks
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DIRECT_TASK_QTIES') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DIRECT_TASK_QTIES
GO

CREATE VIEW DCEREPORT_DIRECT_TASK_QTIES
AS
SELECT shiftitq.OID OID,
       manoperation.OID DIRECT_TASK_OID,
       workcenter.OID WORKCENTER_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       shiftitq.CALENDARSHIFTOID SHIFT_OID,
       shiftitq.ITEMOID ITEM_OID,
       CASE WHEN (shiftitq.BOTYPE = 0) THEN 'PRIMARY OUTPUT'
            WHEN (shiftitq.BOTYPE = 1) THEN 'AUXILIARY OUTPUT'
            WHEN (shiftitq.BOTYPE = 2) THEN 'INPUT'
            WHEN (shiftitq.BOTYPE = 3) THEN 'ADDITIONAL INPUT'
            WHEN (shiftitq.BOTYPE = 4) THEN 'TOOL'
            WHEN (shiftitq.BOTYPE = 5) THEN 'PRIMARY PHANTOM OUTPUT' END AS TYPE,
       productiveitq.QTYTARGET QTYPLANNED,
       shiftitq.QTYFACTOR QTYFACTOR,
       shiftitq.QTYUNIT QTYUNIT,
       shiftitq.VALUE QTY,
       shiftitq.QTYINCOMPLETE QTYINCOMPLETE,
       shiftitq.QTYSETUP QTY_SETUP,
       shiftitq.QTYLOAD QTY_LOAD,
       shiftitq.QTYRUN QTY_RUN,
       shiftitq.QTYUNLOAD QTY_UNLOAD,
       shiftitq.QTYRESET QTY_RESET,
       shiftitq.QTYNRFT QTYNRFT,
       (ISNULL(scrapitq.VALUE, 0) - ISNULL(scrapitq.QTYREWORKED, 0)) QTYREJECT,
       ISNULL(scrapitq.VALUE, 0) QTYREJECTED,
       ISNULL(scrapitq.QTYSETUP, 0) QTYREJECTED_SETUP,
       ISNULL(scrapitq.QTYLOAD, 0) QTYREJECTED_LOAD,
       ISNULL(scrapitq.QTYRUN, 0) QTYREJECTED_RUN,
       ISNULL(scrapitq.QTYUNLOAD, 0) QTYREJECTED_UNLOAD,
       ISNULL(scrapitq.QTYRESET, 0) QTYREJECTED_RESET,
       shiftitq.QTYREWORKED QTYREWORKED,
       shiftitq.QTYREWORKABLE QTYREWORKABLE,
       shiftitq.QTYDIRECTREWORK QTYDIRECTREWORK,
       shiftitq.QTYINDIRECTREWORK QTYINDIRECTREWORK,
       uom.SYMBOL UOM,
       shiftitq.DTSUPDATE DTSUPDATE
FROM OBJT_SHIFTITEMQTY shiftitq WITH (NOLOCK)
       LEFT OUTER JOIN OBJT_SCRAPITEMQTY scrapitq WITH (NOLOCK) ON shiftitq.SCRAPITEMQTYOID = scrapitq.OID,
     OBJT_MANOPERATION manoperation WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT workcenter WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK manop_shiftitq_link WITH (NOLOCK),
     OBJT_OPERATIONITEMQTYLINK manop_proditq_link WITH (NOLOCK),
     OBJT_PRODUCTIVEITEMQTY productiveitq WITH (NOLOCK),
     OBJT_ITEMQTYLINK productiveitq_shiftitq_link WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE manoperation.PROCESSUNITOID = workcenter.OID
AND workcenter.CLASSOID = 9000000000000037041
AND manoperation.MACHINEOPERATIONOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND manoperation.OID = manop_shiftitq_link.OPERATIONOID
AND manop_shiftitq_link.ITEMQTYOID = shiftitq.OID
AND shiftitq.UOMOID = uom.OID
AND manoperation.OID = manop_proditq_link.OPERATIONOID
AND manop_proditq_link.ITEMQTYOID = productiveitq.OID
AND productiveitq_shiftitq_link.PARENTOID = productiveitq.OID
AND productiveitq_shiftitq_link.CHILDOID = shiftitq.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
GO

-- SHIFTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHIFTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHIFTS
GO

CREATE VIEW DCEREPORT_SHIFTS
AS
SELECT calendarshift.OID OID,
       templateshift.NAME NAME,
       templateshift.DESCRIPTION DESCRIPTION,
       calendarshift.DTSSTART DTSSTART,
       calendarshift.DTSSTOP DTSSTOP,
       calendarshift.ISPRODUCTIVE ISPRODUCTIVE,
       dbo.MaxDate(calendarshift.DTSUPDATE, templateshift.DTSUPDATE) AS DTSUPDATE,
       calendarshift.DTSUPDATE AS DTSUPDATE_1,
       templateshift.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_CALENDARSHIFT calendarshift WITH (NOLOCK),
     OBJT_SHIFT shift WITH (NOLOCK),
     OBJT_SHIFT templateshift WITH (NOLOCK)
WHERE calendarshift.SHIFTOID = shift.OID
AND shift.TOID = templateshift.OID
GO

-- OEE OPERATION REPORTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_OEEOPERATIONREPORTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_OEEOPERATIONREPORTS
GO

CREATE VIEW DCEREPORT_OEEOPERATIONREPORTS
AS
SELECT oeeoperationreport.OID OID,
       oeeoperationreport.REPORTOID OEEREPORT_OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       calendarshift.NAME SHIFT_NAME,
       calendarshift.DESCRIPTION SHIFT_DESCRIPTION,
       calendarshift.ISPRODUCTIVE SHIFT_ISPRODUCTIVE,
       calendarshift.DTSSTART SHIFT_START,
       calendarshift.DTSSTOP SHIFT_STOP,
       oeeoperationreport.STATUS STATUS,
       oeeoperationreport.DTSSTART DTSSTART,
       oeeoperationreport.DTSSTOP DTSSTOP,
       oeeoperationreport.OEE OEE,
       oeeoperationreport.AVAILABILITY AVAILABILITY,
       oeeoperationreport.PRODUCTIVITY PRODUCTIVITY,
       oeeoperationreport.QUALITY QUALITY,
       oeeoperationreport.CAPACITY CAPACITY,
       oeeoperationreport.FTR FTR,
       oeeoperationreport.OEETARGET OEETARGET,
       oeeoperationreport.AVAILABILITYTARGET AVAILABILITYTARGET,
       oeeoperationreport.PRODUCTIVITYTARGET PRODUCTIVITYTARGET,
       oeeoperationreport.QUALITYTARGET QUALITYTARGET,
       oeeoperationreport.CAPACITYTARGET CAPACITYTARGET,
       oeeoperationreport.DURATION DURATION_TOTAL,
       oeeoperationreport.DURATIONOEE1 DURATION_UNAVAILABLE_OEE1,
       oeeoperationreport.DURATIONOEE1A NO_PLANNING_OEE1A,
       oeeoperationreport.DURATIONOEE1B PLANNED_INTERRUPTS_OEE1B,
       oeeoperationreport.DURATIONPLANNED DURATION_PLANNED,
       oeeoperationreport.DURATIONOEE2 AVAILABILITY_LOSSES_OEE2,
       oeeoperationreport.DURATIONOEE2A SETUPS_OEE2A,
       oeeoperationreport.DURATIONOEE2B BREAKDOWNS_OEE2B,
       oeeoperationreport.DURATIONOPERATIONAL DURATION_OPERATIONAL,
       oeeoperationreport.DURATIONOEE3 PRODUCTIVITY_LOSSES_OEE3,
       oeeoperationreport.DURATIONOEE3A SPEED_LOSSES_OEE3A,
       oeeoperationreport.DURATIONOEE3B MICROSTOPS_OEE3B,
       oeeoperationreport.DURATIONNETOPERATIONAL DURATION_NET_OPERATIONAL,
       oeeoperationreport.DURATIONOEE4 QUALITY_LOSSES_OEE4,
       oeeoperationreport.QTYPRODUCED QTY,
       oeeoperationreport.QTYINCOMPLETE QTYINCOMPLETE,
       oeeoperationreport.QTYNRFT QTYNRFT,
       oeeoperationreport.QTYSCRAP QTYREJECT,
       oeeoperationreport.QTYREJECTED QTYREJECTED,
       oeeoperationreport.QTYREWORKED QTYREWORKED,
       oeeoperationreport.DURATIONEFFOPERATIONAL DURATION_EFF_OPERATIONAL,
       oeeoperationreport.AVERAGERESOURCEALLOCATION AVERAGE_RESOURCE_ALLOCATION,
       oeeoperationreport.TOTALLABOURDURATION TOTAL_LABOUR_DURATION,
       oeeoperationreport.TOTALPRODUCTIVELABOURDURATION PRODUCTIVE_LABOUR_DURATION,
       CAST(CASE WHEN (oeeoperationreport.REPORTOPTION & 3 = 0) THEN CAST(oeeoperationreport.TARGETOUTPUTDURATION AS VARCHAR) + ' ' + durationuom.SYMBOL + ' / cycle' -- cycletime
                 WHEN (oeeoperationreport.REPORTOPTION & 3 = 1) THEN CAST(oeeoperationreport.TARGETOUTPUTQTY AS VARCHAR) + ' ' + uom.SYMBOL + ' / ' + CASE WHEN (oeeoperationreport.TARGETOUTPUTDURATION <> 1) THEN CAST(oeeoperationreport.TARGETOUTPUTDURATION AS VARCHAR) + ' ' ELSE '' END + durationuom.SYMBOL -- speed
                  WHEN (oeeoperationreport.REPORTOPTION & 3 = 2) THEN CAST(oeeoperationreport.TARGETOUTPUTQTY AS VARCHAR) + ' ' + uom.SYMBOL + ' / ' +  CAST(ROUND(oeeoperationreport.TARGETOUTPUTDURATION / 1000 / 3600, 0) AS VARCHAR) + ':' + RIGHT('0' + CAST(ROUND((CAST((oeeoperationreport.TARGETOUTPUTDURATION / 1000) AS INT) % 3600) / 60, 2) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(ROUND((CAST((oeeoperationreport.TARGETOUTPUTDURATION / 1000) AS INT) % 60), 2) AS VARCHAR), 2)-- duration
                 WHEN (oeeoperationreport.REPORTOPTION & 3 = 3) THEN CAST(oeeoperationreport.TARGETOUTPUTDURATION AS VARCHAR) + ' ' + durationuom.SYMBOL + ' / ' + CAST(oeeoperationreport.TARGETOUTPUTQTY AS VARCHAR) + ' ' + uom.SYMBOL -- rate
            END AS VARCHAR(255)) AS TARGET_SPEED,
       CAST(CASE WHEN (oeeoperationreport.REPORTOPTION & 3 = 0) THEN CAST(oeeoperationreport.ACTUALOUTPUTDURATION AS VARCHAR) + ' ' + durationuom.SYMBOL + ' / cycle' -- cycletime
                 WHEN (oeeoperationreport.REPORTOPTION & 3 = 1) THEN CAST(oeeoperationreport.ACTUALOUTPUTQTY AS VARCHAR) + ' ' + uom.SYMBOL + ' / ' + CASE WHEN (oeeoperationreport.ACTUALOUTPUTDURATION <> 1) THEN CAST(oeeoperationreport.ACTUALOUTPUTDURATION AS VARCHAR) + ' ' ELSE '' END + durationuom.SYMBOL -- speed
                  WHEN (oeeoperationreport.REPORTOPTION & 3 = 2) THEN CAST(oeeoperationreport.ACTUALOUTPUTQTY AS VARCHAR) + ' ' + uom.SYMBOL + ' / ' + CAST(ROUND(oeeoperationreport.ACTUALOUTPUTDURATION / 1000 / 3600, 0) AS VARCHAR)  + ':' +  RIGHT('0' + CAST(ROUND((CAST((oeeoperationreport.ACTUALOUTPUTDURATION / 1000) AS INT) % 3600) / 60, 2) AS VARCHAR), 2) + ':' + RIGHT('0' + CAST(ROUND((CAST((oeeoperationreport.ACTUALOUTPUTDURATION / 1000) AS INT) % 60), 2) AS VARCHAR), 2) -- duration
                 WHEN (oeeoperationreport.REPORTOPTION & 3 = 3) THEN CAST(oeeoperationreport.ACTUALOUTPUTDURATION AS VARCHAR) + ' ' + durationuom.SYMBOL + ' / ' + CAST(oeeoperationreport.ACTUALOUTPUTQTY AS VARCHAR) + ' ' + uom.SYMBOL -- rate
            END AS VARCHAR(255)) AS ACTUAL_SPEED,
       oeeoperationreport.DTSUPDATE DTSUPDATE
FROM OBJT_OEEOPERATIONREPORT oeeoperationreport WITH (NOLOCK)
     LEFT OUTER JOIN OBJT_UOM uom ON oeeoperationreport.UOMOID = uom.OID
     LEFT OUTER JOIN OBJT_UOM durationuom ON oeeoperationreport.OUTPUTDURATIONUOMOID = durationuom.OID,
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_CALENDARSHIFT calendarshift WITH (NOLOCK)
WHERE oeeoperationreport.OWNEROID = machineoperation.OID
AND oeeoperationreport.CALENDARSHIFTOID = calendarshift.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
GO

-- OEE REPORTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_OEEREPORTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_OEEREPORTS
GO

CREATE VIEW DCEREPORT_OEEREPORTS
AS
SELECT oeereport.OID OID,
       oeereport.OWNEROID PROCESSRESOURCE_OID,
       calendarshift.NAME SHIFT_NAME,
       calendarshift.DESCRIPTION SHIFT_DESCRIPTION,
       calendarshift.ISPRODUCTIVE SHIFT_ISPRODUCTIVE,
       calendarshift.DTSSTART SHIFT_START,
       calendarshift.DTSSTOP SHIFT_STOP,
       oeereport.DTSSTART DTSSTART,
       oeereport.DTSSTOP DTSSTOP,
       oeereport.STATUS STATUS,
       oeereport.OEE OEE,
       oeereport.AVAILABILITY AVAILABILITY,
       oeereport.PRODUCTIVITY PRODUCTIVITY,
       oeereport.QUALITY QUALITY,
       oeereport.CAPACITY CAPACITY,
       oeereport.FTR FTR,
       oeereport.OEETARGET OEETARGET,
       oeereport.AVAILABILITYTARGET AVAILABILITYTARGET,
       oeereport.PRODUCTIVITYTARGET PRODUCTIVITYTARGET,
       oeereport.QUALITYTARGET QUALITYTARGET,
       oeereport.CAPACITYTARGET CAPACITYTARGET,
       oeereport.DURATION DURATION_TOTAL,
       oeereport.DURATIONOEE1 DURATION_UNAVAILABLE_OEE1,
       oeereport.DURATIONOEE1A NO_PLANNING_OEE1A,
       oeereport.DURATIONOEE1B PLANNED_INTERRUPTS_OEE1B,
       oeereport.DURATIONPLANNED DURATION_PLANNED,
       oeereport.DURATIONOEE2 AVAILABILITY_LOSSES_OEE2,
       oeereport.DURATIONOEE2A SETUPS_OEE2A,
       oeereport.DURATIONOEE2B BREAKDOWNS_OEE2B,
       oeereport.DURATIONOPERATIONAL DURATION_OPERATIONAL,
       oeereport.DURATIONOEE3 PRODUCTIVITY_LOSSES_OEE3,
       oeereport.DURATIONOEE3A SPEED_LOSSES_OEE3A,
       oeereport.DURATIONOEE3B MICROSTOPS_OEE3B,
       oeereport.DURATIONNETOPERATIONAL DURATION_NET_OPERATIONAL,
       oeereport.DURATIONOEE4 QUALITY_LOSSES_OEE4,
       oeereport.DURATIONEFFOPERATIONAL DURATION_EFF_OPERATIONAL,
       oeereport.AVERAGERESOURCEALLOCATION AVERAGE_RESOURCE_ALLOCATION,
       oeereport.TOTALLABOURDURATION TOTAL_LABOUR_DURATION,
       oeereport.TOTALPRODUCTIVELABOURDURATION PRODUCTIVE_LABOUR_DURATION,
       oeereport.QTYPRODUCED QTYPRODUCED,
       oeereport.QTYINCOMPLETE QTYINCOMPLETE,
       oeereport.QTYNRFT QTYNRFT,
       oeereport.QTYSCRAP QTYREJECT,
       oeereport.QTYREJECTED QTYREJECTED,
       oeereport.QTYREWORKED QTYREWORKED,
       uom.SYMBOL UOM,
       oeereport.DTSUPDATE DTSUPDATE
FROM OBJT_OEEREPORT oeereport WITH (NOLOCK),
     OBJT_CALENDARSHIFT calendarshift WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE oeereport.CALENDARSHIFTOID = calendarshift.OID
AND oeereport.UOMOID = uom.OID
GO

-- PRODUCTIONORDERS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_PRODUCTIONORDERS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_PRODUCTIONORDERS
GO

CREATE VIEW DCEREPORT_PRODUCTIONORDERS
AS
SELECT productionorder.OID OID,
       productionorder.NAME NAME,
       productionorder.ID ID,
       productionorder.DESCRIPTION DESCRIPTION,
       productionorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       productionorder.DTSPLANNEDSTOP DTSPLANNEDSTOP,
       productionorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       productionorder.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       productionorder.DTSSTART DTSSTART,
       productionorder.DTSSTOP DTSSTOP,
       productionorder.STATUS STATUS,
       productionorder.DTSDUEBEFORE DTSDUEBEFORE,
       productionorder.USRDTS1 USRDTS1,
       productionorder.USRDTS2 USRDTS2,
       productionorder.USRDTS3 USRDTS3,
       productionorder.USRDTS4 USRDTS4,
       productionorder.USRDTS5 USRDTS5,
       productionorder.USRDTS6 USRDTS6,
       productionorder.USRDTS7 USRDTS7,
       productionorder.USRDTS8 USRDTS8,
       productionorder.USRDTS9 USRDTS9,
       productionorder.USRDTS10 USRDTS10,
       productionorder.USRDTS11 USRDTS11,
       productionorder.USRDTS12 USRDTS12,
       productionorder.USRDTS13 USRDTS13,
       productionorder.USRDTS14 USRDTS14,
       productionorder.USRDTS15 USRDTS15,
       productionorder.USRDTS16 USRDTS16,
       productionorder.USRDTS17 USRDTS17,
       productionorder.USRDTS18 USRDTS18,
       productionorder.USRDTS19 USRDTS19,
       productionorder.USRDTS20 USRDTS20,
       productionorder.USRDTS21 USRDTS21,
       productionorder.USRDTS22 USRDTS22,
       productionorder.USRDTS23 USRDTS23,
       productionorder.USRDTS24 USRDTS24,
       productionorder.USRDTS25 USRDTS25,
       productionorder.USRDTS26 USRDTS26,
       productionorder.USRDTS27 USRDTS27,
       productionorder.USRDTS28 USRDTS28,
       productionorder.USRDTS29 USRDTS29,
       productionorder.USRDTS30 USRDTS30,
       productionorder.USRFLG1 USRFLG1,
       productionorder.USRFLG2 USRFLG2,
       productionorder.USRFLG3 USRFLG3,
       productionorder.USRFLG4 USRFLG4,
       productionorder.USRFLG5 USRFLG5,
       productionorder.USRFLG6 USRFLG6,
       productionorder.USRFLG7 USRFLG7,
       productionorder.USRFLG8 USRFLG8,
       productionorder.USRFLG9 USRFLG9,
       productionorder.USRFLG10 USRFLG10,
       productionorder.USRFLG11 USRFLG11,
       productionorder.USRFLG12 USRFLG12,
       productionorder.USRFLG13 USRFLG13,
       productionorder.USRFLG14 USRFLG14,
       productionorder.USRFLG15 USRFLG15,
       productionorder.USRFLG16 USRFLG16,
       productionorder.USRFLG17 USRFLG17,
       productionorder.USRFLG18 USRFLG18,
       productionorder.USRFLG19 USRFLG19,
       productionorder.USRFLG20 USRFLG20,
       productionorder.USRFLG21 USRFLG21,
       productionorder.USRFLG22 USRFLG22,
       productionorder.USRFLG23 USRFLG23,
       productionorder.USRFLG24 USRFLG24,
       productionorder.USRFLG25 USRFLG25,
       productionorder.USRFLG26 USRFLG26,
       productionorder.USRFLG27 USRFLG27,
       productionorder.USRFLG28 USRFLG28,
       productionorder.USRFLG29 USRFLG29,
       productionorder.USRFLG30 USRFLG30,
       productionorder.USRNUM1 USRNUM1,
       productionorder.USRNUM2 USRNUM2,
       productionorder.USRNUM3 USRNUM3,
       productionorder.USRNUM4 USRNUM4,
       productionorder.USRNUM5 USRNUM5,
       productionorder.USRNUM6 USRNUM6,
       productionorder.USRNUM7 USRNUM7,
       productionorder.USRNUM8 USRNUM8,
       productionorder.USRNUM9 USRNUM9,
       productionorder.USRNUM10 USRNUM10,
       productionorder.USRNUM11 USRNUM11,
       productionorder.USRNUM12 USRNUM12,
       productionorder.USRNUM13 USRNUM13,
       productionorder.USRNUM14 USRNUM14,
       productionorder.USRNUM15 USRNUM15,
       productionorder.USRNUM16 USRNUM16,
       productionorder.USRNUM17 USRNUM17,
       productionorder.USRNUM18 USRNUM18,
       productionorder.USRNUM19 USRNUM19,
       productionorder.USRNUM20 USRNUM20,
       productionorder.USRNUM21 USRNUM21,
       productionorder.USRNUM22 USRNUM22,
       productionorder.USRNUM23 USRNUM23,
       productionorder.USRNUM24 USRNUM24,
       productionorder.USRNUM25 USRNUM25,
       productionorder.USRNUM26 USRNUM26,
       productionorder.USRNUM27 USRNUM27,
       productionorder.USRNUM28 USRNUM28,
       productionorder.USRNUM29 USRNUM29,
       productionorder.USRNUM30 USRNUM30,
       productionorder.USRNUM31 USRNUM31,
       productionorder.USRNUM32 USRNUM32,
       productionorder.USRNUM33 USRNUM33,
       productionorder.USRNUM34 USRNUM34,
       productionorder.USRNUM35 USRNUM35,
       productionorder.USRNUM36 USRNUM36,
       productionorder.USRNUM37 USRNUM37,
       productionorder.USRNUM38 USRNUM38,
       productionorder.USRNUM39 USRNUM39,
       productionorder.USRNUM40 USRNUM40,
       productionorder.USRNUM41 USRNUM41,
       productionorder.USRNUM42 USRNUM42,
       productionorder.USRNUM43 USRNUM43,
       productionorder.USRNUM44 USRNUM44,
       productionorder.USRNUM45 USRNUM45,
       productionorder.USRNUM46 USRNUM46,
       productionorder.USRNUM47 USRNUM47,
       productionorder.USRNUM48 USRNUM48,
       productionorder.USRNUM49 USRNUM49,
       productionorder.USRNUM50 USRNUM50,
       productionorder.USRNUM51 USRNUM51,
       productionorder.USRNUM52 USRNUM52,
       productionorder.USRNUM53 USRNUM53,
       productionorder.USRNUM54 USRNUM54,
       productionorder.USRNUM55 USRNUM55,
       productionorder.USRNUM56 USRNUM56,
       productionorder.USRNUM57 USRNUM57,
       productionorder.USRNUM58 USRNUM58,
       productionorder.USRNUM59 USRNUM59,
       productionorder.USRNUM60 USRNUM60,
       productionorder.USRNUM61 USRNUM61,
       productionorder.USRNUM62 USRNUM62,
       productionorder.USRNUM63 USRNUM63,
       productionorder.USRNUM64 USRNUM64,
       productionorder.USRNUM65 USRNUM65,
       productionorder.USRTXT1 USRTXT1,
       productionorder.USRTXT2 USRTXT2,
       productionorder.USRTXT3 USRTXT3,
       productionorder.USRTXT4 USRTXT4,
       productionorder.USRTXT5 USRTXT5,
       productionorder.USRTXT6 USRTXT6,
       productionorder.USRTXT7 USRTXT7,
       productionorder.USRTXT8 USRTXT8,
       productionorder.USRTXT9 USRTXT9,
       productionorder.USRTXT10 USRTXT10,
       productionorder.USRTXT11 USRTXT11,
       productionorder.USRTXT12 USRTXT12,
       productionorder.USRTXT13 USRTXT13,
       productionorder.USRTXT14 USRTXT14,
       productionorder.USRTXT15 USRTXT15,
       productionorder.USRTXT16 USRTXT16,
       productionorder.USRTXT17 USRTXT17,
       productionorder.USRTXT18 USRTXT18,
       productionorder.USRTXT19 USRTXT19,
       productionorder.USRTXT20 USRTXT20,
       productionorder.USRTXT21 USRTXT21,
       productionorder.USRTXT22 USRTXT22,
       productionorder.USRTXT23 USRTXT23,
       productionorder.USRTXT24 USRTXT24,
       productionorder.USRTXT25 USRTXT25,
       productionorder.USRTXT26 USRTXT26,
       productionorder.USRTXT27 USRTXT27,
       productionorder.USRTXT28 USRTXT28,
       productionorder.USRTXT29 USRTXT29,
       productionorder.USRTXT30 USRTXT30,
       productionorder.USRTXT31 USRTXT31,
       productionorder.USRTXT32 USRTXT32,
       productionorder.USRTXT33 USRTXT33,
       productionorder.USRTXT34 USRTXT34,
       productionorder.USRTXT35 USRTXT35,
       productionorder.USRTXT36 USRTXT36,
       productionorder.USRTXT37 USRTXT37,
       productionorder.USRTXT38 USRTXT38,
       productionorder.USRTXT39 USRTXT39,
       productionorder.USRTXT40 USRTXT40,
       productionorder.USRTXT41 USRTXT41,
       productionorder.USRTXT42 USRTXT42,
       productionorder.USRTXT43 USRTXT43,
       productionorder.USRTXT44 USRTXT44,
       productionorder.USRTXT45 USRTXT45,
       productionorder.USRTXT46 USRTXT46,
       productionorder.USRTXT47 USRTXT47,
       productionorder.USRTXT48 USRTXT48,
       productionorder.USRTXT49 USRTXT49,
       productionorder.USRTXT50 USRTXT50,
       productionorder.USRTXT51 USRTXT51,
       productionorder.USRTXT52 USRTXT52,
       productionorder.USRTXT53 USRTXT53,
       productionorder.USRTXT54 USRTXT54,
       productionorder.USRTXT55 USRTXT55,
       productionorder.USRTXT56 USRTXT56,
       productionorder.USRTXT57 USRTXT57,
       productionorder.USRTXT58 USRTXT58,
       productionorder.USRTXT59 USRTXT59,
       productionorder.USRTXT60 USRTXT60,
       productionorder.USRTXT61 USRTXT61,
       productionorder.USRTXT62 USRTXT62,
       productionorder.USRTXT63 USRTXT63,
       productionorder.USRTXT64 USRTXT64,
       productionorder.USRTXT65 USRTXT65,
       productionitemqty.ITEMOID ITEM_OID,
       (SELECT TOP 1 customer.OID FROM OBJT_CUSTOMER customer WITH (NOLOCK), OBJT_ORDERRESOURCELINK productionorder_customerlink WITH (NOLOCK)
                                  WHERE productionorder_customerlink.RESOURCEOID = customer.OID
                                  AND productionorder_customerlink.ORDEROID = productionorder.OID) AS CUSTOMER_OID,
       recipevariantversion.OID RECIPE_OID,
       recipe.NAME RECIPE_NAME,
       recipevariant.NAME RECIPE_VARIANT,
       versioninfo.VID RECIPE_VERSION,
       productionitemqty.QTYTARGET QTYPLANNED,
       CASE WHEN (productionitemqty.VALUE IS NULL) THEN NULL
            WHEN (productionitemqty.QTYSCRAP IS NULL) THEN productionitemqty.VALUE
            WHEN (productionitemqty.VALUE - productionitemqty.QTYSCRAP < 0) THEN 0
            ELSE productionitemqty.VALUE - productionitemqty.QTYSCRAP END AS QTYYIELD,
       uom.SYMBOL UOM,
       productionorder.DTSUPDATE DTSUPDATE
FROM OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_RECIPEVARIANTVERSION recipevariantversion WITH (NOLOCK),
     OBJT_RECIPEVARIANT recipevariant WITH (NOLOCK),
     OBJT_RECIPE recipe WITH (NOLOCK),
     OBJT_VERSIONINFO versioninfo WITH (NOLOCK),
     OBJT_PRODUCTIONITEMQTY productionitemqty WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND productionorder.RECIPEOID = recipevariantversion.OID
AND recipevariantversion.RECIPEOID = recipevariant.OID
AND recipevariant.RECIPEOID = recipe.OID
AND recipevariantversion.VERSIONINFOOID = versioninfo.OID
AND productionitemqty.ORDEROID = productionorder.OID
AND productionitemqty.UOMOID = uom.OID
GO

-- MES_EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MES_EVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MES_EVENTS
GO

CREATE VIEW DCEREPORT_MES_EVENTS
AS
SELECT event.OID OID,
       event.TYPE TYPE,
       event.DTS DTS,
       event.CATEGORY CATEGORY,
       event.DESCRIPTION DESCRIPTION,
       event.VALUE VALUE,
       event.PREVIOUSVALUE PREVIOUS_VALUE,
       event.EMPLOYEEOID EMPLOYEE_OID,
       event.DEVICEOID DEVICE_OID,
       event.ORDEROID PRODUCTIONORDER_OID,
       event.OPERATIONOID PRODUCTIONOPERATION_OID,
       event.RESOURCEOID PROCESSRESOURCE_OID,
       event.ITEMOID ITEM_OID,
       event.DTSUPDATE DTSUPDATE
FROM OBJT_EVENT event WITH (NOLOCK)
WHERE event.CLASSOID = 9000000000000091563
UNION ALL
SELECT event.OID OID,
       event.TYPE TYPE,
       event.DTS DTS,
       event.CATEGORY CATEGORY,
       event.DESCRIPTION DESCRIPTION,
       event.VALUE VALUE,
       event.PREVIOUSVALUE PREVIOUS_VALUE,
       event.EMPLOYEEOID EMPLOYEE_OID,
       event.DEVICEOID DEVICE_OID,
       event.ORDEROID PRODUCTIONORDER_OID,
       event.OPERATIONOID PRODUCTIONOPERATION_OID,
       event.RESOURCEOID PROCESSRESOURCE_OID,
       event.ITEMOID ITEM_OID,
       event.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT event WITH (NOLOCK)
WHERE event.CLASSOID IN (9000000000000091647,9000000000000091625,9000000000000091653,9000000000000091659,9000000000000091662)
-- (MeasurementEvent,OperationInstructionEvent,CheckEvent,InputEvent,ProcessEvent)
GO

-- DOCUMENTED INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DOCUMENTEDINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DOCUMENTEDINSTR
GO

CREATE VIEW DCEREPORT_DOCUMENTEDINSTR
AS
SELECT runtimedocumentedinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimedocumentedinstruction.NAME NAME,
       runtimedocumentedinstruction.DESCRIPTION DESCRIPTION,
       runtimedocumentedinstruction.ID ID,
       documentedinstruction.INFOTEXT INFO,
       runtimedocumentedinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimedocumentedinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION documentedinstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimedocumentedinstruction.CLASSOID = 9000000000000089962
AND runtimedocumentedinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimedocumentedinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimedocumentedinstruction.OPERATIONINSTRUCTIONOID = documentedinstruction.OID
AND documentedinstruction.CLASSOID = 9000000000000090054
UNION ALL
SELECT runtimedocumentedinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimedocumentedinstruction.NAME NAME,
       runtimedocumentedinstruction.DESCRIPTION DESCRIPTION,
       runtimedocumentedinstruction.ID ID,
       documentedinstruction.INFOTEXT INFO,
       runtimedocumentedinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimedocumentedinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION documentedinstruction WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimedocumentedinstruction.CLASSOID = 9000000000000089962
AND runtimedocumentedinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND runtimedocumentedinstruction.OPERATIONINSTRUCTIONOID = documentedinstruction.OID
AND documentedinstruction.CLASSOID = 9000000000000090054
GO

-- INSTRUCTION DOCUMENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INSTRUCTIONDOCS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INSTRUCTIONDOCS
GO

CREATE VIEW DCEREPORT_INSTRUCTIONDOCS
AS
SELECT document.OID OID,
       ISNULL(runtimeoperationinstruction.OID, operationinstruction.OID) AS INSTRUCTION_OID,
       document.NAME NAME,
       document.DESCRIPTION DESCRIPTION,
       CASE WHEN (document.BOTYPE = 0) THEN 'URL'
            WHEN (document.BOTYPE = 1) THEN 'RESOURCE'
            WHEN (document.BOTYPE = 2) THEN 'FILE'
            WHEN (document.BOTYPE = 3) THEN 'REPOSITORY'
            WHEN (document.BOTYPE = 4) THEN 'TEXT' END AS TYPE,
       document.FILENAME REFERENCE,
       document.TEXT TEXT,
       document.DTSUPDATE DTSUPDATE
FROM OBJT_DOCUMENT document WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION operationinstruction WITH (NOLOCK)
     LEFT JOIN OBJT_RUNTIMEOPERATIONINSTRUCT runtimeoperationinstruction WITH (NOLOCK)
        ON (operationinstruction.OID = runtimeoperationinstruction.OPERATIONINSTRUCTIONOID
            AND runtimeoperationinstruction.CLASSOID IN (9000000000000089962, 9000000000000089972, 9000000000000089964, 9000000000000089954, 9000000000000089958)),
     OBJT_MANUFACTURINGOPERATION manufacturingoperation WITH (NOLOCK)
WHERE document.OWNEROID = operationinstruction.OID
AND (operationinstruction.CLASSOID = 9000000000000090054
     OR (operationinstruction.CLASSOID IN (9000000000000090054, 9000000000000090127, 9000000000000090112, 9000000000000090097, 9000000000000090107))
         AND runtimeoperationinstruction.OID IS NOT NULL)
AND operationinstruction.OPERATIONOID = manufacturingoperation.OID
AND manufacturingoperation.STATUS = 2 -- SCHEDULED
UNION ALL
SELECT document.OID OID,
       runtimeoperationinstruction.OID AS INSTRUCTION_OID,
       document.NAME NAME,
       document.DESCRIPTION DESCRIPTION,
       CASE WHEN (document.BOTYPE = 0) THEN 'URL'
            WHEN (document.BOTYPE = 1) THEN 'RESOURCE'
            WHEN (document.BOTYPE = 2) THEN 'FILE'
            WHEN (document.BOTYPE = 3) THEN 'REPOSITORY'
            WHEN (document.BOTYPE = 4) THEN 'TEXT' END AS TYPE,
       document.FILENAME REFERENCE,
       document.TEXT TEXT,
       document.DTSUPDATE DTSUPDATE
FROM OBJT_DOCUMENT document WITH (NOLOCK),
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeoperationinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION operationinstruction WITH (NOLOCK)
     LEFT JOIN OBJT_MANUFACTURINGOPERATION manufacturingoperation WITH (NOLOCK)
        ON (operationinstruction.OPERATIONOID = manufacturingoperation.OID)
WHERE document.OWNEROID = runtimeoperationinstruction.OID
AND runtimeoperationinstruction.CLASSOID IN (9000000000000089962, 9000000000000089972, 9000000000000089964, 9000000000000089954, 9000000000000089958)
AND runtimeoperationinstruction.OPERATIONINSTRUCTIONOID = operationinstruction.OID
AND operationinstruction.CLASSOID IN (9000000000000090054, 9000000000000090127, 9000000000000090112, 9000000000000090097, 9000000000000090107)
AND (manufacturingoperation.OID IS NULL OR manufacturingoperation.STATUS <> 2) -- NOT SCHEDULED

GO

-- DOCUMENT EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DOCUMENTEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DOCUMENTEVENTS
GO

CREATE VIEW DCEREPORT_DOCUMENTEVENTS
AS
SELECT documentevent.OID OID,
       documentevent.OPERATIONINSTRUCTIONOID INSTRUCTION_OID,
       document.OID DOCUMENT_OID,
       documentevent.EMPLOYEEOID EMPLOYEE_OID,
       documentevent.DEVICEOID DEVICE_OID,
       documentevent.CATEGORY CATEGORY,
       documentevent.DTS DTS,
       documentevent.COMMENTS COMMENTS,
       documentevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       documentevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT documentevent WITH (NOLOCK),
     OBJT_DOCUMENT document WITH (NOLOCK)
WHERE documentevent.CLASSOID = 9000000000000091650
AND documentevent.REFOID = document.OID
GO

-- PROCESS SETUP INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SETUPINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SETUPINSTR
GO

CREATE VIEW DCEREPORT_SETUPINSTR
AS
SELECT runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimeprocessinstruction.NAME NAME,
       runtimeprocessinstruction.DESCRIPTION DESCRIPTION,
       runtimeprocessinstruction.ID ID,
       setupparameter.OID SETUPPARAMETER_OID,
       'NUMERIC' SETUPPARAMETER_TYPE,
       setupparameter.NAME SETUPPARAMETER_NAME,
       setupparameter.DESCRIPTION SETUPPARAMETER_DESCRIPTION,
       '' STANDARDTEXTVALUE,
       '' TEXTVALUE,
       setupparameter.QTYSTANDARD QTYSTANDARD,
       setupparameter.QTYTARGET QTYTARGET,
       CAST(CASE WHEN (setupparameter.EDITMODE & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS TARGETEDITABLE,
       setupparameter.QTYHIGH UPPER_SETUP_LIMIT,
       setupparameter.QTYLOW LOWER_SETUP_LIMIT,
       uom.symbol UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_PROCESSPARAMETER setupparameter WITH (NOLOCK)
        LEFT OUTER JOIN OBJT_UOM uom WITH (NOLOCK) ON setupparameter.UOMOID = uom.OID
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND setupparameter.CLASSOID = 9000000000000093109
AND runtimeprocessinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 0 -- SETUP
AND runtimeprocessinstruction.OID = setupparameter.OWNEROID
UNION ALL
SELECT runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimeprocessinstruction.NAME NAME,
       runtimeprocessinstruction.DESCRIPTION DESCRIPTION,
       runtimeprocessinstruction.ID ID,
       setupparameter.OID SETUPPARAMETER_OID,
       'NUMERIC' SETUPPARAMETER_TYPE,
       setupparameter.NAME SETUPPARAMETER_NAME,
       setupparameter.DESCRIPTION SETUPPARAMETER_DESCRIPTION,
       '' STANDARDTEXTVALUE,
       '' TEXTVALUE,
       setupparameter.QTYSTANDARD QTYSTANDARD,
       setupparameter.QTYTARGET QTYTARGET,
       CAST(CASE WHEN (setupparameter.EDITMODE & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS TARGETEDITABLE,
       setupparameter.QTYHIGH UPPER_SETUP_LIMIT,
       setupparameter.QTYLOW LOWER_SETUP_LIMIT,
       uom.symbol UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_PROCESSPARAMETER setupparameter WITH (NOLOCK)
        LEFT OUTER JOIN OBJT_UOM uom WITH (NOLOCK) ON setupparameter.UOMOID = uom.OID
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND setupparameter.CLASSOID = 9000000000000093109
AND runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 0 -- SETUP
AND runtimeprocessinstruction.OID = setupparameter.OWNEROID
UNION ALL
SELECT runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimeprocessinstruction.NAME NAME,
       runtimeprocessinstruction.DESCRIPTION DESCRIPTION,
       runtimeprocessinstruction.ID ID,
       setupparameter.OID SETUPPARAMETER_OID,
       'TEXT' SETUPPARAMETER_TYPE,
       setupparameter.NAME SETUPPARAMETER_NAME,
       setupparameter.DESCRIPTION SETUPPARAMETER_DESCRIPTION,
       setupparameter.STANDARDTEXTVALUE STANDARDTEXTVALUE,
       setupparameter.TEXTVALUE TEXTVALUE,
       NULL QTYSTANDARD,
       NULL QTYTARGET,
       CAST(CASE WHEN (setupparameter.EDITMODE & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS TARGETEDITABLE,
       NULL UPPER_SETUP_LIMIT,
       NULL LOWER_SETUP_LIMIT,
       '' UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_PROCESSPARAMETER setupparameter WITH (NOLOCK)
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND setupparameter.CLASSOID = 9000000000000093126 -- TextParameter --
AND runtimeprocessinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 0 -- SETUP
AND runtimeprocessinstruction.OID = setupparameter.OWNEROID
UNION ALL
SELECT runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimeprocessinstruction.NAME NAME,
       runtimeprocessinstruction.DESCRIPTION DESCRIPTION,
       runtimeprocessinstruction.ID ID,
       setupparameter.OID SETUPPARAMETER_OID,
       'TEXT' SETUPPARAMETER_TYPE,
       setupparameter.NAME SETUPPARAMETER_NAME,
       setupparameter.DESCRIPTION SETUPPARAMETER_DESCRIPTION,
       setupparameter.STANDARDTEXTVALUE STANDARDTEXTVALUE,
       setupparameter.TEXTVALUE TEXTVALUE,
       NULL QTYSTANDARD,
       NULL QTYTARGET,
       CAST(CASE WHEN (setupparameter.EDITMODE & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS TARGETEDITABLE,
       NULL UPPER_SETUP_LIMIT,
       NULL LOWER_SETUP_LIMIT,
       '' UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_PROCESSPARAMETER setupparameter WITH (NOLOCK)
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND setupparameter.CLASSOID = 9000000000000093126 -- TextParameter --
AND runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 0 -- SETUP
AND runtimeprocessinstruction.OID = setupparameter.OWNEROID
GO

-- PROCESS SETUP EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SETUPEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SETUPEVENTS
GO

CREATE VIEW DCEREPORT_SETUPEVENTS
AS
SELECT processevent.OID OID,
       processevent.OPERATIONINSTRUCTIONOID SETUPINSTRUCTION_OID,
       setupparameter.OID SETUPPARAMETER_OID,
       processevent.EMPLOYEEOID EMPLOYEE_OID,
       processevent.DEVICEOID DEVICE_OID,
       processevent.VALUE VALUE,
       uom.symbol UOM,
       processevent.DTS DTS,
       processevent.DESCRIPTION DESCRIPTION,
       processevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       processevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT processevent WITH (NOLOCK),
     OBJT_PROCESSPARAMETER setupparameter WITH (NOLOCK)
        LEFT OUTER JOIN OBJT_UOM uom WITH (NOLOCK) ON setupparameter.UOMOID = uom.OID,
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK)
WHERE processevent.CLASSOID = 9000000000000091662
AND setupparameter.CLASSOID = 9000000000000093109
AND processevent.REFOID = setupparameter.OID
AND processevent.OPERATIONINSTRUCTIONOID = runtimeprocessinstruction.OID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.INSTRUCTIONMODE = 0 -- SETUP
UNION ALL
SELECT processevent.OID OID,
       processevent.OPERATIONINSTRUCTIONOID SETUPINSTRUCTION_OID,
       setupparameter.OID SETUPPARAMETER_OID,
       processevent.EMPLOYEEOID EMPLOYEE_OID,
       processevent.DEVICEOID DEVICE_OID,
       processevent.VALUE VALUE,
       '' UOM,
       processevent.DTS DTS,
       processevent.DESCRIPTION DESCRIPTION,
       processevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       processevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT processevent WITH (NOLOCK),
     OBJT_PROCESSPARAMETER setupparameter WITH (NOLOCK),
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK)
WHERE processevent.CLASSOID = 9000000000000091662
AND setupparameter.CLASSOID = 9000000000000093126 -- TextParameter --
AND processevent.REFOID = setupparameter.OID
AND processevent.OPERATIONINSTRUCTIONOID = runtimeprocessinstruction.OID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.INSTRUCTIONMODE = 0 -- SETUP
GO

-- PROCESS DATA COLLECTION INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DATACOLLECTIONINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DATACOLLECTIONINSTR
GO

CREATE VIEW DCEREPORT_DATACOLLECTIONINSTR
AS
SELECT runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimeprocessinstruction.NAME NAME,
       runtimeprocessinstruction.DESCRIPTION DESCRIPTION,
       runtimeprocessinstruction.ID ID,
       processparameter.OID PROCESSPARAMETER_OID,
       processparameter.NAME PROCESSPARAMETER_NAME,
       processparameter.DESCRIPTION PROCESSPARAMETER_DESCRIPTION,
       processparameter.QTYSTANDARD QTYSTANDARD,
       processparameter.QTYTARGET QTYTARGET,
       processparameter.QTYHIGH UPPER_WARNING_LIMIT,
       processparameter.QTYLOW LOWER_WARNING_LIMIT,
       processparameter.QTYHIGHHIGH UPPER_ERROR_LIMIT,
       processparameter.QTYLOWLOW LOWER_ERROR_LIMIT,
       processparameter.VALUE QTYACTUAL,
       uom.SYMBOL UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_PROCESSPARAMETER processparameter WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND processparameter.CLASSOID = 9000000000000093109
AND runtimeprocessinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID =  processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 1 -- DATA_COLLECTION
AND runtimeprocessinstruction.OID = processparameter.OWNEROID
AND processparameter.UOMOID = uom.OID
UNION ALL
SELECT runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimeprocessinstruction.NAME NAME,
       runtimeprocessinstruction.DESCRIPTION DESCRIPTION,
       runtimeprocessinstruction.ID ID,
       processparameter.OID PROCESSPARAMETER_OID,
       processparameter.NAME PROCESSPARAMETER_NAME,
       processparameter.DESCRIPTION PROCESSPARAMETER_DESCRIPTION,
       processparameter.QTYSTANDARD QTYSTANDARD,
       processparameter.QTYTARGET QTYTARGET,
       processparameter.QTYHIGH UPPER_WARNING_LIMIT,
       processparameter.QTYLOW LOWER_WARNING_LIMIT,
       processparameter.QTYHIGHHIGH UPPER_ERROR_LIMIT,
       processparameter.QTYLOWLOW LOWER_ERROR_LIMIT,
       processparameter.VALUE QTYACTUAL,
       uom.SYMBOL UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_PROCESSPARAMETER processparameter WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND processparameter.CLASSOID = 9000000000000093109
AND runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 1 -- DATA_COLLECTION
AND runtimeprocessinstruction.OID = processparameter.OWNEROID
AND processparameter.UOMOID = uom.OID
GO

-- PROCESS DATA COLLECTION EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_DATACOLLECTIONEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_DATACOLLECTIONEVENTS
GO

CREATE VIEW DCEREPORT_DATACOLLECTIONEVENTS
AS
SELECT processevent.OID OID,
       processevent.OPERATIONINSTRUCTIONOID DATACOLLECTIONINSTRUCTION_OID,
       processparameter.OID PROCESSPARAMETER_OID,
       processevent.EMPLOYEEOID EMPLOYEE_OID,
       processevent.DEVICEOID DEVICE_OID,
       processevent.VALUE VALUE,
       uom.SYMBOL UOM,
       processevent.CATEGORY CATEGORY,
       processevent.DTS DTS,
       processevent.DESCRIPTION DESCRIPTION,
       processevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       processevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT processevent WITH (NOLOCK),
     OBJT_PROCESSPARAMETER processparameter WITH (NOLOCK),
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION processinstruction WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE processevent.CLASSOID = 9000000000000091662
AND processparameter.CLASSOID = 9000000000000093109
AND processevent.REFOID = processparameter.OID
AND processevent.OPERATIONINSTRUCTIONOID = runtimeprocessinstruction.OID
AND runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 1 -- DATA_COLLECTION
AND processparameter.UOMOID = uom.OID
GO

-- MEASUREMENT INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MEASUREMENTINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MEASUREMENTINSTR
GO

CREATE VIEW DCEREPORT_MEASUREMENTINSTR
AS
SELECT runtimemeasurementinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimemeasurementinstruction.NAME NAME,
       runtimemeasurementinstruction.DESCRIPTION DESCRIPTION,
       runtimemeasurementinstruction.ID ID,
       measurement.OID MEASUREMENT_OID,
       measurement.NAME MEASUREMENT_NAME,
       measurement.DESCRIPTION MEASUREMENT_DESCRIPTION,
       measurement.QTYSTANDARD QTYSTANDARD,
       measurement.QTYHIGH UCL,
       measurement.QTYLOW LCL,
       measurement.QTYHIGHHIGH USL,
       measurement.QTYLOWLOW LSL,
       measurement.VALUE AVERAGE,
       measurement.VALUERANGE VALUERANGE,
       uom.SYMBOL UOM,
       runtimemeasurementinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimemeasurementinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimemeasurementinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimemeasurementinstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_MEASUREMENT measurement WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE runtimemeasurementinstruction.CLASSOID = 9000000000000089964
AND runtimemeasurementinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimemeasurementinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimemeasurementinstruction.OID = measurement.OWNEROID
AND measurement.CLASSOID = 9000000000000093063
AND measurement.UOMOID = uom.OID
UNION ALL
SELECT runtimemeasurementinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimemeasurementinstruction.NAME NAME,
       runtimemeasurementinstruction.DESCRIPTION DESCRIPTION,
       runtimemeasurementinstruction.ID ID,
       measurement.OID MEASUREMENT_OID,
       measurement.NAME MEASUREMENT_NAME,
       measurement.DESCRIPTION MEASUREMENT_DESCRIPTION,
       measurement.QTYSTANDARD QTYSTANDARD,
       measurement.QTYHIGH UCL,
       measurement.QTYLOW LCL,
       measurement.QTYHIGHHIGH USL,
       measurement.QTYLOWLOW LSL,
       measurement.VALUE AVERAGE,
       measurement.VALUERANGE VALUERANGE,
       uom.SYMBOL UOM,
       runtimemeasurementinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimemeasurementinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimemeasurementinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimemeasurementinstruction WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_MEASUREMENT measurement WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE runtimemeasurementinstruction.CLASSOID = 9000000000000089964
AND runtimemeasurementinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimemeasurementinstruction.OID = measurement.OWNEROID
AND measurement.CLASSOID = 9000000000000093063
AND measurement.UOMOID = uom.OID
GO

-- MEASUREMENT EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_MEASUREMENTEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_MEASUREMENTEVENTS
GO

CREATE VIEW DCEREPORT_MEASUREMENTEVENTS
AS
SELECT measurementevent.OID OID,
       measurementevent.OPERATIONINSTRUCTIONOID MEASUREMENTINSTRUCTION_OID,
       measurement.OID MEASUREMENT_OID,
       measurementevent.EMPLOYEEOID EMPLOYEE_OID,
       measurementevent.DEVICEOID DEVICE_OID,
       measurementevent.VALUE VALUE,
       uom.SYMBOL UOM,
       measurementevent.DTS DTS,
       measurementevent.DESCRIPTION DESCRIPTION,
       measurementevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       measurementevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT measurementevent WITH (NOLOCK),
     OBJT_MEASUREMENT measurement WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE measurementevent.CLASSOID = 9000000000000091647
AND measurementevent.REFOID = measurement.OID
AND measurement.CLASSOID = 9000000000000093063
AND measurement.UOMOID = uom.OID
GO

-- INPUT INSTRUCTIONS
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INPUTINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INPUTINSTR
GO

CREATE VIEW DCEREPORT_INPUTINSTR
AS
SELECT runtimeinputinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimeinputinstruction.NAME NAME,
       runtimeinputinstruction.DESCRIPTION DESCRIPTION,
       runtimeinputinstruction.ID ID,
       runtimeinputinstruction.INPUTVALUE VALUE,
       runtimeinputinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinputinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinputinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinputinstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimeinputinstruction.CLASSOID = 9000000000000089954
AND runtimeinputinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimeinputinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.CLASSOID = 9000000000000085787
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
UNION ALL
SELECT runtimeinputinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimeinputinstruction.NAME NAME,
       runtimeinputinstruction.DESCRIPTION DESCRIPTION,
       runtimeinputinstruction.ID ID,
       runtimeinputinstruction.INPUTVALUE VALUE,
       runtimeinputinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinputinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinputinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinputinstruction WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimeinputinstruction.CLASSOID = 9000000000000089954
AND runtimeinputinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST
GO

-- INPUT EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INPUTEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INPUTEVENTS
GO

CREATE VIEW DCEREPORT_INPUTEVENTS
AS
SELECT inputevent.OID OID,
       inputevent.OPERATIONINSTRUCTIONOID INPUTINSTRUCTION_OID,
       inputevent.EMPLOYEEOID EMPLOYEE_OID,
       inputevent.DEVICEOID DEVICE_OID,
       inputevent.VALUE VALUE,
       inputevent.COMMENTS COMMENTS,
       inputevent.DTS DTS,
       inputevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       inputevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT inputevent WITH (NOLOCK)
WHERE inputevent.CLASSOID = 9000000000000091659
GO

-- CHECK INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CHECKINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CHECKINSTR
GO

CREATE VIEW DCEREPORT_CHECKINSTR
AS
SELECT runtimecheckinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimecheckinstruction.NAME NAME,
       runtimecheckinstruction.DESCRIPTION DESCRIPTION,
       runtimecheckinstruction.ID ID,
       runtimecheckinstruction.VALUE VALUE,
       CASE WHEN (instruction.INSTRUCTIONOPTION & 4 = 4) THEN 1 ELSE 0 END AS INPUTTYPE, -- 0 = YES/NO, 1 = OK/NOK
       runtimecheckinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimecheckinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimecheckinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimecheckinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION instruction,
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimecheckinstruction.CLASSOID = 9000000000000089958
AND runtimecheckinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimecheckinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND runtimecheckinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
UNION ALL
SELECT runtimecheckinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimecheckinstruction.NAME NAME,
       runtimecheckinstruction.DESCRIPTION DESCRIPTION,
       runtimecheckinstruction.ID ID,
       runtimecheckinstruction.VALUE VALUE,
       CASE WHEN (instruction.INSTRUCTIONOPTION & 4 = 4) THEN 1 ELSE 0 END AS INPUTTYPE, -- 0 = YES/NO, 1 = OK/NOK
       runtimecheckinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimecheckinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimecheckinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimecheckinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION instruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimecheckinstruction.CLASSOID = 9000000000000089958
AND runtimecheckinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST
AND runtimecheckinstruction.OPERATIONINSTRUCTIONOID = instruction.OID

GO

-- CHECK EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_CHECKEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_CHECKEVENTS
GO

CREATE VIEW DCEREPORT_CHECKEVENTS
AS
SELECT checkevent.OID OID,
       checkevent.OPERATIONINSTRUCTIONOID CHECKINSTRUCTION_OID,
       checkevent.EMPLOYEEOID EMPLOYEE_OID,
       checkevent.DEVICEOID DEVICE_OID,
       checkevent.VALUE VALUE,
       checkevent.COMMENTS COMMENTS,
       checkevent.DTS DTS,
       checkevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       checkevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT checkevent WITH (NOLOCK)
WHERE checkevent.CLASSOID = 9000000000000091653
GO

-- PRINT INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_PRINTINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_PRINTINSTR
GO

CREATE VIEW DCEREPORT_PRINTINSTR
AS
SELECT runtimeprintinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimeprintinstruction.NAME NAME,
       runtimeprintinstruction.DESCRIPTION DESCRIPTION,
       runtimeprintinstruction.ID ID,
       documenttemplate.NAME DOCUMENT_NAME,
       documenttemplate.DESCRIPTION DOCUMENT_DESCRIPTION,
       runtimeprintinstruction.COPIES COPIES,
       CAST(CASE WHEN (runtimeprintinstruction.INSTRUCTIONOPTION & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS COPIESFIXED,
       runtimeprintinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprintinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprintinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprintinstruction WITH (NOLOCK),
     OBJT_DOCUMENTTEMPLATE documenttemplate WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimeprintinstruction.CLASSOID = 9000000000000089966
AND runtimeprintinstruction.DOCUMENTTEMPLATEOID = documenttemplate.OID
AND runtimeprintinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK)
                WHERE runtimeprintinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
UNION ALL
SELECT runtimeprintinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimeprintinstruction.NAME NAME,
       runtimeprintinstruction.DESCRIPTION DESCRIPTION,
       runtimeprintinstruction.ID ID,
       documenttemplate.NAME DOCUMENT_NAME,
       documenttemplate.DESCRIPTION DOCUMENT_DESCRIPTION,
       runtimeprintinstruction.COPIES COPIES,
       CAST(CASE WHEN (runtimeprintinstruction.INSTRUCTIONOPTION & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS COPIESFIXED,
       runtimeprintinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprintinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprintinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprintinstruction WITH (NOLOCK),
     OBJT_DOCUMENTTEMPLATE documenttemplate WITH (NOLOCK),
     OBJT_INSTRUCTIONLINK instructionsheetlink WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimeprintinstruction.CLASSOID = 9000000000000089966
AND runtimeprintinstruction.DOCUMENTTEMPLATEOID = documenttemplate.OID
AND runtimeprintinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST
GO

-- PRINT EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_PRINTEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_PRINTEVENTS
GO

CREATE VIEW DCEREPORT_PRINTEVENTS
AS
SELECT printevent.OID OID,
       printevent.OPERATIONINSTRUCTIONOID PRINTINSTRUCTION_OID,
       printevent.EMPLOYEEOID EMPLOYEE_OID,
       printevent.DEVICEOID DEVICE_OID,
       printevent.COMMENTS COMMENTS,
       printevent.DTS DTS,
       printevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       printevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT printevent WITH (NOLOCK)
WHERE printevent.CLASSOID = 9000000000000091644
GO

-- INSPECTION INSTRUCTIONS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('OBJTREP_INSPECTIONINSTR') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW OBJTREP_INSPECTIONINSTR
GO

CREATE VIEW OBJTREP_INSPECTIONINSTR
AS
SELECT runtimeinspectioninstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS BIGINT) INSTRUCTIONSHEET_OID,
       runtimeinspectioninstruction.NAME NAME,
       runtimeinspectioninstruction.DESCRIPTION DESCRIPTION,
       runtimeinspectioninstruction.ID ID,
       runtimeinspectioninstruction.CATEGORY INSPECTIONTYPE,
       runtimeinspectioninstruction.RUNTIMEINSPECTIONSHEETOID INSPECTIONSHEETOID,
       runtimeinspectioninstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinspectioninstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinspectioninstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinspectioninstruction WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimeinspectioninstruction.CLASSOID = 9010000000000000015
AND ((runtimeinspectioninstruction.TOID <> -1) OR (runtimeinspectioninstruction.TOID IS NULL))
AND runtimeinspectioninstruction.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
GO

-- INSPECTION EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('OBJTREP_INSPECTIONEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW OBJTREP_INSPECTIONEVENTS
GO

CREATE VIEW OBJTREP_INSPECTIONEVENTS
AS
SELECT inspectionevent.OID OID,
       inspectionevent.OPERATIONINSTRUCTIONOID INSPECTIONINSTRUCTION_OID,
       inspectionevent.EMPLOYEEOID EMPLOYEE_OID,
       inspectionevent.DEVICEOID DEVICE_OID,
       inspectionevent.COMMENTS COMMENTS,
       inspectionevent.DTS DTS,
       inspectionevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       inspectionevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT inspectionevent WITH (NOLOCK)
WHERE inspectionevent.CLASSOID = 9010000000000000018
GO

-- INSTRUCTION SHEETS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INSTRUCTIONSHEETS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INSTRUCTIONSHEETS
GO

CREATE VIEW DCEREPORT_INSTRUCTIONSHEETS
AS
SELECT runtimeinstructionsheet.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.NAME NAME,
       runtimeinstructionsheet.DESCRIPTION DESCRIPTION,
       runtimeinstructionsheet.ID ID,
       CAST(CASE WHEN (runtimeinstructionsheet.STATUS IN (0, 2, 3)) THEN 'OPEN'
                 WHEN (runtimeinstructionsheet.STATUS = 11) THEN 'FINISHED'
                 WHEN (runtimeinstructionsheet.STATUS = 4) THEN CASE WHEN (runtimeinstructionsheet.INSTRUCTIONOPTION & 2 = 2) THEN 'VERIFIED' ELSE 'FINISHED' END
                 WHEN (runtimeinstructionsheet.STATUS = 13) THEN 'CLOSED' END AS VARCHAR(8)) AS STATUS,
       CAST(CASE WHEN (runtimeinstructionsheet.INSTRUCTIONOPTION & 1 = 1) THEN 'T' ELSE 'F' END AS CHAR(1)) AS QUALITYSHEET,
       CAST(CASE WHEN (runtimeinstructionsheet.INSTRUCTIONOPTION & 2 = 2) THEN 'T' ELSE 'F' END AS CHAR(1)) AS DOUBLESIGNOFF,
       CAST(CASE WHEN (runtimeinstructionsheet.INSTRUCTIONOPTION & 4 = 4) THEN 'T' ELSE 'F' END AS CHAR(1)) AS TAKEOFFSHEET,
       runtimeinstructionsheet.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinstructionsheet.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinstructionsheet.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK)
WHERE runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND ((runtimeinstructionsheet.TOID <> -1) OR (runtimeinstructionsheet.TOID IS NULL))
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --

GO

-- INSTRUCTION TASKS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INSTRUCTIONTASKS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INSTRUCTIONTASKS
GO

CREATE VIEW DCEREPORT_INSTRUCTIONTASKS
AS
SELECT instructiontask.OID OID,
       instructiontask.BOTYPE TYPE,
       instructiontask.STATUS STATUS,
       instructiontask.OPERATIONINSTRUCTIONOID INSTRUCTION_OID,
       CASE WHEN (runtimeinstruction.CLASSOID = 9000000000000089974) THEN 'INSTRUCTIONSHEET'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089966) THEN 'PRINTINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089972 AND instruction.INSTRUCTIONMODE = 0) THEN 'SETUPINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089964) THEN 'MEASUREMENTINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089958) THEN 'CHECKINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089962) THEN 'DOCUMENTEDINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089972 AND instruction.INSTRUCTIONMODE = 1) THEN 'DATACOLLECTIONINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089954) THEN 'INPUTINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9010000000000000015) THEN 'INSPECTIONINSTRUCTION'
            ELSE 'UNKOWN' END INSTRUCTION_TYPE,
       instructiontask.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       instructiontask.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       instructiontask.DTSSTART DTSSTART,
       instructiontask.DTSSTOP DTSSTOP,
       instructiontask.DTSUPDATE DTSUPDATE
FROM OBJT_INSTRUCTIONTASK instructiontask WITH (NOLOCK),
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION instruction WITH (NOLOCK)
WHERE runtimeinstruction.OID = instructiontask.OPERATIONINSTRUCTIONOID
AND runtimeinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
UNION ALL
SELECT instructiontask.OID OID,
       instructiontask.BOTYPE TYPE,
       instructiontask.STATUS STATUS,
       instructiontask.OPERATIONINSTRUCTIONOID INSTRUCTION_OID,
       CASE WHEN (runtimeinstruction.CLASSOID = 9000000000000089974) THEN 'INSTRUCTIONSHEET'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089966) THEN 'PRINTINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089972 AND instruction.INSTRUCTIONMODE = 0) THEN 'SETUPINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089964) THEN 'MEASUREMENTINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089958) THEN 'CHECKINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089962) THEN 'DOCUMENTEDINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089972 AND instruction.INSTRUCTIONMODE = 1) THEN 'DATACOLLECTIONINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9000000000000089954) THEN 'INPUTINSTRUCTION'
            WHEN (runtimeinstruction.CLASSOID = 9010000000000000015) THEN 'INSPECTIONINSTRUCTION'
            ELSE 'UNKOWN' END INSTRUCTION_TYPE,
       instructiontask.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       instructiontask.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       instructiontask.DTSSTART DTSSTART,
       instructiontask.DTSSTOP DTSSTOP,
       instructiontask.DTSUPDATE DTSUPDATE
FROM OBJT_INSTRUCTIONTASK instructiontask WITH (NOLOCK),
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstruction WITH (NOLOCK),
     OBJT_OPERATIONINSTRUCTION instruction WITH (NOLOCK)
WHERE runtimeinstruction.OID = instructiontask.OPERATIONINSTRUCTIONOID
AND runtimeinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
GO

-- SHEET EVENTS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_SHEETEVENTS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_SHEETEVENTS
GO

CREATE VIEW DCEREPORT_SHEETEVENTS
AS
SELECT sheetevent.OID OID,
       sheetevent.OPERATIONINSTRUCTIONOID INSTRUCTIONSHEET_OID,
       sheetevent.EMPLOYEEOID EMPLOYEE_OID,
       sheetevent.DEVICEOID DEVICE_OID,
       sheetevent.CATEGORY CATEGORY,
       sheetevent.COMMENTS COMMENTS,
       sheetevent.DTS DTS,
       sheetevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       sheetevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT sheetevent WITH (NOLOCK)
WHERE sheetevent.CLASSOID = 9000000000000091656
GO

-- INPUT TARGETS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INPUT_TARGETS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INPUT_TARGETS
GO

CREATE VIEW DCEREPORT_INPUT_TARGETS
AS
SELECT target_inputop.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       (SELECT TOP 1 location.OID FROM OBJT_WAREHOUSELOCATION location WITH (NOLOCK), OBJT_OPERATIONRESOURCELINK inputop_location_link WITH (NOLOCK)
                                  WHERE inputop_location_link.RESOURCEOID = location.OID
                                  AND inputop_location_link.OPERATIONOID = target_inputop.OID) AS LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inputitemqty.QTYTARGET TARGET,
       inputitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       target_inputop.DTSSTART DTSSTART,
       target_inputop.DTSSTOP DTSSTOP,
       dbo.MaxDate(target_inputop.DTSUPDATE, inputitemqty.DTSUPDATE) AS DTSUPDATE,
       target_inputop.DTSUPDATE AS DTSUPDATE_1,
       inputitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_INPUTOPERATION target_inputop WITH (NOLOCK),
     OBJT_OPERATIONLINK inputop_machineop_link WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_INPUTITEMQTY inputitemqty WITH (NOLOCK),
     OBJT_LOT lot WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE target_inputop.BOTYPE = 0 -- TARGET
AND target_inputop.OID = inputop_machineop_link.CHILDOID
AND inputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND target_inputop.OID = inputitemqty.INPUTOPERATIONOID
AND inputitemqty.UOMOID = uom.OID
AND inputitemqty.LOTOID = lot.OID
GO

-- INPUT ACTUALS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_INPUT_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_INPUT_ACTUALS
GO

CREATE VIEW DCEREPORT_INPUT_ACTUALS
AS
SELECT input_inventorytraceop.OID OID,
       target_inputop.OID INPUT_TARGET_OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       input_inventorytraceop.STATUS STATUS,
       input_inventorytraceop.FROMLOCATIONOID LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       input_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       input_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       input_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       input_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       input_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       ABS(input_inventorytraceop.TOQTYDELTA) AS QTY,
       uom.SYMBOL UOM,
       input_inventorytraceop.DTSSTART DTSSTART,
       input_inventorytraceop.DTSSTOP DTSSTOP,
       input_inventorytraceop.FROMCSITQOID CONTAINER_OID,
       input_inventorytraceop.FROMNESTCSITQOID NEST_CONTAINER_OID,
       input_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       input_inventorytraceop.DEVICEOID DEVICE_OID,
       input_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION input_inventorytraceop WITH (NOLOCK),
     OBJT_OPERATIONLINK inputoperation_link WITH (NOLOCK),
     OBJT_INPUTOPERATION target_inputop WITH (NOLOCK),
     OBJT_OPERATIONLINK inputop_machineop_link WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_LOT lot WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE input_inventorytraceop.BOTYPE = 2 -- INPUT
AND input_inventorytraceop.OID = inputoperation_link.CHILDOID
AND inputoperation_link.PARENTOID = target_inputop.OID
AND target_inputop.BOTYPE = 0 -- TARGET
AND target_inputop.OID = inputop_machineop_link.CHILDOID
AND inputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_WMS_KIT/TYPE_WMS_VAL --
AND input_inventorytraceop.LOTOID = lot.OID
AND input_inventorytraceop.UOMOID = uom.OID
GO

-- OUTPUT TARGETS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_OUTPUT_TARGETS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_OUTPUT_TARGETS
GO

CREATE VIEW DCEREPORT_OUTPUT_TARGETS
AS
SELECT target_outputop.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       (SELECT TOP 1 location.OID FROM OBJT_WAREHOUSELOCATION location WITH (NOLOCK), OBJT_OPERATIONRESOURCELINK outputop_location_link WITH (NOLOCK)
                                  WHERE outputop_location_link.RESOURCEOID = location.OID
                                  AND outputop_location_link.OPERATIONOID = target_outputop.OID) AS LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       outputitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       target_outputop.DTSSTART DTSSTART,
       target_outputop.DTSSTOP DTSSTOP,
       dbo.MaxDate(target_outputop.DTSUPDATE, outputitemqty.DTSUPDATE) AS DTSUPDATE,
       target_outputop.DTSUPDATE AS DTSUPDATE_1,
       outputitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_OUTPUTOPERATION target_outputop WITH (NOLOCK),
     OBJT_OPERATIONLINK outputop_machineop_link WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_OUTPUTITEMQTY outputitemqty WITH (NOLOCK),
     OBJT_LOT lot WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE target_outputop.BOTYPE = 0 -- TARGET
AND target_outputop.OID = outputop_machineop_link.CHILDOID
AND outputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND target_outputop.OID = outputitemqty.OUTPUTOPERATIONOID
AND outputitemqty.UOMOID = uom.OID
AND outputitemqty.LOTOID = lot.OID
GO

-- OUTPUT ACTUALS --
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEREPORT_OUTPUT_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEREPORT_OUTPUT_ACTUALS
GO

CREATE VIEW DCEREPORT_OUTPUT_ACTUALS
AS
SELECT output_inventorytraceop.OID OID,
       target_outputop.OID OUTPUT_TARGET_OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       output_inventorytraceop.STATUS STATUS,
       output_inventorytraceop.TOLOCATIONOID LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       output_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       output_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       output_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       output_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       output_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       output_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       output_inventorytraceop.DTSSTART DTSSTART,
       output_inventorytraceop.DTSSTOP DTSSTOP,
       output_inventorytraceop.TOCSITQOID CONTAINER_OID,
       output_inventorytraceop.TONESTCSITQOID NEST_CONTAINER_OID,
       output_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       output_inventorytraceop.DEVICEOID DEVICE_OID,
       output_inventorytraceopex.QTY1 QTYREWORKABLE,
       output_inventorytraceopex.QTY2 QTYNRFT,
       output_inventorytraceopex.QTY3 QTYREWORKED,
       output_inventorytraceopex.QTY4 QTYADJUSTED,
       output_inventorytraceopex.QTY5 QTYREJECTED,
       output_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION output_inventorytraceop
        LEFT JOIN OBJT_INVENTORYTRACEOPEXTENSION output_inventorytraceopex ON output_inventorytraceop.EXTENSIONOID = output_inventorytraceopex.OID,
     OBJT_OPERATIONLINK outputoperation_link WITH (NOLOCK),
     OBJT_OUTPUTOPERATION target_outputop WITH (NOLOCK),
     OBJT_OPERATIONLINK outputop_machineop_link WITH (NOLOCK),
     OBJT_MACHINEOPERATION machineoperation WITH (NOLOCK),
     OBJT_PROCESSUNIT processresource WITH (NOLOCK),
     OBJT_PRODUCTIONOPERATION productionoperation WITH (NOLOCK),
     OBJT_PRODUCTIONORDER productionorder WITH (NOLOCK),
     OBJT_LOT lot WITH (NOLOCK),
     OBJT_UOM uom WITH (NOLOCK)
WHERE output_inventorytraceop.BOTYPE = 3 -- OUTPUT
AND output_inventorytraceop.OID = outputoperation_link.CHILDOID
AND outputoperation_link.PARENTOID = target_outputop.OID
AND target_outputop.BOTYPE = 0 -- TARGET
AND target_outputop.OID = outputop_machineop_link.CHILDOID
AND outputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionoperation.PRODUCTIONORDEROID = productionorder.OID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND output_inventorytraceop.UOMOID = uom.OID
AND output_inventorytraceop.LOTOID = lot.OID
GO