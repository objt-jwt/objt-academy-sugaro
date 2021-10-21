-- Oracle MES views --

-- DEPARTMENTS_CHILDDEPARTMENTS --
CREATE OR REPLACE VIEW DCEREPORT_DEPARTMENT_CHILDDEP
AS
SELECT department.OID OID,
       department.NAME NAME,
       department.DESCRIPTION DESCRIPTION,
       childdepartment.OID CHILDDEPARTMENT_OID,
       childdepartment.NAME CHILDDEPARTMENT_NAME,
       childdepartment.DESCRIPTION CHILDDEPARTMENT_DESCRIPTION,
       CAST(GREATEST(department.DTSUPDATE, childdepartment.DTSUPDATE) AS DATE) DTSUPDATE,
       department.DTSUPDATE AS DTSUPDATE_1,
       childdepartment.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_DEPARTMENT department,
     OBJT_RESOURCELINK dep_childdep_link,
     OBJT_DEPARTMENT childdepartment
WHERE department.OID = dep_childdep_link.PARENTOID
AND dep_childdep_link.CHILDOID = childdepartment.OID
/

-- DEPARTMENTS_PROCESSRESOURCES --
CREATE OR REPLACE VIEW DCEREPORT_DEPARTMENT_RESRCS
AS
SELECT department.OID OID,
       department.NAME NAME,
       department.DESCRIPTION DESCRIPTION,
       processresource.OID PROCESSRESOURCE_OID,
       processresource.NAME PROCESSRESOURCE_NAME,
       processresource.DESCRIPTION PROCESSRESOURCE_DESCRIPTION,
       CASE WHEN (processresource.CLASSOID = 9000000000000010923) THEN 'MACHINE'
        	  WHEN (processresource.CLASSOID = 9000000000000037041) THEN 'WORKCENTER' END AS PROCESSRESOURCE_TYPE,
       CAST(GREATEST(department.DTSUPDATE, processresource.DTSUPDATE) AS DATE) DTSUPDATE,
       department.DTSUPDATE AS DTSUPDATE_1,
       processresource.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_DEPARTMENT department,
     OBJT_PROCESSUNIT processresource,
     OBJT_RESOURCELINK resource_department_link
WHERE (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND resource_department_link.PARENTOID = department.OID
AND resource_department_link.CHILDOID = processresource.OID
/

-- TOOLS --
CREATE OR REPLACE VIEW DCEREPORT_TOOLS
AS
SELECT /*+ FIRST_ROWS(30) */ tool.OID OID,
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
FROM OBJT_ITEM tool,
     OBJT_ITEMUOMLINK tool_uom_link,
     OBJT_UOM uom
WHERE tool.BOTYPE = 10
AND tool.OID = tool_uom_link.ITEMOID
AND tool_uom_link.SEQ = 0
AND tool_uom_link.UOMOID = uom.OID
/

-- RESOURCETRAINS --
CREATE OR REPLACE VIEW DCEREPORT_RESOURCETRAINS
AS
SELECT /*+ FIRST_ROWS(30) */ resourcetrain.OID OID,
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
FROM OBJT_RESOURCETRAIN resourcetrain
/

-- RESOURCETRAINS_PROCESSRESOURCES --
CREATE OR REPLACE VIEW DCEREPORT_RESOURCETRAIN_RESRCS
AS
SELECT resourcetrain.OID OID,
       resourcetrain.NAME NAME,
       resourcetrain.DESCRIPTION DESCRIPTION,
       processresource.OID PROCESSRESOURCE_OID,
       processresource.NAME PROCESSRESOURCE_NAME,
       processresource.DESCRIPTION PROCESSRESOURCE_DESCRIPTION,
       CASE WHEN (processresource.CLASSOID = 9000000000000010923) THEN 'MACHINE'
        	  WHEN (processresource.CLASSOID = 9000000000000037041) THEN 'WORKCENTER' END AS PROCESSRESOURCE_TYPE,
       CAST(GREATEST(resourcetrain.DTSUPDATE, processresource.DTSUPDATE) AS DATE) DTSUPDATE,
       resourcetrain.DTSUPDATE AS DTSUPDATE_1,
       processresource.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_RESOURCETRAIN resourcetrain,
     OBJT_PROCESSUNIT processresource,
     OBJT_RESOURCELINK resource_resourcetrain_link
WHERE (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND resource_resourcetrain_link.PARENTOID = resourcetrain.OID
AND resource_resourcetrain_link.CHILDOID = processresource.OID
/

-- EQUIPMENTMODULES --
CREATE OR REPLACE VIEW DCEREPORT_EQUIPMENTMODULES
AS
SELECT /*+ FIRST_ROWS(30) */ equipmentmodule.OID OID,
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
FROM OBJT_EQUIPMENTMODULE equipmentmodule,
     OBJT_RESOURCELINK resource_module_link
WHERE equipmentmodule.OID = resource_module_link.CHILDOID
/

-- ISPRESENTOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_ISPRESENTOPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */ ispresentoperation.OID OID,
       ispresentoperation.DTSSTART DTSSTART,
       ispresentoperation.DTSSTOP DTSSTOP,
       ispresentoperation.STATUS STATUS,
       employee.OID EMPLOYEE_OID,
	     processresource.OID PROCESSRESOURCE_OID,
       ispresentoperation.DTSUPDATE DTSUPDATE
FROM OBJT_ISPRESENTOPERATION ispresentoperation,
     OBJT_EMPLOYEE employee,
     OBJT_PROCESSUNIT processresource
WHERE ispresentoperation.EMPLOYEEOID =employee.OID
AND ispresentoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
/

-- DIRECT TASKS --
-- aggregation of direct tasks on machines and workcenter, for workcenter the qtyproduced and qtyscrap are left joined
-- if qtyproduced and/or qtyscrap are null they are shown as '0' using an NVL statement
CREATE OR REPLACE VIEW DCEREPORT_DIRECT_TASKS
AS
SELECT /*+ FIRST_ROWS(30) */  manoperation.OID OID,
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
       NVL(manop_productiveitq.VALUE, 0) AS QTY,
       NVL(manop_productiveitq.QTYINCOMPLETE, 0) AS QTYINCOMPLETE,
       NVL(manop_productiveitq.QTYNRFT, 0) AS QTYNRFT,
       NVL(manop_productiveitq.QTYSCRAP, 0) AS QTYREJECT,
       NVL(manop_productiveitq.QTYREJECTED, 0) AS QTYREJECTED,
       NVL(manop_productiveitq.QTYREWORKED, 0) AS QTYREWORKED,
       NVL(manop_productiveitq.QTYREWORKABLE, 0) AS QTYREWORKABLE,
       NVL(manop_productiveitq.QTYDIRECTREWORK, 0) AS QTYDIRECTREWORK,
       NVL(manop_productiveitq.QTYINDIRECTREWORK, 0) AS QTYINDIRECTREWORK,
       uom.SYMBOL UOM,
       CAST(GREATEST(manoperation.DTSUPDATE, manop_productiveitq.DTSUPDATE) AS DATE) DTSUPDATE
FROM (OBJT_MANOPERATION manoperation
      LEFT JOIN OBJT_OPERATIONITEMQTYLINK manop_proditq_link ON manop_proditq_link.OPERATIONOID = manoperation.oid AND manop_proditq_link.ITEMQTYCLASSNAME = 'objt.mes.bo.productionmgt.ProductiveItemQty')
        LEFT JOIN OBJT_PRODUCTIVEITEMQTY manop_productiveitq ON manop_proditq_link.ITEMQTYOID = manop_productiveitq.oid,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_EMPLOYEE employee,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link,
     OBJT_PRODUCTIVEITEMQTY machineop_productiveitq,
     OBJT_UOM uom
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
/

-- ACTIVITIES (DIRECT MANUALOPERATIONS) --
CREATE OR REPLACE VIEW DCEREPORT_ACTIVITIES
AS
SELECT /*+ FIRST_ROWS(30) */ manualoperation.OID OID,
       manualoperation.NAME NAME,
       manualoperation.DESCRIPTION DESCRIPTION,
       manualoperation.ID ID,
       manualoperation.PRIORITY PRIORITY,
       CASE WHEN (BITAND(manualoperation.OPERATIONOPTION, 1) = 1) THEN 'F' ELSE 'T' END AS PRODUCTIVE,
       manualoperation.DTSVALIDFROM DTSVALIDFROM,
       manualoperation.DTSVALIDUNTIL DTSVALIDUNTIL,
       manualoperation.DTSUPDATE DTSUPDATE
FROM OBJT_MANUALOPERATION manualoperation
WHERE manualoperation.BOTYPE = 1 -- DIRECT
/

-- ALLOCATION DETAILS --
CREATE OR REPLACE VIEW DCEREPORT_ALLOCATIONDETAILS
AS
SELECT /*+ FIRST_ROWS(30) */ allocationdetail.OID OID,
       allocationdetail.MANOPERATIONOID TASK_OID,
       allocationdetail.RESOURCEALLOCATION RESOURCEALLOCATION,
       allocationdetail.DTSSTART DTSSTART,
       allocationdetail.DTSSTOP DTSSTOP,
       allocationdetail.DTSUPDATE DTSUPDATE
FROM OBJT_MANOPERATIONALLOCATIONDTL allocationdetail
/

-- INDIRECT TASKS --
CREATE OR REPLACE VIEW DCEREPORT_INDIRECT_TASKS
AS
SELECT /*+ FIRST_ROWS(30) */  manoperation.OID OID,
       manoperation.DTSSTART DTSSTART,
       manoperation.DTSSTOP DTSSTOP,
       manoperation.STATUS STATUS,
       manoperation.RESOURCEALLOCATION ALLOCATION,
       manoperation.FTE FTE,
       manoperation.OPERATIONOID MANUALOPERATION_OID,
 	     processresource.OID PROCESSRESOURCE_OID,
 	     employee.OID EMPLOYEE_OID,
       manoperation.DTSUPDATE DTSUPDATE
FROM OBJT_MANOPERATION manoperation,
     OBJT_EMPLOYEE employee,
     OBJT_PROCESSUNIT processresource
WHERE manoperation.BOTYPE = 0 -- INDIRECT
AND manoperation.EMPLOYEEOID = employee.OID
AND manoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
/

-- INDIRECT MANUALOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_MANUALOPERATIONS
AS
SELECT manualoperation.OID OID,
       manualoperation.NAME NAME,
       manualoperation.DESCRIPTION DESCRIPTION,
       manualoperation.PRIORITY PRIORITY,
       operationgroup.NAME GROUP_NAME,
       operationgroup.DESCRIPTION GROUP_DESCRIPTION,
       manualoperation.DTSVALIDFROM DTSVALIDFROM,
       manualoperation.DTSVALIDUNTIL DTSVALIDUNTIL,
       CAST(GREATEST(manualoperation.DTSUPDATE, operationgroup.DTSUPDATE) AS DATE) DTSUPDATE,
       manualoperation.DTSUPDATE AS DTSUPDATE_1,
       operationgroup.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_MANUALOPERATION manualoperation,
     OBJT_OPERATIONLINK manualoperation_grouplink,
     OBJT_OPERATIONGROUP operationgroup
WHERE manualoperation.BOTYPE = 0 -- INDIRECT
AND manualoperation_grouplink.CHILDOID = manualoperation.OID
AND manualoperation_grouplink.PARENTOID = operationgroup.OID
/

-- ALARMS --
-- currently only for machines (machineoid on dceoperationmgt_operation)
CREATE OR REPLACE VIEW DCEREPORT_ALARMS
AS
SELECT /*+ FIRST_ROWS(30) */  alarm.OID OID,
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
FROM OBJT_ALARM alarm
/

-- INTERRUPTOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_INTERRUPTOPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */  interruptoperation.OID OID,
       interruptoperation.DTSSTART DTSSTART,
       interruptoperation.DTSSTOP DTSSTOP,
       interruptoperation.STATUS STATUS,
       interruptoperation.REASONOID REASON_OID,
       interruptoperation.DESCRIPTION DESCRIPTION,
       processresource.OID PROCESSRESOURCE_OID,
       CAST((SELECT machineoperation.OID FROM OBJT_OPERATIONLINK machineop_interruptop_link, OBJT_MACHINEOPERATION machineoperation
                                    WHERE interruptoperation.OID = machineop_interruptop_link.CHILDOID
                                    AND machineop_interruptop_link.PARENTOID = machineoperation.OID
                                    AND rownum = 1) AS NUMBER(19)) AS MACHINEOPERATION_OID,
       CAST((SELECT alarm.OID FROM OBJT_OPERATIONLINK interruptop_alarm_link, OBJT_ALARM alarm
                         WHERE interruptoperation.OID = interruptop_alarm_link.PARENTOID
                         AND interruptop_alarm_link.CHILDOID = alarm.OID
                         AND rownum = 1) AS NUMBER(19)) AS ALARM_OID,
       interruptoperation.DTSUPDATE DTSUPDATE
FROM OBJT_INTERRUPTOPERATION interruptoperation,
     OBJT_PROCESSUNIT processresource
WHERE interruptoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
/

-- INTERRUPT REASONS --
CREATE OR REPLACE VIEW DCEREPORT_INTERRUPTREASONS
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
       CAST(GREATEST(reason.DTSUPDATE, reasongroup.DTSUPDATE) AS DATE) DTSUPDATE,
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
FROM OBJT_INTERRUPTREASON reason,
     OBJT_INTERRUPTREASONGROUP reasongroup
WHERE reason.GROUPOID = reasongroup.OID
/

-- REJECTOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_REJECTOPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */  scrapoperation.OID OID,
       scrapoperation.BOTYPE TYPE,
	     scrapoperation.DTSSTART DTSSTART,
	     scrapoperation.DTSSTOP DTSSTOP,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       CAST(NULL AS NUMBER(19)) DIRECT_TASK_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
	     CAST(NULL AS NUMBER(19)) EMPLOYEE_OID,
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
FROM OBJT_SCRAPOPERATION scrapoperation,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_SCRAPITEMQTY scrapitemqty,
     OBJT_UOM uom
WHERE scrapoperation.MACHINEOPERATIONOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND scrapoperation.OID = scrapitemqty.SCRAPOPERATIONOID
AND scrapitemqty.UOMOID = uom.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ scrapoperation.OID OID,
       scrapoperation.BOTYPE TYPE,
	     scrapoperation.DTSSTART DTSSTART,
	     scrapoperation.DTSSTOP DTSSTOP,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       manoperation.OID DIRECT_TASK_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
	     employee.OID EMPLOYEE_OID,
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
FROM OBJT_SCRAPOPERATION scrapoperation,
     OBJT_MANOPERATION manoperation,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_SCRAPITEMQTY scrapitemqty,
     OBJT_EMPLOYEE employee,
     OBJT_UOM uom
WHERE scrapoperation.MANOPERATIONOID = manoperation.OID
AND manoperation.MACHINEOPERATIONOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND scrapoperation.OID = scrapitemqty.SCRAPOPERATIONOID
AND scrapitemqty.UOMOID = uom.OID
AND manoperation.EMPLOYEEOID = employee.OID
/

-- REWORKOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_REWORKOPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */  reworkoperation.OID OID,
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
FROM OBJT_REWORKOPERATION reworkoperation,
     OBJT_SCRAPOPERATION scrapoperation,
     OBJT_REWORKITEMQTY reworkitemqty,
     OBJT_EMPLOYEE employee,
     OBJT_UOM uom
WHERE reworkoperation.SCRAPOPERATIONOID = scrapoperation.OID
AND reworkoperation.OID = reworkitemqty.REWORKOPERATIONOID
AND reworkitemqty.UOMOID = uom.OID
AND reworkoperation.EMPLOYEEOID = employee.OID
/

-- REJECT REASONS --
CREATE OR REPLACE VIEW DCEREPORT_REJECTREASONS
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
       CAST(GREATEST(reason.DTSUPDATE, reasongroup.DTSUPDATE) AS DATE) DTSUPDATE,
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
FROM OBJT_SCRAPREASON reason,
     OBJT_SCRAPREASONGROUP reasongroup
WHERE reason.GROUPOID = reasongroup.OID
/

-- MAINTENANCE --
CREATE OR REPLACE VIEW DCEREPORT_MAINTENANCE_TASKS
AS
SELECT /*+ FIRST_ROWS(30) */ manoperation.OID OID,
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
       CAST(GREATEST(manoperation.DTSUPDATE, maintenanceoperation.DTSUPDATE, maintenanceorder.DTSUPDATE) AS DATE) DTSUPDATE,
       manoperation.DTSUPDATE AS DTSUPDATE_1,
       maintenanceoperation.DTSUPDATE AS DTSUPDATE_2,
       maintenanceorder.DTSUPDATE AS DTSUPDATE_3
FROM OBJT_MANOPERATION manoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_EMPLOYEE employee,
     OBJT_OPERATIONLINK manop_maintop_link,
     OBJT_MAINTENANCEOPERATION maintenanceoperation,
     OBJT_MAINTENANCEORDER maintenanceorder
WHERE manoperation.BOTYPE = 2 -- MAINTENANCE
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND manoperation.PROCESSUNITOID = processresource.OID
AND manoperation.EMPLOYEEOID = employee.OID
AND manoperation.OID = manop_maintop_link.CHILDOID
AND maintenanceoperation.OID = manop_maintop_link.PARENTOID
AND maintenanceorder.OID = maintenanceoperation.MAINTENANCEORDEROID
/

-- PRODUCTIONOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_PRODUCTIONOPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */  productionoperation.OID OID,
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
       CAST(GREATEST(productionoperation.DTSUPDATE, productionitq.DTSUPDATE) AS DATE) DTSUPDATE
FROM (OBJT_PRODUCTIONOPERATION productionoperation
        LEFT JOIN OBJT_PROCESSUNIT processresource ON productionoperation.PROCESSUNITOID = processresource.OID AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)),
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONITEMQTYLINK productionop_proditq_link,
     OBJT_PRODUCTIONITEMQTY productionitq,
     OBJT_UOM uom
WHERE productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND productionoperation.OID = productionop_proditq_link.OPERATIONOID
AND productionop_proditq_link.ITEMQTYOID = productionitq.OID
AND productionitq.BOTYPE IN(0,5) -- PRIMARY (PHANTOM) OUTPUT
AND productionitq.UOMOID = uom.OID
/

-- MACHINEOPERATIONS --
CREATE OR REPLACE VIEW DCEREPORT_MACHINEOPERATIONS
AS
SELECT /*+ FIRST_ROWS(30) */  machineoperation.OID OID,
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
       CAST(GREATEST(machineoperation.DTSUPDATE, productiveitq.DTSUPDATE) AS DATE) DTSUPDATE
FROM OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link,
     OBJT_PRODUCTIVEITEMQTY productiveitq,
     OBJT_UOM uom
WHERE machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND machineoperation.OID = machineop_proditq_link.OPERATIONOID
AND machineop_proditq_link.ITEMQTYOID = productiveitq.OID
AND productiveitq.BOTYPE IN(0,5) -- PRIMARY (PHANTOM) OUTPUT
AND productiveitq.UOMOID = uom.OID
/

-- MACHINEOPERATION SEGMENTS --
CREATE OR REPLACE VIEW DCEREPORT_MACHINEOP_SEGMENTS
AS
SELECT /*+ FIRST_ROWS(30) */ operationsegment.OID OID,
       operationsegment.NAME NAME,
       operationsegment.DTSSTART DTSSTART,
       operationsegment.DTSSTOP DTSSTOP,
       operationsegment.DTSPLANNEDSTART DTSPLANNEDSTART,
       operationsegment.DTSPLANNEDSTOP DTSPLANNEDSTOP,
      CASE WHEN (operationsegment.OPERATIONOPTION = 0) THEN TRUNC(operationsegment.DURATION * NVL(uomconv.FACTOR, 1) * productiveitemqty.QTYTARGET, productiveitemqty.QTYFACTOR * productiveitemqty.QTYUNIT)
                 WHEN (operationsegment.OPERATIONOPTION IN (1, 3)) THEN TRUNC(operationsegment.DURATION * NVL(uomconv.FACTOR, 1) * productiveitemqty.QTYTARGET, operationsegment.TARGETDURATIONQTY)
            ELSE operationsegment.DURATION
            END AS TARGETDURATION,
       NVL(efficiencyparam.VALUE, 1) EFFICIENCY,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       operationsegment.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONSEGMENT operationsegment
     LEFT JOIN OBJT_UOM fromuom ON operationsegment.TARGETDURATIONUOMOID = fromuom.OID
     LEFT JOIN OBJT_UOM touom ON touom.NAME = 'millisecond'
     LEFT JOIN OBJT_UOMCONVERSION uomconv ON uomconv.FROMUOMOID = fromuom.OID AND uomconv.TOUOMOID = touom.OID
     LEFT JOIN OBJT_PARAMETER efficiencyparam ON efficiencyparam.OWNEROID = operationsegment.OID AND efficiencyparam.NAME = 'EFFICIENCY',
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONLINK machineop_segment_oplink,
     OBJT_OPERATIONITEMQTYLINK machineop_prodveitq_link,
     OBJT_PRODUCTIVEITEMQTY productiveitemqty
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
/

-- DIRECT TASK SEGMENTS --
CREATE OR REPLACE VIEW DCEREPORT_DIRECT_TASK_SEGMENTS
AS
SELECT /*+ FIRST_ROWS(30) */ operationsegment.OID OID,
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
        	WHEN (operationsegment.CLASSOID = 9000000000000091241) THEN NVL(manop_productiveitq.QTYSETUP, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091243) THEN NVL(manop_productiveitq.QTYLOAD, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091245) THEN NVL(manop_productiveitq.QTYRUN, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091247) THEN NVL(manop_productiveitq.QTYUNLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091239) THEN NVL(manop_productiveitq.QTYRESET, 0)
       END AS QTY,
       CASE
          WHEN (operationsegment.CLASSOID = 9000000000000091241) THEN NVL(manop_scrapitq.QTYSETUP, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091243) THEN NVL(manop_scrapitq.QTYLOAD, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091245) THEN NVL(manop_scrapitq.QTYRUN, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091247) THEN NVL(manop_scrapitq.QTYUNLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091239) THEN NVL(manop_scrapitq.QTYRESET, 0)
       END AS QTYREJECTED,
       CASE
          WHEN (operationsegment.CLASSOID = 9000000000000091241) THEN NVL(manop_reworkitq.QTYSETUP, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091243) THEN NVL(manop_reworkitq.QTYLOAD, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091245) THEN NVL(manop_reworkitq.QTYRUN, 0)
        	WHEN (operationsegment.CLASSOID = 9000000000000091247) THEN NVL(manop_reworkitq.QTYUNLOAD, 0)
          WHEN (operationsegment.CLASSOID = 9000000000000091239) THEN NVL(manop_reworkitq.QTYRESET, 0)
       END AS QTYREWORKED,
       uom.SYMBOL UOM,
       manoperation.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONSEGMENT operationsegment,
     ((OBJT_MANOPERATION manoperation
      LEFT JOIN OBJT_OPERATIONITEMQTYLINK manop_proditq_link ON manop_proditq_link.OPERATIONOID = manoperation.OID AND manop_proditq_link.ITEMQTYCLASSNAME = 'objt.mes.bo.productionmgt.ProductiveItemQty')
        LEFT JOIN OBJT_PRODUCTIVEITEMQTY manop_productiveitq ON manop_proditq_link.ITEMQTYOID = manop_productiveitq.OID)
          LEFT JOIN OBJT_SCRAPITEMQTY manop_scrapitq ON manop_productiveitq.SCRAPITEMQTYOID = manop_scrapitq.OID
          LEFT JOIN OBJT_REWORKITEMQTY manop_reworkitq ON manop_productiveitq.REWORKITEMQTYOID = manop_reworkitq.OID,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT workcenter,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONLINK manop_segment_oplink,
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link,
     OBJT_PRODUCTIVEITEMQTY machineop_productiveitq,
     OBJT_UOM uom
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
/

-- PRODUCTIONOPERATION QTIES --
-- Displays all the INPUT/OUTPUT productionitemqties of the different productionoperations
CREATE OR REPLACE VIEW DCEREPORT_PRODUCTIONOP_QTIES
AS
SELECT /*+ FIRST_ROWS(30) */ productionitq.OID OID,
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
FROM OBJT_PRODUCTIONITEMQTY productionitq,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONITEMQTYLINK prodop_proditq_link,
     OBJT_UOM uom
WHERE productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND productionoperation.OID = prodop_proditq_link.OPERATIONOID
AND prodop_proditq_link.ITEMQTYOID = productionitq.OID
AND productionitq.UOMOID = uom.OID
/

-- MACHINEOPERATION QTIES --
-- Displays all the INPUT/OUTPUT shiftitemqties of the different machineoperations
CREATE OR REPLACE VIEW DCEREPORT_MACHINEOP_QTIES
AS
SELECT /*+ FIRST_ROWS(30) */ shiftitq.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       productionorder.ID PRODUCTIONORDER_ID,
       shiftitq.CALENDARSHIFTOID SHIFT_OID,
       shiftitq.ITEMOID ITEM_OID,
       CAST (CASE WHEN (shiftitq.BOTYPE = 0) THEN 'PRIMARY OUTPUT'
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
       CAST (CASE WHEN (shiftitq.BOTYPE IN(2,3)) THEN
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
FROM OBJT_SHIFTITEMQTY shiftitq
       LEFT JOIN OBJT_SCRAPITEMQTY scrapitq ON shiftitq.SCRAPITEMQTYOID = scrapitq.OID,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONITEMQTYLINK machineop_shiftitq_link,
     OBJT_OPERATIONITEMQTYLINK machineop_proditq_link,
     OBJT_PRODUCTIVEITEMQTY productiveitq,
     OBJT_ITEMQTYLINK productiveitq_shiftitq_link,
     OBJT_UOM uom
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
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
/

-- DIRECT TASK QTIES --
-- Displays all the INPUT/OUTPUT shiftitemqties of the different direct tasks
CREATE OR REPLACE VIEW DCEREPORT_DIRECT_TASK_QTIES
AS
SELECT /*+ FIRST_ROWS(30) */ shiftitq.OID OID,
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
       (NVL(scrapitq.VALUE, 0) - NVL(scrapitq.QTYREWORKED, 0)) QTYREJECT,
       NVL(scrapitq.VALUE, 0) QTYREJECTED,
       NVL(scrapitq.QTYSETUP, 0) QTYREJECTED_SETUP,
       NVL(scrapitq.QTYLOAD, 0) QTYREJECTED_LOAD,
       NVL(scrapitq.QTYRUN, 0) QTYREJECTED_RUN,
       NVL(scrapitq.QTYUNLOAD, 0) QTYREJECTED_UNLOAD,
       NVL(scrapitq.QTYRESET, 0) QTYREJECTED_RESET,
       shiftitq.QTYREWORKED QTYREWORKED,
       shiftitq.QTYREWORKABLE QTYREWORKABLE,
       shiftitq.QTYDIRECTREWORK QTYDIRECTREWORK,
       shiftitq.QTYINDIRECTREWORK QTYINDIRECTREWORK,
       uom.SYMBOL UOM,
       shiftitq.DTSUPDATE DTSUPDATE
FROM OBJT_SHIFTITEMQTY shiftitq
       LEFT JOIN OBJT_SCRAPITEMQTY scrapitq ON shiftitq.SCRAPITEMQTYOID = scrapitq.OID,
     OBJT_MANOPERATION manoperation,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT workcenter,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OPERATIONITEMQTYLINK manop_shiftitq_link,
     OBJT_OPERATIONITEMQTYLINK manop_proditq_link,
     OBJT_PRODUCTIVEITEMQTY productiveitq,
     OBJT_ITEMQTYLINK productiveitq_shiftitq_link,
     OBJT_UOM uom
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
/

-- SHIFTS --
CREATE OR REPLACE VIEW DCEREPORT_SHIFTS
AS
SELECT calendarshift.OID OID,
       templateshift.NAME NAME,
       templateshift.DESCRIPTION DESCRIPTION,
       calendarshift.DTSSTART DTSSTART,
       calendarshift.DTSSTOP DTSSTOP,
       calendarshift.ISPRODUCTIVE ISPRODUCTIVE,
       CAST(GREATEST(calendarshift.DTSUPDATE, templateshift.DTSUPDATE) AS DATE) DTSUPDATE,
       calendarshift.DTSUPDATE AS DTSUPDATE_1,
       templateshift.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_CALENDARSHIFT calendarshift,
     OBJT_SHIFT shift,
     OBJT_SHIFT templateshift
WHERE calendarshift.SHIFTOID = shift.OID
AND shift.TOID = templateshift.OID
/

-- OEE OPERATION REPORTS--
CREATE OR REPLACE VIEW DCEREPORT_OEEOPERATIONREPORTS
AS
SELECT /*+ FIRST_ROWS(30) */ oeeoperationreport.OID OID,
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
       CAST(CASE WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 0) THEN (oeeoperationreport.TARGETOUTPUTDURATION || ' ' || durationuom.SYMBOL || ' / cycle') -- cycletime
                 WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 1) THEN (oeeoperationreport.TARGETOUTPUTQTY || ' ' || uom.SYMBOL || ' / ' || CASE WHEN (oeeoperationreport.TARGETOUTPUTDURATION <> 1) THEN oeeoperationreport.TARGETOUTPUTDURATION || ' ' ELSE '' END || durationuom.SYMBOL) -- speed
                 WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 2) THEN (oeeoperationreport.TARGETOUTPUTQTY || ' ' || uom.SYMBOL || ' / ' || TO_CHAR(TRUNC(oeeoperationreport.TARGETOUTPUTDURATION / 1000 / 3600), 'FM999999990')  || ':' || TO_CHAR(TRUNC(MOD(oeeoperationreport.TARGETOUTPUTDURATION / 1000, 3600) / 60), 'FM00') || ':' || TO_CHAR(MOD(oeeoperationreport.TARGETOUTPUTDURATION / 1000, 60), 'FM00')) -- duration
                 WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 3) THEN (oeeoperationreport.TARGETOUTPUTDURATION || ' ' || durationuom.SYMBOL || ' / ' || oeeoperationreport.TARGETOUTPUTQTY || ' ' || uom.SYMBOL) -- rate
            END AS VARCHAR2(255)) AS TARGET_SPEED,
       CAST(CASE WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 0) THEN (oeeoperationreport.ACTUALOUTPUTDURATION || ' ' || durationuom.SYMBOL || ' / cycle') -- cycletime
                 WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 1) THEN (oeeoperationreport.ACTUALOUTPUTQTY || ' ' || uom.SYMBOL || ' / ' || CASE WHEN (oeeoperationreport.ACTUALOUTPUTDURATION <> 1) THEN oeeoperationreport.ACTUALOUTPUTDURATION || ' ' ELSE '' END || durationuom.SYMBOL) -- speed
                 WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 2) THEN (oeeoperationreport.ACTUALOUTPUTQTY || ' ' || uom.SYMBOL || ' / ' || TO_CHAR(TRUNC(oeeoperationreport.ACTUALOUTPUTDURATION / 1000 / 3600), 'FM999999990')  || ':' || TO_CHAR(TRUNC(MOD(oeeoperationreport.ACTUALOUTPUTDURATION / 1000, 3600) / 60), 'FM00') || ':' || TO_CHAR(MOD(oeeoperationreport.ACTUALOUTPUTDURATION / 1000, 60), 'FM00')) -- duration
                 WHEN (BITAND(oeeoperationreport.REPORTOPTION, 3) = 3) THEN (oeeoperationreport.ACTUALOUTPUTDURATION || ' ' || durationuom.SYMBOL || ' / ' || oeeoperationreport.ACTUALOUTPUTQTY || ' ' || uom.SYMBOL) -- rate
            END AS VARCHAR2(255)) AS ACTUAL_SPEED,
       oeeoperationreport.DTSUPDATE DTSUPDATE
FROM OBJT_OEEOPERATIONREPORT oeeoperationreport
     LEFT JOIN OBJT_UOM uom ON oeeoperationreport.UOMOID = uom.OID
     LEFT JOIN OBJT_UOM durationuom ON oeeoperationreport.OUTPUTDURATIONUOMOID = durationuom.OID,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_CALENDARSHIFT calendarshift
WHERE oeeoperationreport.OWNEROID = machineoperation.OID
AND oeeoperationreport.CALENDARSHIFTOID = calendarshift.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
/

-- OEE REPORTS --
CREATE OR REPLACE VIEW DCEREPORT_OEEREPORTS
AS
SELECT /*+ FIRST_ROWS(30) */ oeereport.OID OID,
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
FROM OBJT_OEEREPORT oeereport,
     OBJT_CALENDARSHIFT calendarshift,
     OBJT_UOM uom
WHERE oeereport.CALENDARSHIFTOID = calendarshift.OID
AND oeereport.UOMOID = uom.OID
/

-- PRODUCTIONORDERS --
CREATE OR REPLACE VIEW DCEREPORT_PRODUCTIONORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ productionorder.OID OID,
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
       CAST((SELECT customer.OID FROM OBJT_CUSTOMER customer, OBJT_ORDERRESOURCELINK productionorder_customerlink
                                 WHERE productionorder_customerlink.RESOURCEOID = customer.OID
                                 AND productionorder_customerlink.ORDEROID = productionorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS CUSTOMER_OID,
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
FROM OBJT_PRODUCTIONORDER productionorder,
     OBJT_RECIPEVARIANTVERSION recipevariantversion,
     OBJT_RECIPEVARIANT recipevariant,
     OBJT_RECIPE recipe,
     OBJT_VERSIONINFO versioninfo,
     OBJT_PRODUCTIONITEMQTY productionitemqty,
     OBJT_UOM uom
WHERE productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND productionorder.RECIPEOID = recipevariantversion.OID
AND recipevariantversion.RECIPEOID = recipevariant.OID
AND recipevariant.RECIPEOID = recipe.OID
AND recipevariantversion.VERSIONINFOOID = versioninfo.OID
AND productionitemqty.ORDEROID = productionorder.OID
AND productionitemqty.UOMOID = uom.OID
/

-- MES_EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_MES_EVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ event.OID OID,
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
FROM OBJT_EVENT event
WHERE event.CLASSOID = 9000000000000091563
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ event.OID OID,
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
FROM OBJT_OPERATIONINSTRUCTIONEVENT event
WHERE event.CLASSOID IN (9000000000000091647,9000000000000091625,9000000000000091653,9000000000000091659,9000000000000091662)
-- (MeasurementEvent,OperationInstructionEvent,CheckEvent,InputEvent,ProcessEvent)
/

-- DOCUMENTED INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_DOCUMENTEDINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimedocumentedinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
       runtimedocumentedinstruction.NAME NAME,
       runtimedocumentedinstruction.DESCRIPTION DESCRIPTION,
       runtimedocumentedinstruction.ID ID,
       documentedinstruction.INFOTEXT INFO,
       runtimedocumentedinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimedocumentedinstruction,
     OBJT_OPERATIONINSTRUCTION documentedinstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimedocumentedinstruction.CLASSOID = 9000000000000089962
AND runtimedocumentedinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
                WHERE runtimedocumentedinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimedocumentedinstruction.OPERATIONINSTRUCTIONOID = documentedinstruction.OID
AND documentedinstruction.CLASSOID = 9000000000000090054
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ runtimedocumentedinstruction.OID OID,
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
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimedocumentedinstruction,
     OBJT_OPERATIONINSTRUCTION documentedinstruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
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
/

-- INSTRUCTION DOCUMENTS --
CREATE OR REPLACE VIEW DCEREPORT_INSTRUCTIONDOCS
AS
SELECT /*+ FIRST_ROWS(30) */ document.OID OID,
       CAST(NVL(runtimeoperationinstruction.OID, operationinstruction.OID) AS NUMBER(19)) INSTRUCTION_OID,
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
FROM OBJT_DOCUMENT document,
     OBJT_OPERATIONINSTRUCTION operationinstruction
     LEFT JOIN OBJT_RUNTIMEOPERATIONINSTRUCT runtimeoperationinstruction
        ON (operationinstruction.OID = runtimeoperationinstruction.OPERATIONINSTRUCTIONOID
            AND runtimeoperationinstruction.CLASSOID IN (9000000000000089962, 9000000000000089972, 9000000000000089964, 9000000000000089954, 9000000000000089958)),
     OBJT_MANUFACTURINGOPERATION manufacturingoperation
WHERE document.OWNEROID = operationinstruction.OID
AND (operationinstruction.CLASSOID = 9000000000000090054
     OR (operationinstruction.CLASSOID IN (9000000000000090054, 9000000000000090127, 9000000000000090112, 9000000000000090097, 9000000000000090107))
         AND runtimeoperationinstruction.OID IS NOT NULL)
AND operationinstruction.OPERATIONOID = manufacturingoperation.OID
AND manufacturingoperation.STATUS = 2 -- SCHEDULED
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ document.OID OID,
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
FROM OBJT_DOCUMENT document,
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeoperationinstruction,
     OBJT_OPERATIONINSTRUCTION operationinstruction
     LEFT JOIN OBJT_MANUFACTURINGOPERATION manufacturingoperation
        ON (operationinstruction.OPERATIONOID = manufacturingoperation.OID)
WHERE document.OWNEROID = runtimeoperationinstruction.OID
AND runtimeoperationinstruction.CLASSOID IN (9000000000000089962, 9000000000000089972, 9000000000000089964, 9000000000000089954, 9000000000000089958)
AND runtimeoperationinstruction.OPERATIONINSTRUCTIONOID = operationinstruction.OID
AND operationinstruction.CLASSOID IN (9000000000000090054, 9000000000000090127, 9000000000000090112, 9000000000000090097, 9000000000000090107)
AND (manufacturingoperation.OID IS NULL OR manufacturingoperation.STATUS <> 2) -- NOT SCHEDULED
/

-- DOCUMENT EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_DOCUMENTEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ documentevent.OID OID,
       documentevent.OPERATIONINSTRUCTIONOID INSTRUCTION_OID,
       document.OID DOCUMENT_OID,
       documentevent.EMPLOYEEOID EMPLOYEE_OID,
       documentevent.DEVICEOID DEVICE_OID,
       documentevent.CATEGORY CATEGORY,
       documentevent.DTS DTS,
       documentevent.COMMENTS COMMENTS,
       documentevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       documentevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT documentevent,
     OBJT_DOCUMENT document
WHERE documentevent.CLASSOID = 9000000000000091650
AND documentevent.REFOID = document.OID
/

-- PROCESS SETUP INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_SETUPINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimeprocessinstruction.oid OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
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
       CASE WHEN (BITAND(setupparameter.EDITMODE, 1) = 1) THEN 'T' ELSE 'F' END AS TARGETEDITABLE,
       setupparameter.QTYHIGH UPPER_SETUP_LIMIT,
       setupparameter.QTYLOW LOWER_SETUP_LIMIT,
       CAST(uom.SYMBOL AS VARCHAR2(32 CHAR)) UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PROCESSPARAMETER setupparameter
        LEFT JOIN OBJT_UOM uom ON setupparameter.UOMOID = uom.OID
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND setupparameter.CLASSOID = 9000000000000093109
AND runtimeprocessinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
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
SELECT /*+ FIRST_ROWS(30) */ runtimeprocessinstruction.oid OID,
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
       CASE WHEN (BITAND(setupparameter.EDITMODE, 1) = 1) THEN 'T' ELSE 'F' END AS TARGETEDITABLE,
       setupparameter.QTYHIGH UPPER_SETUP_LIMIT,
       setupparameter.QTYLOW LOWER_SETUP_LIMIT,
       CAST(uom.SYMBOL AS VARCHAR2(32 CHAR)) UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PROCESSPARAMETER setupparameter
        LEFT JOIN OBJT_UOM uom ON setupparameter.UOMOID = uom.OID
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
SELECT /*+ FIRST_ROWS(30) */ runtimeprocessinstruction.oid OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
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
       CASE WHEN (BITAND(setupparameter.EDITMODE, 1) = 1) THEN 'T' ELSE 'F' END AS TARGETEDITABLE,
       NULL UPPER_SETUP_LIMIT,
       NULL LOWER_SETUP_LIMIT,
       CAST('' AS VARCHAR2(32 CHAR)) UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PROCESSPARAMETER setupparameter
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND setupparameter.CLASSOID = 9000000000000093126 -- TextParameter --
AND runtimeprocessinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
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
SELECT /*+ FIRST_ROWS(30) */ runtimeprocessinstruction.oid OID,
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
       CASE WHEN (BITAND(setupparameter.EDITMODE, 1) = 1) THEN 'T' ELSE 'F' END AS TARGETEDITABLE,
       NULL UPPER_SETUP_LIMIT,
       NULL LOWER_SETUP_LIMIT,
       CAST('' AS VARCHAR2(32 CHAR)) UOM,
       runtimeprocessinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprocessinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprocessinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PROCESSPARAMETER setupparameter
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
/

-- PROCESS SETUP EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_SETUPEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ processevent.OID OID,
       processevent.OPERATIONINSTRUCTIONOID SETUPINSTRUCTION_OID, 
       setupparameter.OID SETUPPARAMETER_OID,
       processevent.EMPLOYEEOID EMPLOYEE_OID,
       processevent.DEVICEOID DEVICE_OID,
       processevent.VALUE VALUE,
       CAST(uom.symbol AS VARCHAR2(32 CHAR)) UOM,
       processevent.DTS DTS,
       processevent.DESCRIPTION DESCRIPTION,
       processevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       processevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT processevent,
     OBJT_PROCESSPARAMETER setupparameter
        LEFT JOIN OBJT_UOM uom ON setupparameter.UOMOID = uom.OID,
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction
WHERE processevent.CLASSOID = 9000000000000091662
AND setupparameter.CLASSOID = 9000000000000093109
AND processevent.REFOID = setupparameter.OID
AND processevent.OPERATIONINSTRUCTIONOID = runtimeprocessinstruction.OID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.INSTRUCTIONMODE = 0
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ processevent.OID OID,
       processevent.OPERATIONINSTRUCTIONOID SETUPINSTRUCTION_OID,
       setupparameter.OID SETUPPARAMETER_OID,
       processevent.EMPLOYEEOID EMPLOYEE_OID,
       processevent.DEVICEOID DEVICE_OID,
       processevent.VALUE VALUE,
       CAST('' AS VARCHAR2(32 CHAR)) UOM,
       processevent.DTS DTS,
       processevent.DESCRIPTION DESCRIPTION,
       processevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       processevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT processevent,
     OBJT_PROCESSPARAMETER setupparameter,
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction
WHERE processevent.CLASSOID = 9000000000000091662
AND setupparameter.CLASSOID = 9000000000000093126 -- TextParameter --
AND processevent.REFOID = setupparameter.OID
AND processevent.OPERATIONINSTRUCTIONOID = runtimeprocessinstruction.OID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.INSTRUCTIONMODE = 0
/

-- PROCESS DATA COLLECTION INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_DATACOLLECTIONINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimeprocessinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
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
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PROCESSPARAMETER processparameter,
     OBJT_UOM uom
WHERE runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND processparameter.CLASSOID = 9000000000000093109
AND runtimeprocessinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
                WHERE runtimeprocessinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 1 -- DATA_COLLECTION
AND runtimeprocessinstruction.OID = processparameter.OWNEROID
AND processparameter.UOMOID = uom.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ runtimeprocessinstruction.OID OID,
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
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PROCESSPARAMETER processparameter,
     OBJT_UOM uom
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
/

-- PROCESS DATA COLLECTION EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_DATACOLLECTIONEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ processevent.OID OID,
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
FROM OBJT_OPERATIONINSTRUCTIONEVENT processevent,
     OBJT_PROCESSPARAMETER processparameter,
     OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprocessinstruction,
     OBJT_OPERATIONINSTRUCTION processinstruction,
     OBJT_UOM uom
WHERE processevent.CLASSOID = 9000000000000091662
AND processparameter.CLASSOID = 9000000000000093109
AND processevent.REFOID = processparameter.OID
AND processevent.OPERATIONINSTRUCTIONOID = runtimeprocessinstruction.OID
AND runtimeprocessinstruction.CLASSOID = 9000000000000089972
AND runtimeprocessinstruction.OPERATIONINSTRUCTIONOID = processinstruction.OID
AND processinstruction.CLASSOID = 9000000000000090127
AND processinstruction.INSTRUCTIONMODE = 1 -- DATA_COLLECTION
AND processparameter.UOMOID = uom.OID
/

-- MEASUREMENT INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_MEASUREMENTINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimemeasurementinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
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
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimemeasurementinstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_MEASUREMENT measurement,
     OBJT_UOM uom
WHERE runtimemeasurementinstruction.CLASSOID = 9000000000000089964
AND runtimemeasurementinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
                WHERE runtimemeasurementinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND runtimemeasurementinstruction.OID = measurement.OWNEROID
AND measurement.CLASSOID = 9000000000000093063
AND measurement.UOMOID = uom.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ runtimemeasurementinstruction.OID OID,
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
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimemeasurementinstruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_MEASUREMENT measurement,
     OBJT_UOM uom
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
/

-- MEASUREMENT EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_MEASUREMENTEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ measurementevent.OID OID,
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
FROM OBJT_OPERATIONINSTRUCTIONEVENT measurementevent,
     OBJT_MEASUREMENT measurement,
     OBJT_UOM uom
WHERE measurementevent.CLASSOID = 9000000000000091647
AND measurementevent.REFOID = measurement.OID
AND measurement.CLASSOID = 9000000000000093063
AND measurement.UOMOID = uom.OID
/

-- INPUT INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_INPUTINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimeinputinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
       runtimeinputinstruction.NAME NAME,
       runtimeinputinstruction.DESCRIPTION DESCRIPTION,
       runtimeinputinstruction.ID ID,
       runtimeinputinstruction.INPUTVALUE VALUE,
       runtimeinputinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinputinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinputinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinputinstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimeinputinstruction.CLASSOID = 9000000000000089954
AND runtimeinputinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
                WHERE runtimeinputinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.CLASSOID = 9000000000000085787
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ runtimeinputinstruction.OID OID,
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
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinputinstruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimeinputinstruction.CLASSOID = 9000000000000089954
AND runtimeinputinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
/

-- INPUT EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_INPUTEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ inputevent.OID OID,
       inputevent.OPERATIONINSTRUCTIONOID INPUTINSTRUCTION_OID,
       inputevent.EMPLOYEEOID EMPLOYEE_OID,
       inputevent.DEVICEOID DEVICE_OID,
       inputevent.VALUE VALUE,
       inputevent.COMMENTS COMMENTS,
       inputevent.DTS DTS,
       inputevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       inputevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT inputevent
WHERE inputevent.CLASSOID = 9000000000000091659
/

-- CHECK INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_CHECKINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimecheckinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
       runtimecheckinstruction.NAME NAME,
       runtimecheckinstruction.DESCRIPTION DESCRIPTION,
       runtimecheckinstruction.ID ID,
       runtimecheckinstruction.VALUE VALUE,
       CAST(CASE WHEN (BITAND(instruction.INSTRUCTIONOPTION, 4) = 4) THEN 1 ELSE 0 END AS NUMBER(10)) AS INPUTTYPE, -- 0 = YES/NO, 1 = OK/NOK
       runtimecheckinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimecheckinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimecheckinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimecheckinstruction,
     OBJT_OPERATIONINSTRUCTION instruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimecheckinstruction.CLASSOID = 9000000000000089958
AND runtimecheckinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
                WHERE runtimecheckinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND runtimecheckinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ runtimecheckinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.OID INSTRUCTIONSHEET_OID,
       runtimecheckinstruction.NAME NAME,
       runtimecheckinstruction.DESCRIPTION DESCRIPTION,
       runtimecheckinstruction.ID ID,
       runtimecheckinstruction.VALUE VALUE,
       CAST(CASE WHEN (BITAND(instruction.INSTRUCTIONOPTION, 4) = 4) THEN 1 ELSE 0 END AS NUMBER(10)) AS INPUTTYPE, -- 0 = YES/NO, 1 = OK/NOK
       runtimecheckinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimecheckinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimecheckinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimecheckinstruction,
     OBJT_OPERATIONINSTRUCTION instruction,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimecheckinstruction.CLASSOID = 9000000000000089958
AND runtimecheckinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND runtimecheckinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
/

-- CHECK EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_CHECKEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ checkevent.OID OID,
       checkevent.OPERATIONINSTRUCTIONOID CHECKINSTRUCTION_OID,
       checkevent.EMPLOYEEOID EMPLOYEE_OID,
       checkevent.DEVICEOID DEVICE_OID,
       checkevent.VALUE VALUE,
       checkevent.COMMENTS COMMENTS,
       checkevent.DTS DTS,
       checkevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       checkevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT checkevent
WHERE checkevent.CLASSOID = 9000000000000091653
/

-- PRINT INSTRUCTIONS --
CREATE OR REPLACE VIEW DCEREPORT_PRINTINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimeprintinstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST(NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
       runtimeprintinstruction.NAME NAME,
       runtimeprintinstruction.DESCRIPTION DESCRIPTION,
       runtimeprintinstruction.ID ID,
       documenttemplate.NAME DOCUMENT_NAME,
       documenttemplate.DESCRIPTION DOCUMENT_DESCRIPTION,
       runtimeprintinstruction.COPIES COPIES,
       CASE WHEN (BITAND(runtimeprintinstruction.INSTRUCTIONOPTION, 1) = 1) THEN 'T' ELSE 'F' END AS COPIESFIXED,
       runtimeprintinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprintinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprintinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprintinstruction,
     OBJT_DOCUMENTTEMPLATE documenttemplate,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimeprintinstruction.CLASSOID = 9000000000000089966
AND runtimeprintinstruction.DOCUMENTTEMPLATEOID = documenttemplate.OID
AND runtimeprintinstruction.OPERATIONOID = machineoperation.OID
AND NOT EXISTS (SELECT instructionsheetlink.OID FROM OBJT_INSTRUCTIONLINK instructionsheetlink
                WHERE runtimeprintinstruction.OID = instructionsheetlink.CHILDOID)
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ runtimeprintinstruction.OID OID,
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
       CASE WHEN (BITAND(runtimeprintinstruction.INSTRUCTIONOPTION, 1) = 1) THEN 'T' ELSE 'F' END AS COPIESFIXED,
       runtimeprintinstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeprintinstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeprintinstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeprintinstruction,
     OBJT_DOCUMENTTEMPLATE documenttemplate,
     OBJT_INSTRUCTIONLINK instructionsheetlink,
     OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimeprintinstruction.CLASSOID = 9000000000000089966
AND runtimeprintinstruction.DOCUMENTTEMPLATEOID = documenttemplate.OID
AND runtimeprintinstruction.OID = instructionsheetlink.CHILDOID
AND instructionsheetlink.PARENTOID = runtimeinstructionsheet.OID
AND runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
/

-- PRINT EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_PRINTEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ printevent.OID OID,
       printevent.OPERATIONINSTRUCTIONOID PRINTINSTRUCTION_OID,
       printevent.EMPLOYEEOID EMPLOYEE_OID,
       printevent.DEVICEOID DEVICE_OID,
       printevent.COMMENTS COMMENTS,
       printevent.DTS DTS,
       printevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       printevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT printevent
WHERE printevent.CLASSOID = 9000000000000091644
/

-- INSPECTION INSTRUCTIONS --
CREATE OR REPLACE VIEW OBJTREP_INSPECTIONINSTR
AS
SELECT /*+ FIRST_ROWS(30) */ runtimeinspectioninstruction.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST (NULL AS NUMBER(19)) INSTRUCTIONSHEET_OID,
       runtimeinspectioninstruction.NAME NAME,
       runtimeinspectioninstruction.DESCRIPTION DESCRIPTION,
       runtimeinspectioninstruction.ID ID,
       runtimeinspectioninstruction.CATEGORY INSPECTIONTYPE,
	     runtimeinspectioninstruction.RUNTIMEINSPECTIONSHEETOID INSPECTIONSHEETOID,
       runtimeinspectioninstruction.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinspectioninstruction.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinspectioninstruction.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinspectioninstruction,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimeinspectioninstruction.CLASSOID = 9010000000000000015
AND ((runtimeinspectioninstruction.TOID <> -1) OR (runtimeinspectioninstruction.TOID IS NULL))
AND runtimeinspectioninstruction.OPERATIONOID = machineoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
/

-- INSPECTION EVENT --
CREATE OR REPLACE VIEW OBJTREP_INSPECTIONEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ inspectionevent.OID OID,
       inspectionevent.OPERATIONINSTRUCTIONOID INSPECTIONINSTRUCTION_OID,
       inspectionevent.EMPLOYEEOID EMPLOYEE_OID,
       inspectionevent.DEVICEOID DEVICE_OID,
       inspectionevent.COMMENTS COMMENTS,
       inspectionevent.DTS DTS,
       inspectionevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       inspectionevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT inspectionevent
WHERE inspectionevent.CLASSOID = 9010000000000000018
/

-- DCEREPORT_INSTRUCTIONSHEETS --
CREATE OR REPLACE VIEW DCEREPORT_INSTRUCTIONSHEETS
AS
SELECT /*+ FIRST_ROWS(30) */ runtimeinstructionsheet.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       runtimeinstructionsheet.NAME NAME,
       runtimeinstructionsheet.DESCRIPTION DESCRIPTION,
       runtimeinstructionsheet.ID ID,
       CAST(CASE WHEN (runtimeinstructionsheet.STATUS IN (0, 2, 3)) THEN 'OPEN'
                 WHEN (runtimeinstructionsheet.STATUS = 11) THEN 'FINISHED'
                 WHEN (runtimeinstructionsheet.STATUS = 4) THEN CASE WHEN (BITAND(runtimeinstructionsheet.INSTRUCTIONOPTION, 2) = 2) THEN 'VERIFIED' ELSE 'FINISHED' END
                 WHEN (runtimeinstructionsheet.STATUS = 13) THEN 'CLOSED' END AS VARCHAR2(8)) AS STATUS,
       CASE WHEN (BITAND(runtimeinstructionsheet.INSTRUCTIONOPTION, 1) = 1) THEN 'T' ELSE 'F' END AS QUALITYSHEET,
       CASE WHEN (BITAND(runtimeinstructionsheet.INSTRUCTIONOPTION, 2) = 2) THEN 'T' ELSE 'F' END AS DOUBLESIGNOFF,
       CASE WHEN (BITAND(runtimeinstructionsheet.INSTRUCTIONOPTION, 4) = 4) THEN 'T' ELSE 'F' END AS TAKEOFFSHEET,
       runtimeinstructionsheet.DTSLASTEXECUTE DTSLASTEXECUTED,
       runtimeinstructionsheet.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       runtimeinstructionsheet.DTSUPDATE DTSUPDATE
FROM OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstructionsheet,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder
WHERE runtimeinstructionsheet.OPERATIONOID = machineoperation.OID
AND ((runtimeinstructionsheet.TOID <> -1) OR (runtimeinstructionsheet.TOID IS NULL))
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
/

-- INSTRUCTION TASKS --
CREATE OR REPLACE VIEW DCEREPORT_INSTRUCTIONTASKS
AS
SELECT /*+ FIRST_ROWS(30) */ instructiontask.OID OID,
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
FROM OBJT_INSTRUCTIONTASK instructiontask,		
		 OBJT_RUNTIMEOPERATIONINSTRUCT runtimeinstruction,
     OBJT_OPERATIONINSTRUCTION instruction
WHERE runtimeinstruction.OID = instructiontask.OPERATIONINSTRUCTIONOID
AND runtimeinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ instructiontask.OID OID,
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
FROM OBJT_INSTRUCTIONTASK instructiontask,
		 OBJT_RUNTIMEINSTRUCTIONSHEET runtimeinstruction,
     OBJT_OPERATIONINSTRUCTION instruction
WHERE runtimeinstruction.OID = instructiontask.OPERATIONINSTRUCTIONOID
AND runtimeinstruction.OPERATIONINSTRUCTIONOID = instruction.OID
/

-- SHEET EVENTS --
CREATE OR REPLACE VIEW DCEREPORT_SHEETEVENTS
AS
SELECT /*+ FIRST_ROWS(30) */ sheetevent.OID OID,
       sheetevent.OPERATIONINSTRUCTIONOID INSTRUCTIONSHEET_OID,
       sheetevent.EMPLOYEEOID EMPLOYEE_OID,
       sheetevent.DEVICEOID DEVICE_OID,
       sheetevent.CATEGORY CATEGORY,
       sheetevent.COMMENTS COMMENTS,
       sheetevent.DTS DTS,
       sheetevent.RESULT RESULT, -- 0 = OK, 1 = WARNING or 2 = ERROR
       sheetevent.DTSUPDATE DTSUPDATE
FROM OBJT_OPERATIONINSTRUCTIONEVENT sheetevent
WHERE sheetevent.CLASSOID = 9000000000000091656
/

-- INPUT TARGETS --
CREATE OR REPLACE VIEW DCEREPORT_INPUT_TARGETS
AS
SELECT /*+ FIRST_ROWS(30) */ target_inputop.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST((SELECT location.OID FROM OBJT_WAREHOUSELOCATION location, OBJT_OPERATIONRESOURCELINK inputop_location_link
                            WHERE inputop_location_link.RESOURCEOID = location.OID
                            AND inputop_location_link.OPERATIONOID = target_inputop.OID AND ROWNUM = 1) AS NUMBER(19)) AS LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inputitemqty.QTYTARGET TARGET,
       inputitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       target_inputop.DTSSTART DTSSTART,
       target_inputop.DTSSTOP DTSSTOP,
       CAST(GREATEST(target_inputop.DTSUPDATE, inputitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       target_inputop.DTSUPDATE AS DTSUPDATE_1,
       inputitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_INPUTOPERATION target_inputop,
     OBJT_OPERATIONLINK inputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_INPUTITEMQTY inputitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
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
/

-- INPUT ACTUALS --
CREATE OR REPLACE VIEW DCEREPORT_INPUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ input_inventorytraceop.OID OID,
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
FROM OBJT_INVENTORYTRACEOPERATION input_inventorytraceop,
     OBJT_OPERATIONLINK inputoperation_link,
     OBJT_INPUTOPERATION target_inputop,
     OBJT_OPERATIONLINK inputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_LOT lot,
     OBJT_UOM uom
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
/

-- OUTPUT TARGETS --
CREATE OR REPLACE VIEW DCEREPORT_OUTPUT_TARGETS
AS
SELECT /*+ FIRST_ROWS(30) */ target_outputop.OID OID,
       processresource.OID PROCESSRESOURCE_OID,
       machineoperation.OID MACHINEOPERATION_OID,
       productionoperation.OID PRODUCTIONOPERATION_OID,
       productionorder.OID PRODUCTIONORDER_OID,
       CAST((SELECT location.OID FROM OBJT_WAREHOUSELOCATION location, OBJT_OPERATIONRESOURCELINK outputop_location_link
                            WHERE outputop_location_link.RESOURCEOID = location.OID
                            AND outputop_location_link.OPERATIONOID = target_outputop.OID AND ROWNUM = 1) AS NUMBER(19)) AS LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       outputitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       target_outputop.DTSSTART DTSSTART,
       target_outputop.DTSSTOP DTSSTOP,
       CAST(GREATEST(target_outputop.DTSUPDATE, outputitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       target_outputop.DTSUPDATE AS DTSUPDATE_1,
       outputitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_OUTPUTOPERATION target_outputop,
     OBJT_OPERATIONLINK outputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_OUTPUTITEMQTY outputitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
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
/

-- OUTPUT ACTUALS --
CREATE OR REPLACE VIEW DCEREPORT_OUTPUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ output_inventorytraceop.OID OID,
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
     OBJT_OPERATIONLINK outputoperation_link,
     OBJT_OUTPUTOPERATION target_outputop,
     OBJT_OPERATIONLINK outputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE output_inventorytraceop.BOTYPE = 3 -- OUTPUT
AND output_inventorytraceop.OID = outputoperation_link.CHILDOID
AND outputoperation_link.PARENTOID = target_outputop.OID
AND target_outputop.BOTYPE = 0 -- TARGET
AND target_outputop.OID = outputop_machineop_link.CHILDOID
AND outputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE IN(0,1) -- TYPE_MES_PRODUCTION/TYPE_MES_TEST --
AND output_inventorytraceop.UOMOID = uom.OID
AND output_inventorytraceop.LOTOID = lot.OID
/