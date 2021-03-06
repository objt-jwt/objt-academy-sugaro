-- Oracle WMS views --

-- LOGISTICS MGT VIEWS --

-- DEVICE LOGINS (ISPRESENTOPERATIONS) --

CREATE OR REPLACE VIEW DCEREPORT_DEVICE_LOGINS
AS
SELECT /*+ FIRST_ROWS(30) */ ispresentoperation.OID OID,
       employee.OID EMPLOYEE_OID,
       device.OID DEVICE_OID,
       ispresentoperation.DTSSTART DTSSTART,
       ispresentoperation.DTSSTOP DTSSTOP,
       ispresentoperation.DTSUPDATE DTSUPDATE
FROM OBJT_ISPRESENTOPERATION ispresentoperation,
     OBJT_EMPLOYEE employee,
     OBJT_DEVICE device
WHERE ispresentoperation.EMPLOYEEOID = employee.OID
AND ispresentoperation.DEVICEOID = device.OID
/

-- INBOUNDORDERS --

CREATE OR REPLACE VIEW DCEREPORT_INBOUNDORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ inboundorder.OID OID,
       inboundorder.NAME NAME,
       inboundorder.ID ID,
       inboundorder.DESCRIPTION DESCRIPTION,
       CASE WHEN (inboundorder.BOTYPE IN (0,2)) THEN 'RECEIPT'
            WHEN (inboundorder.BOTYPE = 1) THEN 'RETURN' END AS TYPE,
       CAST((SELECT supplier.OID FROM OBJT_SUPPLIER supplier, OBJT_ORDERRESOURCELINK inboundorder_supplier_link
                                 WHERE inboundorder_supplier_link.RESOURCEOID = supplier.OID
                                 AND inboundorder_supplier_link.ORDEROID = inboundorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS SUPPLIER_OID,
       CAST((SELECT customer.OID FROM OBJT_CUSTOMER customer, OBJT_ORDERRESOURCELINK inboundorder_customer_link
                                 WHERE inboundorder_customer_link.RESOURCEOID = customer.OID
                                 AND inboundorder_customer_link.ORDEROID = inboundorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS CUSTOMER_OID,
       CAST((SELECT carrier.OID  FROM OBJT_CARRIER carrier, OBJT_ORDERRESOURCELINK inboundorder_carrier_link
                                 WHERE inboundorder_carrier_link.RESOURCEOID = carrier.OID
                                 AND inboundorder_carrier_link.ORDEROID = inboundorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS CARRIER_OID,
       CAST((SELECT location.OID FROM OBJT_WAREHOUSELOCATION location, OBJT_ORDERRESOURCELINK inboundorder_location_link
                                 WHERE inboundorder_location_link.RESOURCEOID = location.OID
                                 AND inboundorder_location_link.ORDEROID = inboundorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS TO_LOCATION_OID,
       inboundorder.STATUS STATUS,
       inboundorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       inboundorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       inboundorder.DTSDUEBEFORE DTSDUEBEFORE,
       inboundorder.DTSSTART DTSSTART,
       inboundorder.DTSSTOP DTSSTOP,
       inboundorder.DTSUPDATE DTSUPDATE,
       inboundorder.USRDTS1 USRDTS1,
       inboundorder.USRDTS2 USRDTS2,
       inboundorder.USRDTS3 USRDTS3,
       inboundorder.USRDTS4 USRDTS4,
       inboundorder.USRDTS5 USRDTS5,
       inboundorder.USRDTS6 USRDTS6,
       inboundorder.USRDTS7 USRDTS7,
       inboundorder.USRDTS8 USRDTS8,
       inboundorder.USRDTS9 USRDTS9,
       inboundorder.USRDTS10 USRDTS10,
       inboundorder.USRDTS11 USRDTS11,
       inboundorder.USRDTS12 USRDTS12,
       inboundorder.USRDTS13 USRDTS13,
       inboundorder.USRDTS14 USRDTS14,
       inboundorder.USRDTS15 USRDTS15,
       inboundorder.USRDTS16 USRDTS16,
       inboundorder.USRDTS17 USRDTS17,
       inboundorder.USRDTS18 USRDTS18,
       inboundorder.USRDTS19 USRDTS19,
       inboundorder.USRDTS20 USRDTS20,
       inboundorder.USRDTS21 USRDTS21,
       inboundorder.USRDTS22 USRDTS22,
       inboundorder.USRDTS23 USRDTS23,
       inboundorder.USRDTS24 USRDTS24,
       inboundorder.USRDTS25 USRDTS25,
       inboundorder.USRDTS26 USRDTS26,
       inboundorder.USRDTS27 USRDTS27,
       inboundorder.USRDTS28 USRDTS28,
       inboundorder.USRDTS29 USRDTS29,
       inboundorder.USRDTS30 USRDTS30,
       inboundorder.USRFLG1 USRFLG1,
       inboundorder.USRFLG2 USRFLG2,
       inboundorder.USRFLG3 USRFLG3,
       inboundorder.USRFLG4 USRFLG4,
       inboundorder.USRFLG5 USRFLG5,
       inboundorder.USRFLG6 USRFLG6,
       inboundorder.USRFLG7 USRFLG7,
       inboundorder.USRFLG8 USRFLG8,
       inboundorder.USRFLG9 USRFLG9,
       inboundorder.USRFLG10 USRFLG10,
       inboundorder.USRFLG11 USRFLG11,
       inboundorder.USRFLG12 USRFLG12,
       inboundorder.USRFLG13 USRFLG13,
       inboundorder.USRFLG14 USRFLG14,
       inboundorder.USRFLG15 USRFLG15,
       inboundorder.USRFLG16 USRFLG16,
       inboundorder.USRFLG17 USRFLG17,
       inboundorder.USRFLG18 USRFLG18,
       inboundorder.USRFLG19 USRFLG19,
       inboundorder.USRFLG20 USRFLG20,
       inboundorder.USRFLG21 USRFLG21,
       inboundorder.USRFLG22 USRFLG22,
       inboundorder.USRFLG23 USRFLG23,
       inboundorder.USRFLG24 USRFLG24,
       inboundorder.USRFLG25 USRFLG25,
       inboundorder.USRFLG26 USRFLG26,
       inboundorder.USRFLG27 USRFLG27,
       inboundorder.USRFLG28 USRFLG28,
       inboundorder.USRFLG29 USRFLG29,
       inboundorder.USRFLG30 USRFLG30,
       inboundorder.USRNUM1 USRNUM1,
       inboundorder.USRNUM2 USRNUM2,
       inboundorder.USRNUM3 USRNUM3,
       inboundorder.USRNUM4 USRNUM4,
       inboundorder.USRNUM5 USRNUM5,
       inboundorder.USRNUM6 USRNUM6,
       inboundorder.USRNUM7 USRNUM7,
       inboundorder.USRNUM8 USRNUM8,
       inboundorder.USRNUM9 USRNUM9,
       inboundorder.USRNUM10 USRNUM10,
       inboundorder.USRNUM11 USRNUM11,
       inboundorder.USRNUM12 USRNUM12,
       inboundorder.USRNUM13 USRNUM13,
       inboundorder.USRNUM14 USRNUM14,
       inboundorder.USRNUM15 USRNUM15,
       inboundorder.USRNUM16 USRNUM16,
       inboundorder.USRNUM17 USRNUM17,
       inboundorder.USRNUM18 USRNUM18,
       inboundorder.USRNUM19 USRNUM19,
       inboundorder.USRNUM20 USRNUM20,
       inboundorder.USRNUM21 USRNUM21,
       inboundorder.USRNUM22 USRNUM22,
       inboundorder.USRNUM23 USRNUM23,
       inboundorder.USRNUM24 USRNUM24,
       inboundorder.USRNUM25 USRNUM25,
       inboundorder.USRNUM26 USRNUM26,
       inboundorder.USRNUM27 USRNUM27,
       inboundorder.USRNUM28 USRNUM28,
       inboundorder.USRNUM29 USRNUM29,
       inboundorder.USRNUM30 USRNUM30,
       inboundorder.USRNUM31 USRNUM31,
       inboundorder.USRNUM32 USRNUM32,
       inboundorder.USRNUM33 USRNUM33,
       inboundorder.USRNUM34 USRNUM34,
       inboundorder.USRNUM35 USRNUM35,
       inboundorder.USRNUM36 USRNUM36,
       inboundorder.USRNUM37 USRNUM37,
       inboundorder.USRNUM38 USRNUM38,
       inboundorder.USRNUM39 USRNUM39,
       inboundorder.USRNUM40 USRNUM40,
       inboundorder.USRNUM41 USRNUM41,
       inboundorder.USRNUM42 USRNUM42,
       inboundorder.USRNUM43 USRNUM43,
       inboundorder.USRNUM44 USRNUM44,
       inboundorder.USRNUM45 USRNUM45,
       inboundorder.USRNUM46 USRNUM46,
       inboundorder.USRNUM47 USRNUM47,
       inboundorder.USRNUM48 USRNUM48,
       inboundorder.USRNUM49 USRNUM49,
       inboundorder.USRNUM50 USRNUM50,
       inboundorder.USRNUM51 USRNUM51,
       inboundorder.USRNUM52 USRNUM52,
       inboundorder.USRNUM53 USRNUM53,
       inboundorder.USRNUM54 USRNUM54,
       inboundorder.USRNUM55 USRNUM55,
       inboundorder.USRNUM56 USRNUM56,
       inboundorder.USRNUM57 USRNUM57,
       inboundorder.USRNUM58 USRNUM58,
       inboundorder.USRNUM59 USRNUM59,
       inboundorder.USRNUM60 USRNUM60,
       inboundorder.USRNUM61 USRNUM61,
       inboundorder.USRNUM62 USRNUM62,
       inboundorder.USRNUM63 USRNUM63,
       inboundorder.USRNUM64 USRNUM64,
       inboundorder.USRNUM65 USRNUM65,
       inboundorder.USRTXT1 USRTXT1,
       inboundorder.USRTXT2 USRTXT2,
       inboundorder.USRTXT3 USRTXT3,
       inboundorder.USRTXT4 USRTXT4,
       inboundorder.USRTXT5 USRTXT5,
       inboundorder.USRTXT6 USRTXT6,
       inboundorder.USRTXT7 USRTXT7,
       inboundorder.USRTXT8 USRTXT8,
       inboundorder.USRTXT9 USRTXT9,
       inboundorder.USRTXT10 USRTXT10,
       inboundorder.USRTXT11 USRTXT11,
       inboundorder.USRTXT12 USRTXT12,
       inboundorder.USRTXT13 USRTXT13,
       inboundorder.USRTXT14 USRTXT14,
       inboundorder.USRTXT15 USRTXT15,
       inboundorder.USRTXT16 USRTXT16,
       inboundorder.USRTXT17 USRTXT17,
       inboundorder.USRTXT18 USRTXT18,
       inboundorder.USRTXT19 USRTXT19,
       inboundorder.USRTXT20 USRTXT20,
       inboundorder.USRTXT21 USRTXT21,
       inboundorder.USRTXT22 USRTXT22,
       inboundorder.USRTXT23 USRTXT23,
       inboundorder.USRTXT24 USRTXT24,
       inboundorder.USRTXT25 USRTXT25,
       inboundorder.USRTXT26 USRTXT26,
       inboundorder.USRTXT27 USRTXT27,
       inboundorder.USRTXT28 USRTXT28,
       inboundorder.USRTXT29 USRTXT29,
       inboundorder.USRTXT30 USRTXT30,
       inboundorder.USRTXT31 USRTXT31,
       inboundorder.USRTXT32 USRTXT32,
       inboundorder.USRTXT33 USRTXT33,
       inboundorder.USRTXT34 USRTXT34,
       inboundorder.USRTXT35 USRTXT35,
       inboundorder.USRTXT36 USRTXT36,
       inboundorder.USRTXT37 USRTXT37,
       inboundorder.USRTXT38 USRTXT38,
       inboundorder.USRTXT39 USRTXT39,
       inboundorder.USRTXT40 USRTXT40,
       inboundorder.USRTXT41 USRTXT41,
       inboundorder.USRTXT42 USRTXT42,
       inboundorder.USRTXT43 USRTXT43,
       inboundorder.USRTXT44 USRTXT44,
       inboundorder.USRTXT45 USRTXT45,
       inboundorder.USRTXT46 USRTXT46,
       inboundorder.USRTXT47 USRTXT47,
       inboundorder.USRTXT48 USRTXT48,
       inboundorder.USRTXT49 USRTXT49,
       inboundorder.USRTXT50 USRTXT50,
       inboundorder.USRTXT51 USRTXT51,
       inboundorder.USRTXT52 USRTXT52,
       inboundorder.USRTXT53 USRTXT53,
       inboundorder.USRTXT54 USRTXT54,
       inboundorder.USRTXT55 USRTXT55,
       inboundorder.USRTXT56 USRTXT56,
       inboundorder.USRTXT57 USRTXT57,
       inboundorder.USRTXT58 USRTXT58,
       inboundorder.USRTXT59 USRTXT59,
       inboundorder.USRTXT60 USRTXT60,
       inboundorder.USRTXT61 USRTXT61,
       inboundorder.USRTXT62 USRTXT62,
       inboundorder.USRTXT63 USRTXT63,
       inboundorder.USRTXT64 USRTXT64,
       inboundorder.USRTXT65 USRTXT65
FROM OBJT_INBOUNDORDER inboundorder
/

-- INBOUNDLINES --

CREATE OR REPLACE VIEW DCEREPORT_INBOUNDLINES
AS
SELECT /*+ FIRST_ROWS(30) */ inboundline.OID OID,
       inboundorder.OID INBOUNDORDER_OID,
       inboundline.NAME NAME,
       inboundline.DESCRIPTION DESCRIPTION,
       inboundline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inbounditemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       inbounditemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       inbounditemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       inbounditemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       inbounditemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       inbounditemqty.QTYTARGET QTYTARGET,
       inbounditemqty.VALUE QTY,
       uom.SYMBOL UOM,
       inboundline.DTSPLANNEDSTART DTSPLANNEDSTART,
       inboundline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       inboundline.DTSSTART DTSSTART,
       inboundline.DTSSTOP DTSSTOP,
       CAST(GREATEST(inboundline.DTSUPDATE, inbounditemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       inboundline.DTSUPDATE AS DTSUPDATE_1,
       inbounditemqty.DTSUPDATE AS DTSUPDATE_2,
       inboundline.USRDTS1 USRDTS1,
       inboundline.USRDTS2 USRDTS2,
       inboundline.USRDTS3 USRDTS3,
       inboundline.USRDTS4 USRDTS4,
       inboundline.USRDTS5 USRDTS5,
       inboundline.USRDTS6 USRDTS6,
       inboundline.USRDTS7 USRDTS7,
       inboundline.USRDTS8 USRDTS8,
       inboundline.USRDTS9 USRDTS9,
       inboundline.USRDTS10 USRDTS10,
       inboundline.USRDTS11 USRDTS11,
       inboundline.USRDTS12 USRDTS12,
       inboundline.USRDTS13 USRDTS13,
       inboundline.USRDTS14 USRDTS14,
       inboundline.USRDTS15 USRDTS15,
       inboundline.USRDTS16 USRDTS16,
       inboundline.USRDTS17 USRDTS17,
       inboundline.USRDTS18 USRDTS18,
       inboundline.USRDTS19 USRDTS19,
       inboundline.USRDTS20 USRDTS20,
       inboundline.USRDTS21 USRDTS21,
       inboundline.USRDTS22 USRDTS22,
       inboundline.USRDTS23 USRDTS23,
       inboundline.USRDTS24 USRDTS24,
       inboundline.USRDTS25 USRDTS25,
       inboundline.USRDTS26 USRDTS26,
       inboundline.USRDTS27 USRDTS27,
       inboundline.USRDTS28 USRDTS28,
       inboundline.USRDTS29 USRDTS29,
       inboundline.USRDTS30 USRDTS30,
       inboundline.USRFLG1 USRFLG1,
       inboundline.USRFLG2 USRFLG2,
       inboundline.USRFLG3 USRFLG3,
       inboundline.USRFLG4 USRFLG4,
       inboundline.USRFLG5 USRFLG5,
       inboundline.USRFLG6 USRFLG6,
       inboundline.USRFLG7 USRFLG7,
       inboundline.USRFLG8 USRFLG8,
       inboundline.USRFLG9 USRFLG9,
       inboundline.USRFLG10 USRFLG10,
       inboundline.USRFLG11 USRFLG11,
       inboundline.USRFLG12 USRFLG12,
       inboundline.USRFLG13 USRFLG13,
       inboundline.USRFLG14 USRFLG14,
       inboundline.USRFLG15 USRFLG15,
       inboundline.USRFLG16 USRFLG16,
       inboundline.USRFLG17 USRFLG17,
       inboundline.USRFLG18 USRFLG18,
       inboundline.USRFLG19 USRFLG19,
       inboundline.USRFLG20 USRFLG20,
       inboundline.USRFLG21 USRFLG21,
       inboundline.USRFLG22 USRFLG22,
       inboundline.USRFLG23 USRFLG23,
       inboundline.USRFLG24 USRFLG24,
       inboundline.USRFLG25 USRFLG25,
       inboundline.USRFLG26 USRFLG26,
       inboundline.USRFLG27 USRFLG27,
       inboundline.USRFLG28 USRFLG28,
       inboundline.USRFLG29 USRFLG29,
       inboundline.USRFLG30 USRFLG30,
       inboundline.USRNUM1 USRNUM1,
       inboundline.USRNUM2 USRNUM2,
       inboundline.USRNUM3 USRNUM3,
       inboundline.USRNUM4 USRNUM4,
       inboundline.USRNUM5 USRNUM5,
       inboundline.USRNUM6 USRNUM6,
       inboundline.USRNUM7 USRNUM7,
       inboundline.USRNUM8 USRNUM8,
       inboundline.USRNUM9 USRNUM9,
       inboundline.USRNUM10 USRNUM10,
       inboundline.USRNUM11 USRNUM11,
       inboundline.USRNUM12 USRNUM12,
       inboundline.USRNUM13 USRNUM13,
       inboundline.USRNUM14 USRNUM14,
       inboundline.USRNUM15 USRNUM15,
       inboundline.USRNUM16 USRNUM16,
       inboundline.USRNUM17 USRNUM17,
       inboundline.USRNUM18 USRNUM18,
       inboundline.USRNUM19 USRNUM19,
       inboundline.USRNUM20 USRNUM20,
       inboundline.USRNUM21 USRNUM21,
       inboundline.USRNUM22 USRNUM22,
       inboundline.USRNUM23 USRNUM23,
       inboundline.USRNUM24 USRNUM24,
       inboundline.USRNUM25 USRNUM25,
       inboundline.USRNUM26 USRNUM26,
       inboundline.USRNUM27 USRNUM27,
       inboundline.USRNUM28 USRNUM28,
       inboundline.USRNUM29 USRNUM29,
       inboundline.USRNUM30 USRNUM30,
       inboundline.USRNUM31 USRNUM31,
       inboundline.USRNUM32 USRNUM32,
       inboundline.USRNUM33 USRNUM33,
       inboundline.USRNUM34 USRNUM34,
       inboundline.USRNUM35 USRNUM35,
       inboundline.USRNUM36 USRNUM36,
       inboundline.USRNUM37 USRNUM37,
       inboundline.USRNUM38 USRNUM38,
       inboundline.USRNUM39 USRNUM39,
       inboundline.USRNUM40 USRNUM40,
       inboundline.USRNUM41 USRNUM41,
       inboundline.USRNUM42 USRNUM42,
       inboundline.USRNUM43 USRNUM43,
       inboundline.USRNUM44 USRNUM44,
       inboundline.USRNUM45 USRNUM45,
       inboundline.USRNUM46 USRNUM46,
       inboundline.USRNUM47 USRNUM47,
       inboundline.USRNUM48 USRNUM48,
       inboundline.USRNUM49 USRNUM49,
       inboundline.USRNUM50 USRNUM50,
       inboundline.USRNUM51 USRNUM51,
       inboundline.USRNUM52 USRNUM52,
       inboundline.USRNUM53 USRNUM53,
       inboundline.USRNUM54 USRNUM54,
       inboundline.USRNUM55 USRNUM55,
       inboundline.USRNUM56 USRNUM56,
       inboundline.USRNUM57 USRNUM57,
       inboundline.USRNUM58 USRNUM58,
       inboundline.USRNUM59 USRNUM59,
       inboundline.USRNUM60 USRNUM60,
       inboundline.USRNUM61 USRNUM61,
       inboundline.USRNUM62 USRNUM62,
       inboundline.USRNUM63 USRNUM63,
       inboundline.USRNUM64 USRNUM64,
       inboundline.USRNUM65 USRNUM65,
       inboundline.USRTXT1 USRTXT1,
       inboundline.USRTXT2 USRTXT2,
       inboundline.USRTXT3 USRTXT3,
       inboundline.USRTXT4 USRTXT4,
       inboundline.USRTXT5 USRTXT5,
       inboundline.USRTXT6 USRTXT6,
       inboundline.USRTXT7 USRTXT7,
       inboundline.USRTXT8 USRTXT8,
       inboundline.USRTXT9 USRTXT9,
       inboundline.USRTXT10 USRTXT10,
       inboundline.USRTXT11 USRTXT11,
       inboundline.USRTXT12 USRTXT12,
       inboundline.USRTXT13 USRTXT13,
       inboundline.USRTXT14 USRTXT14,
       inboundline.USRTXT15 USRTXT15,
       inboundline.USRTXT16 USRTXT16,
       inboundline.USRTXT17 USRTXT17,
       inboundline.USRTXT18 USRTXT18,
       inboundline.USRTXT19 USRTXT19,
       inboundline.USRTXT20 USRTXT20,
       inboundline.USRTXT21 USRTXT21,
       inboundline.USRTXT22 USRTXT22,
       inboundline.USRTXT23 USRTXT23,
       inboundline.USRTXT24 USRTXT24,
       inboundline.USRTXT25 USRTXT25,
       inboundline.USRTXT26 USRTXT26,
       inboundline.USRTXT27 USRTXT27,
       inboundline.USRTXT28 USRTXT28,
       inboundline.USRTXT29 USRTXT29,
       inboundline.USRTXT30 USRTXT30,
       inboundline.USRTXT31 USRTXT31,
       inboundline.USRTXT32 USRTXT32,
       inboundline.USRTXT33 USRTXT33,
       inboundline.USRTXT34 USRTXT34,
       inboundline.USRTXT35 USRTXT35,
       inboundline.USRTXT36 USRTXT36,
       inboundline.USRTXT37 USRTXT37,
       inboundline.USRTXT38 USRTXT38,
       inboundline.USRTXT39 USRTXT39,
       inboundline.USRTXT40 USRTXT40,
       inboundline.USRTXT41 USRTXT41,
       inboundline.USRTXT42 USRTXT42,
       inboundline.USRTXT43 USRTXT43,
       inboundline.USRTXT44 USRTXT44,
       inboundline.USRTXT45 USRTXT45,
       inboundline.USRTXT46 USRTXT46,
       inboundline.USRTXT47 USRTXT47,
       inboundline.USRTXT48 USRTXT48,
       inboundline.USRTXT49 USRTXT49,
       inboundline.USRTXT50 USRTXT50,
       inboundline.USRTXT51 USRTXT51,
       inboundline.USRTXT52 USRTXT52,
       inboundline.USRTXT53 USRTXT53,
       inboundline.USRTXT54 USRTXT54,
       inboundline.USRTXT55 USRTXT55,
       inboundline.USRTXT56 USRTXT56,
       inboundline.USRTXT57 USRTXT57,
       inboundline.USRTXT58 USRTXT58,
       inboundline.USRTXT59 USRTXT59,
       inboundline.USRTXT60 USRTXT60,
       inboundline.USRTXT61 USRTXT61,
       inboundline.USRTXT62 USRTXT62,
       inboundline.USRTXT63 USRTXT63,
       inboundline.USRTXT64 USRTXT64,
       inboundline.USRTXT65 USRTXT65
FROM OBJT_INBOUNDOPERATION inboundline,
     OBJT_INBOUNDORDER inboundorder,
     OBJT_INBOUNDITEMQTY inbounditemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE inboundline.BOTYPE = 0 -- TARGET
AND inboundorder.OID = inboundline.INBOUNDORDEROID
AND inboundline.OID = inbounditemqty.INBOUNDOPERATIONOID
AND inbounditemqty.UOMOID = uom.OID
AND inbounditemqty.LOTOID = lot.OID
/

-- ACTUAL INBOUNDOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_INBOUND_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ inbound_inventorytraceop.OID OID,
       inboundorder.OID INBOUNDORDER_OID,
       inboundline.OID INBOUNDLINE_OID,
       inbound_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inbound_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       inbound_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       inbound_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       inbound_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       inbound_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       inbound_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       inbound_inventorytraceop.DTSSTART DTSSTART,
       inbound_inventorytraceop.DTSSTOP DTSSTOP,
       inbound_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       inbound_inventorytraceop.TOCSITQOID CONTAINER_OID,
       inbound_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       inbound_inventorytraceop.DEVICEOID DEVICE_OID,
       inbound_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION inbound_inventorytraceop,
     OBJT_OPERATIONLINK inboundop_inboundline_link,
     OBJT_INBOUNDOPERATION inboundline,
     OBJT_INBOUNDORDER inboundorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE inbound_inventorytraceop.BOTYPE = 0 -- INBOUND
AND inboundop_inboundline_link.CHILDOID = inbound_inventorytraceop.OID
AND inboundop_inboundline_link.PARENTOID = inboundline.OID
AND inboundorder.OID = inboundline.INBOUNDORDEROID
AND inbound_inventorytraceop.UOMOID = uom.OID
AND inbound_inventorytraceop.LOTOID = lot.OID
/

-- ACTUAL PRERECEIPTOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_PRERECEIPT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ prereceipt_inventorytraceop.OID OID,
       inboundorder.OID INBOUNDORDER_OID,
       inboundline.OID INBOUNDLINE_OID,
       prereceipt_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       prereceipt_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       prereceipt_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       prereceipt_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       prereceipt_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       prereceipt_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       prereceipt_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       prereceipt_inventorytraceop.DTSSTART DTSSTART,
       prereceipt_inventorytraceop.DTSSTOP DTSSTOP,
       prereceipt_inventorytraceop.TOCSITQOID CONTAINER_OID,
       prereceipt_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       prereceipt_inventorytraceop.DEVICEOID DEVICE_OID,
       prereceipt_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION prereceipt_inventorytraceop,
     OBJT_OPERATIONLINK prereceiptop_inboundline_link,
     OBJT_INBOUNDOPERATION inboundline,
     OBJT_INBOUNDORDER inboundorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE prereceipt_inventorytraceop.BOTYPE = 6 -- PRERECEIPT
AND prereceiptop_inboundline_link.CHILDOID = prereceipt_inventorytraceop.OID
AND prereceiptop_inboundline_link.PARENTOID = inboundline.OID
AND inboundorder.OID = inboundline.INBOUNDORDEROID
AND prereceipt_inventorytraceop.UOMOID = uom.OID
AND prereceipt_inventorytraceop.LOTOID = lot.OID
/

-- PUTORDERS --

CREATE OR REPLACE VIEW DCEREPORT_PUTORDERS
AS -- SELECT ALL PUTORDERS FOR INBOUNDORDERS AND PRODUCTIONORDERS
SELECT /*+ FIRST_ROWS(30) */ putorder.OID OID,
       inboundorder.OID ORDER_OID,
       CASE WHEN (putorder.BOTYPE = 0) THEN DECODE(inboundorder.BOTYPE, 1, 'RETURN', 'RECEIPT')
            WHEN (putorder.BOTYPE = 1) THEN 'PRODUCTION' END AS ORDER_TYPE,
       putorder.NAME NAME,
       putorder.ID ID,
       putorder.DESCRIPTION DESCRIPTION,
       putorder.STATUS STATUS,
       putorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       putorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       putorder.DTSSTART DTSSTART,
       putorder.DTSSTOP DTSSTOP,
       putorder.DTSDUEBEFORE DTSDUEBEFORE,
       putorder.DTSUPDATE DTSUPDATE
FROM OBJT_PUTORDER putorder,
     OBJT_ORDERLINK orderlink, 
     OBJT_INBOUNDORDER inboundorder
WHERE orderlink.PARENTOID = inboundorder.OID
AND orderlink.CHILDOID = putorder.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ putorder.OID OID,
       productionorder.OID ORDER_OID,
       CASE WHEN (putorder.BOTYPE = 0) THEN DECODE(productionorder.BOTYPE, 0, 'RECEIPT', 'RETURN')
            WHEN (putorder.BOTYPE = 1) THEN 'PRODUCTION' END AS ORDER_TYPE,
       putorder.NAME NAME,
       putorder.ID ID,
       putorder.DESCRIPTION DESCRIPTION,
       putorder.STATUS STATUS,
       putorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       putorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       putorder.DTSSTART DTSSTART,
       putorder.DTSSTOP DTSSTOP,
       putorder.DTSDUEBEFORE DTSDUEBEFORE,
       putorder.DTSUPDATE DTSUPDATE
FROM OBJT_PUTORDER putorder,
     OBJT_ORDERLINK orderlink,
     OBJT_PRODUCTIONORDER productionorder
WHERE orderlink.PARENTOID = productionorder.OID
AND orderlink.CHILDOID = putorder.OID
AND productionorder.BOTYPE NOT IN (10,11) -- NOT IN (TYPE_WMS_KIT,TYPE_WMS_VAL)
UNION ALL -- SELECT ALL PUTORDERS FOR MTO (VAL/Kit) or MTS (Kit) ORDERS
SELECT /*+ FIRST_ROWS(30) */ putorder.OID OID,
       makeorder.OID ORDER_OID, -- MTO (VAL/Kit) or MTS (Kit) ORDER
       CASE WHEN (makeorder.BOTYPE = 0) THEN 'MTO' ELSE 'MTS' END AS ORDER_TYPE,
       putorder.NAME NAME,
       putorder.ID ID,
       putorder.DESCRIPTION DESCRIPTION,
       putorder.STATUS STATUS,
       putorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       putorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       putorder.DTSSTART DTSSTART,
       putorder.DTSSTOP DTSSTOP,
       putorder.DTSDUEBEFORE DTSDUEBEFORE,
       putorder.DTSUPDATE DTSUPDATE
FROM OBJT_PUTORDER putorder,
     OBJT_ORDERLINK productionorderlink,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_ORDERLINK makeorderlink,
     OBJT_MAKEORDER makeorder
WHERE putorder.OID = productionorderlink.CHILDOID
AND productionorderlink.PARENTOID = productionorder.OID
AND productionorder.OID = makeorderlink.CHILDOID
AND makeorderlink.PARENTOID = makeorder.OID
/

-- PUTLINES --

CREATE OR REPLACE VIEW DCEREPORT_PUTLINES
AS
SELECT /*+ FIRST_ROWS(30) */ putline.OID OID,
       inboundorder.OID ORDER_OID,
       CASE WHEN (putorder.BOTYPE = 0) THEN DECODE(inboundorder.BOTYPE, 1, 'RETURN', 'RECEIPT')
            WHEN (putorder.BOTYPE = 1) THEN 'PRODUCTION' END AS ORDER_TYPE,
       inboundoperation.OID ORDERLINE_OID,
       putorder.OID PUTORDER_OID,
       putline.NAME NAME,
       putline.DESCRIPTION DESCRIPTION,
       putline.STATUS STATUS,
       putitemqty.ITEMOID ITEM_OID,
       putitemqty.QTYTARGET QTYTARGET,
       putitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       putline.DTSPLANNEDSTART DTSPLANNEDSTART,
       putline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       putline.DTSSTART DTSSTART,
       putline.DTSSTOP DTSSTOP,
       CAST(GREATEST(putline.DTSUPDATE, putitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       putline.DTSUPDATE AS DTSUPDATE_1,
       putitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PUTOPERATION putline,
     OBJT_PUTORDER putorder,
     OBJT_OPERATIONLINK putline_orderline_link,
     OBJT_INBOUNDOPERATION inboundoperation,
     OBJT_INBOUNDORDER inboundorder,
     OBJT_PUTITEMQTY putitemqty,
     OBJT_UOM uom
WHERE putline.BOTYPE = 0 -- TARGET
AND putorder.OID = putline.PUTORDEROID
AND putline_orderline_link.CHILDOID = putline.OID
AND putline_orderline_link.PARENTOID = inboundoperation.OID
AND inboundorder.OID = inboundoperation.INBOUNDORDEROID
AND putline.OID = putitemqty.PUTOPERATIONOID
AND putitemqty.UOMOID = uom.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ putline.OID OID,
       productionorder.OID ORDER_OID,
       CASE WHEN (putorder.BOTYPE = 0) THEN DECODE(productionorder.BOTYPE, 0, 'RECEIPT', 'RETURN')
            WHEN (putorder.BOTYPE = 1) THEN 'PRODUCTION' END AS ORDER_TYPE,
       productionoperation.OID ORDERLINE_OID,
       putorder.OID PUTORDER_OID,
       putline.NAME NAME,
       putline.DESCRIPTION DESCRIPTION,
       putline.STATUS STATUS,
       putitemqty.ITEMOID ITEM_OID,
       putitemqty.QTYTARGET QTYTARGET,
       putitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       putline.DTSPLANNEDSTART DTSPLANNEDSTART,
       putline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       putline.DTSSTART DTSSTART,
       putline.DTSSTOP DTSSTOP,
       CAST(GREATEST(putline.DTSUPDATE, putitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       putline.DTSUPDATE AS DTSUPDATE_1,
       putitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PUTOPERATION putline,
     OBJT_PUTORDER putorder,
     OBJT_OPERATIONLINK putline_orderline_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PUTITEMQTY putitemqty,
     OBJT_UOM uom
WHERE putline.BOTYPE = 0 -- TARGET
AND putorder.OID = putline.PUTORDEROID
AND putline_orderline_link.CHILDOID = putline.OID
AND putline_orderline_link.PARENTOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE NOT IN (10,11) -- NOT IN (TYPE_WMS_KIT,TYPE_WMS_VAL)
AND putline.OID = putitemqty.PUTOPERATIONOID
AND putitemqty.UOMOID = uom.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ putline.OID OID,
       makeorder.OID ORDER_OID, -- VAL/Kit MTO or MTS Order
       CASE WHEN (makeorder.BOTYPE = 0) THEN 'MTO' ELSE 'MTS' END AS ORDER_TYPE,
       makeoperation.OID ORDERLINE_OID, -- VAL/KIT MTO or MTS LINE
       putorder.OID PUTORDER_OID,
       putline.NAME NAME,
       putline.DESCRIPTION DESCRIPTION,
       putline.STATUS STATUS,
       putitemqty.ITEMOID ITEM_OID,
       putitemqty.QTYTARGET QTYTARGET,
       putitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       putline.DTSPLANNEDSTART DTSPLANNEDSTART,
       putline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       putline.DTSSTART DTSSTART,
       putline.DTSSTOP DTSSTOP,
       CAST(GREATEST(putline.DTSUPDATE, putitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       putline.DTSUPDATE AS DTSUPDATE_1,
       putitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PUTOPERATION putline,
     OBJT_PUTITEMQTY putitemqty,
     OBJT_UOM uom,
     OBJT_PUTORDER putorder,
     OBJT_OPERATIONLINK productionoplink,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_OPERATIONLINK make_prodop_link,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_MAKEORDER makeorder
WHERE putline.BOTYPE = 0 -- TARGET
AND putorder.OID = putline.PUTORDEROID
AND putline.OID = putitemqty.PUTOPERATIONOID
AND putitemqty.UOMOID = uom.OID
AND putline.OID = productionoplink.CHILDOID
AND productionoplink.PARENTOID = productionoperation.OID
AND productionoperation.OID = make_prodop_link.CHILDOID
AND make_prodop_link.PARENTOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
/

-- ACTUAL PUTOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_PUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ put_inventorytraceop.OID OID,
       putorder.OID PUTORDER_OID,
       putline.OID PUTLINE_OID,
       put_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       put_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       put_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       put_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       put_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       put_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       put_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       put_inventorytraceop.DTSSTART DTSSTART,
       put_inventorytraceop.DTSSTOP DTSSTOP,
       put_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       put_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       put_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       put_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       put_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       put_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       put_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       put_inventorytraceop.DEVICEOID DEVICE_OID,
       put_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION put_inventorytraceop,
     OBJT_OPERATIONLINK putop_putline_link,
     OBJT_PUTOPERATION putline,
     OBJT_PUTORDER putorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE put_inventorytraceop.BOTYPE = 7 -- PUT
AND putop_putline_link.CHILDOID = put_inventorytraceop.OID
AND putop_putline_link.PARENTOID = putline.OID
AND putorder.OID = putline.PUTORDEROID
AND put_inventorytraceop.UOMOID = uom.OID
AND put_inventorytraceop.LOTOID = lot.OID
/

-- ACTUAL CROSSDOCKOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_CROSSDOCK_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ crossdock_inventorytraceop.OID OID,
       putorder.OID PUTORDER_OID,
       putline.OID PUTLINE_OID,
       backorder.OID BACKORDER_OID,
       backorderline.OID BACKORDERLINE_OID,
       crossdock_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       crossdock_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       crossdock_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       crossdock_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       crossdock_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       crossdock_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       crossdock_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       crossdock_inventorytraceop.DTSSTART DTSSTART,
       crossdock_inventorytraceop.DTSSTOP DTSSTOP,
       crossdock_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       crossdock_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       crossdock_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       crossdock_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       crossdock_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       crossdock_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       crossdock_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       crossdock_inventorytraceop.DEVICEOID DEVICE_OID,
       crossdock_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION crossdock_inventorytraceop,
     OBJT_OPERATIONLINK crossdockop_putline_link,
     OBJT_PUTOPERATION putline,
     OBJT_PUTORDER putorder,
     OBJT_OPERATIONLINK crossdockop_backorderline_link,
     OBJT_BACKORDEROPERATION backorderline,
     OBJT_BACKORDERORDER backorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE crossdock_inventorytraceop.BOTYPE = 13 -- CROSSDOCK
AND crossdockop_putline_link.CHILDOID = crossdock_inventorytraceop.OID
AND crossdockop_putline_link.PARENTOID = putline.OID
AND putorder.OID = putline.PUTORDEROID
AND crossdockop_backorderline_link.CHILDOID = crossdock_inventorytraceop.OID
AND crossdockop_backorderline_link.PARENTOID = backorderline.OID
AND backorder.OID = backorderline.BACKORDERORDEROID
AND crossdock_inventorytraceop.UOMOID = uom.OID                                                            
AND crossdock_inventorytraceop.LOTOID = lot.OID
/

-- OUTBOUNDORDERS --

CREATE OR REPLACE VIEW DCEREPORT_OUTBOUNDORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ outboundorder.OID OID,
       outboundorder.NAME NAME,
       outboundorder.ID ID,
       outboundorder.DESCRIPTION DESCRIPTION,
       CAST((SELECT customer.OID FROM OBJT_CUSTOMER customer, OBJT_ORDERRESOURCELINK outboundorder_customer_link
                            WHERE outboundorder_customer_link.RESOURCEOID = customer.OID
                            AND outboundorder_customer_link.ORDEROID = outboundorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS CUSTOMER_OID,
       CAST((SELECT carrier.OID  FROM OBJT_CARRIER carrier, OBJT_ORDERRESOURCELINK outboundorder_carrier_link
                            WHERE outboundorder_carrier_link.RESOURCEOID = carrier.OID
                            AND outboundorder_carrier_link.ORDEROID = outboundorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS CARRIER_OID,
       outboundorder.STATUS STATUS,
       outboundorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       outboundorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       outboundorder.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       outboundorder.DTSDUEBEFORE DTSDUEBEFORE,
       outboundorder.DTSSTART DTSSTART,
       outboundorder.DTSSTOP DTSSTOP,
       outboundorder.DTSUPDATE DTSUPDATE,
       outboundorder.USRDTS1 USRDTS1,
       outboundorder.USRDTS2 USRDTS2,
       outboundorder.USRDTS3 USRDTS3,
       outboundorder.USRDTS4 USRDTS4,
       outboundorder.USRDTS5 USRDTS5,
       outboundorder.USRDTS6 USRDTS6,
       outboundorder.USRDTS7 USRDTS7,
       outboundorder.USRDTS8 USRDTS8,
       outboundorder.USRDTS9 USRDTS9,
       outboundorder.USRDTS10 USRDTS10,
       outboundorder.USRDTS11 USRDTS11,
       outboundorder.USRDTS12 USRDTS12,
       outboundorder.USRDTS13 USRDTS13,
       outboundorder.USRDTS14 USRDTS14,
       outboundorder.USRDTS15 USRDTS15,
       outboundorder.USRDTS16 USRDTS16,
       outboundorder.USRDTS17 USRDTS17,
       outboundorder.USRDTS18 USRDTS18,
       outboundorder.USRDTS19 USRDTS19,
       outboundorder.USRDTS20 USRDTS20,
       outboundorder.USRDTS21 USRDTS21,
       outboundorder.USRDTS22 USRDTS22,
       outboundorder.USRDTS23 USRDTS23,
       outboundorder.USRDTS24 USRDTS24,
       outboundorder.USRDTS25 USRDTS25,
       outboundorder.USRDTS26 USRDTS26,
       outboundorder.USRDTS27 USRDTS27,
       outboundorder.USRDTS28 USRDTS28,
       outboundorder.USRDTS29 USRDTS29,
       outboundorder.USRDTS30 USRDTS30,
       outboundorder.USRFLG1 USRFLG1,
       outboundorder.USRFLG2 USRFLG2,
       outboundorder.USRFLG3 USRFLG3,
       outboundorder.USRFLG4 USRFLG4,
       outboundorder.USRFLG5 USRFLG5,
       outboundorder.USRFLG6 USRFLG6,
       outboundorder.USRFLG7 USRFLG7,
       outboundorder.USRFLG8 USRFLG8,
       outboundorder.USRFLG9 USRFLG9,
       outboundorder.USRFLG10 USRFLG10,
       outboundorder.USRFLG11 USRFLG11,
       outboundorder.USRFLG12 USRFLG12,
       outboundorder.USRFLG13 USRFLG13,
       outboundorder.USRFLG14 USRFLG14,
       outboundorder.USRFLG15 USRFLG15,
       outboundorder.USRFLG16 USRFLG16,
       outboundorder.USRFLG17 USRFLG17,
       outboundorder.USRFLG18 USRFLG18,
       outboundorder.USRFLG19 USRFLG19,
       outboundorder.USRFLG20 USRFLG20,
       outboundorder.USRFLG21 USRFLG21,
       outboundorder.USRFLG22 USRFLG22,
       outboundorder.USRFLG23 USRFLG23,
       outboundorder.USRFLG24 USRFLG24,
       outboundorder.USRFLG25 USRFLG25,
       outboundorder.USRFLG26 USRFLG26,
       outboundorder.USRFLG27 USRFLG27,
       outboundorder.USRFLG28 USRFLG28,
       outboundorder.USRFLG29 USRFLG29,
       outboundorder.USRFLG30 USRFLG30,
       outboundorder.USRNUM1 USRNUM1,
       outboundorder.USRNUM2 USRNUM2,
       outboundorder.USRNUM3 USRNUM3,
       outboundorder.USRNUM4 USRNUM4,
       outboundorder.USRNUM5 USRNUM5,
       outboundorder.USRNUM6 USRNUM6,
       outboundorder.USRNUM7 USRNUM7,
       outboundorder.USRNUM8 USRNUM8,
       outboundorder.USRNUM9 USRNUM9,
       outboundorder.USRNUM10 USRNUM10,
       outboundorder.USRNUM11 USRNUM11,
       outboundorder.USRNUM12 USRNUM12,
       outboundorder.USRNUM13 USRNUM13,
       outboundorder.USRNUM14 USRNUM14,
       outboundorder.USRNUM15 USRNUM15,
       outboundorder.USRNUM16 USRNUM16,
       outboundorder.USRNUM17 USRNUM17,
       outboundorder.USRNUM18 USRNUM18,
       outboundorder.USRNUM19 USRNUM19,
       outboundorder.USRNUM20 USRNUM20,
       outboundorder.USRNUM21 USRNUM21,
       outboundorder.USRNUM22 USRNUM22,
       outboundorder.USRNUM23 USRNUM23,
       outboundorder.USRNUM24 USRNUM24,
       outboundorder.USRNUM25 USRNUM25,
       outboundorder.USRNUM26 USRNUM26,
       outboundorder.USRNUM27 USRNUM27,
       outboundorder.USRNUM28 USRNUM28,
       outboundorder.USRNUM29 USRNUM29,
       outboundorder.USRNUM30 USRNUM30,
       outboundorder.USRNUM31 USRNUM31,
       outboundorder.USRNUM32 USRNUM32,
       outboundorder.USRNUM33 USRNUM33,
       outboundorder.USRNUM34 USRNUM34,
       outboundorder.USRNUM35 USRNUM35,
       outboundorder.USRNUM36 USRNUM36,
       outboundorder.USRNUM37 USRNUM37,
       outboundorder.USRNUM38 USRNUM38,
       outboundorder.USRNUM39 USRNUM39,
       outboundorder.USRNUM40 USRNUM40,
       outboundorder.USRNUM41 USRNUM41,
       outboundorder.USRNUM42 USRNUM42,
       outboundorder.USRNUM43 USRNUM43,
       outboundorder.USRNUM44 USRNUM44,
       outboundorder.USRNUM45 USRNUM45,
       outboundorder.USRNUM46 USRNUM46,
       outboundorder.USRNUM47 USRNUM47,
       outboundorder.USRNUM48 USRNUM48,
       outboundorder.USRNUM49 USRNUM49,
       outboundorder.USRNUM50 USRNUM50,
       outboundorder.USRNUM51 USRNUM51,
       outboundorder.USRNUM52 USRNUM52,
       outboundorder.USRNUM53 USRNUM53,
       outboundorder.USRNUM54 USRNUM54,
       outboundorder.USRNUM55 USRNUM55,
       outboundorder.USRNUM56 USRNUM56,
       outboundorder.USRNUM57 USRNUM57,
       outboundorder.USRNUM58 USRNUM58,
       outboundorder.USRNUM59 USRNUM59,
       outboundorder.USRNUM60 USRNUM60,
       outboundorder.USRNUM61 USRNUM61,
       outboundorder.USRNUM62 USRNUM62,
       outboundorder.USRNUM63 USRNUM63,
       outboundorder.USRNUM64 USRNUM64,
       outboundorder.USRNUM65 USRNUM65,
       outboundorder.USRTXT1 USRTXT1,
       outboundorder.USRTXT2 USRTXT2,
       outboundorder.USRTXT3 USRTXT3,
       outboundorder.USRTXT4 USRTXT4,
       outboundorder.USRTXT5 USRTXT5,
       outboundorder.USRTXT6 USRTXT6,
       outboundorder.USRTXT7 USRTXT7,
       outboundorder.USRTXT8 USRTXT8,
       outboundorder.USRTXT9 USRTXT9,
       outboundorder.USRTXT10 USRTXT10,
       outboundorder.USRTXT11 USRTXT11,
       outboundorder.USRTXT12 USRTXT12,
       outboundorder.USRTXT13 USRTXT13,
       outboundorder.USRTXT14 USRTXT14,
       outboundorder.USRTXT15 USRTXT15,
       outboundorder.USRTXT16 USRTXT16,
       outboundorder.USRTXT17 USRTXT17,
       outboundorder.USRTXT18 USRTXT18,
       outboundorder.USRTXT19 USRTXT19,
       outboundorder.USRTXT20 USRTXT20,
       outboundorder.USRTXT21 USRTXT21,
       outboundorder.USRTXT22 USRTXT22,
       outboundorder.USRTXT23 USRTXT23,
       outboundorder.USRTXT24 USRTXT24,
       outboundorder.USRTXT25 USRTXT25,
       outboundorder.USRTXT26 USRTXT26,
       outboundorder.USRTXT27 USRTXT27,
       outboundorder.USRTXT28 USRTXT28,
       outboundorder.USRTXT29 USRTXT29,
       outboundorder.USRTXT30 USRTXT30,
       outboundorder.USRTXT31 USRTXT31,
       outboundorder.USRTXT32 USRTXT32,
       outboundorder.USRTXT33 USRTXT33,
       outboundorder.USRTXT34 USRTXT34,
       outboundorder.USRTXT35 USRTXT35,
       outboundorder.USRTXT36 USRTXT36,
       outboundorder.USRTXT37 USRTXT37,
       outboundorder.USRTXT38 USRTXT38,
       outboundorder.USRTXT39 USRTXT39,
       outboundorder.USRTXT40 USRTXT40,
       outboundorder.USRTXT41 USRTXT41,
       outboundorder.USRTXT42 USRTXT42,
       outboundorder.USRTXT43 USRTXT43,
       outboundorder.USRTXT44 USRTXT44,
       outboundorder.USRTXT45 USRTXT45,
       outboundorder.USRTXT46 USRTXT46,
       outboundorder.USRTXT47 USRTXT47,
       outboundorder.USRTXT48 USRTXT48,
       outboundorder.USRTXT49 USRTXT49,
       outboundorder.USRTXT50 USRTXT50,
       outboundorder.USRTXT51 USRTXT51,
       outboundorder.USRTXT52 USRTXT52,
       outboundorder.USRTXT53 USRTXT53,
       outboundorder.USRTXT54 USRTXT54,
       outboundorder.USRTXT55 USRTXT55,
       outboundorder.USRTXT56 USRTXT56,
       outboundorder.USRTXT57 USRTXT57,
       outboundorder.USRTXT58 USRTXT58,
       outboundorder.USRTXT59 USRTXT59,
       outboundorder.USRTXT60 USRTXT60,
       outboundorder.USRTXT61 USRTXT61,
       outboundorder.USRTXT62 USRTXT62,
       outboundorder.USRTXT63 USRTXT63,
       outboundorder.USRTXT64 USRTXT64,
       outboundorder.USRTXT65 USRTXT65
FROM OBJT_OUTBOUNDORDER outboundorder
/

-- OUTBOUNDLINES --

CREATE OR REPLACE VIEW DCEREPORT_OUTBOUNDLINES
AS
SELECT /*+ FIRST_ROWS(30) */ outboundline.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       outboundline.NAME NAME,
       outboundline.DESCRIPTION DESCRIPTION,
       outboundline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       outbounditemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       outbounditemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       outbounditemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       outbounditemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       outbounditemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       CASE WHEN (BITAND(outboundline.OPERATIONOPTION, 3) = 0) THEN 'NONE'
            WHEN (BITAND(outboundline.OPERATIONOPTION, 3) = 1) THEN 'SHORTAGES'
            WHEN (BITAND(outboundline.OPERATIONOPTION, 3) = 2) THEN 'ALL' END AS BACKORDER_OPTION,
       outbounditemqty.QTYTARGET QTYTARGET,
       outbounditemqty.VALUE QTY,
       outbounditemqty.qtypicked QTYPICKED,
       outbounditemqty.qtypacked QTYREPACKED,
       outbounditemqty.qtyshipped QTYSHIPPED,
       uom.SYMBOL UOM,
       outboundline.DTSPLANNEDSTART DTSPLANNEDSTART,
       outboundline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       outboundline.DTSSCHEDULEDSTOP DTSSCHEDULEDSTOP,
       outboundline.DTSSTART DTSSTART,
       outboundline.DTSSTOP DTSSTOP,
       CAST(GREATEST(outboundline.DTSUPDATE, outbounditemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       outboundline.DTSUPDATE AS DTSUPDATE_1,
       outbounditemqty.DTSUPDATE AS DTSUPDATE_2,
       outboundline.USRDTS1 USRDTS1,
       outboundline.USRDTS2 USRDTS2,
       outboundline.USRDTS3 USRDTS3,
       outboundline.USRDTS4 USRDTS4,
       outboundline.USRDTS5 USRDTS5,
       outboundline.USRDTS6 USRDTS6,
       outboundline.USRDTS7 USRDTS7,
       outboundline.USRDTS8 USRDTS8,
       outboundline.USRDTS9 USRDTS9,
       outboundline.USRDTS10 USRDTS10,
       outboundline.USRDTS11 USRDTS11,
       outboundline.USRDTS12 USRDTS12,
       outboundline.USRDTS13 USRDTS13,
       outboundline.USRDTS14 USRDTS14,
       outboundline.USRDTS15 USRDTS15,
       outboundline.USRDTS16 USRDTS16,
       outboundline.USRDTS17 USRDTS17,
       outboundline.USRDTS18 USRDTS18,
       outboundline.USRDTS19 USRDTS19,
       outboundline.USRDTS20 USRDTS20,
       outboundline.USRDTS21 USRDTS21,
       outboundline.USRDTS22 USRDTS22,
       outboundline.USRDTS23 USRDTS23,
       outboundline.USRDTS24 USRDTS24,
       outboundline.USRDTS25 USRDTS25,
       outboundline.USRDTS26 USRDTS26,
       outboundline.USRDTS27 USRDTS27,
       outboundline.USRDTS28 USRDTS28,
       outboundline.USRDTS29 USRDTS29,
       outboundline.USRDTS30 USRDTS30,
       outboundline.USRFLG1 USRFLG1,
       outboundline.USRFLG2 USRFLG2,
       outboundline.USRFLG3 USRFLG3,
       outboundline.USRFLG4 USRFLG4,
       outboundline.USRFLG5 USRFLG5,
       outboundline.USRFLG6 USRFLG6,
       outboundline.USRFLG7 USRFLG7,
       outboundline.USRFLG8 USRFLG8,
       outboundline.USRFLG9 USRFLG9,
       outboundline.USRFLG10 USRFLG10,
       outboundline.USRFLG11 USRFLG11,
       outboundline.USRFLG12 USRFLG12,
       outboundline.USRFLG13 USRFLG13,
       outboundline.USRFLG14 USRFLG14,
       outboundline.USRFLG15 USRFLG15,
       outboundline.USRFLG16 USRFLG16,
       outboundline.USRFLG17 USRFLG17,
       outboundline.USRFLG18 USRFLG18,
       outboundline.USRFLG19 USRFLG19,
       outboundline.USRFLG20 USRFLG20,
       outboundline.USRFLG21 USRFLG21,
       outboundline.USRFLG22 USRFLG22,
       outboundline.USRFLG23 USRFLG23,
       outboundline.USRFLG24 USRFLG24,
       outboundline.USRFLG25 USRFLG25,
       outboundline.USRFLG26 USRFLG26,
       outboundline.USRFLG27 USRFLG27,
       outboundline.USRFLG28 USRFLG28,
       outboundline.USRFLG29 USRFLG29,
       outboundline.USRFLG30 USRFLG30,
       outboundline.USRNUM1 USRNUM1,
       outboundline.USRNUM2 USRNUM2,
       outboundline.USRNUM3 USRNUM3,
       outboundline.USRNUM4 USRNUM4,
       outboundline.USRNUM5 USRNUM5,
       outboundline.USRNUM6 USRNUM6,
       outboundline.USRNUM7 USRNUM7,
       outboundline.USRNUM8 USRNUM8,
       outboundline.USRNUM9 USRNUM9,
       outboundline.USRNUM10 USRNUM10,
       outboundline.USRNUM11 USRNUM11,
       outboundline.USRNUM12 USRNUM12,
       outboundline.USRNUM13 USRNUM13,
       outboundline.USRNUM14 USRNUM14,
       outboundline.USRNUM15 USRNUM15,
       outboundline.USRNUM16 USRNUM16,
       outboundline.USRNUM17 USRNUM17,
       outboundline.USRNUM18 USRNUM18,
       outboundline.USRNUM19 USRNUM19,
       outboundline.USRNUM20 USRNUM20,
       outboundline.USRNUM21 USRNUM21,
       outboundline.USRNUM22 USRNUM22,
       outboundline.USRNUM23 USRNUM23,
       outboundline.USRNUM24 USRNUM24,
       outboundline.USRNUM25 USRNUM25,
       outboundline.USRNUM26 USRNUM26,
       outboundline.USRNUM27 USRNUM27,
       outboundline.USRNUM28 USRNUM28,
       outboundline.USRNUM29 USRNUM29,
       outboundline.USRNUM30 USRNUM30,
       outboundline.USRNUM31 USRNUM31,
       outboundline.USRNUM32 USRNUM32,
       outboundline.USRNUM33 USRNUM33,
       outboundline.USRNUM34 USRNUM34,
       outboundline.USRNUM35 USRNUM35,
       outboundline.USRNUM36 USRNUM36,
       outboundline.USRNUM37 USRNUM37,
       outboundline.USRNUM38 USRNUM38,
       outboundline.USRNUM39 USRNUM39,
       outboundline.USRNUM40 USRNUM40,
       outboundline.USRNUM41 USRNUM41,
       outboundline.USRNUM42 USRNUM42,
       outboundline.USRNUM43 USRNUM43,
       outboundline.USRNUM44 USRNUM44,
       outboundline.USRNUM45 USRNUM45,
       outboundline.USRNUM46 USRNUM46,
       outboundline.USRNUM47 USRNUM47,
       outboundline.USRNUM48 USRNUM48,
       outboundline.USRNUM49 USRNUM49,
       outboundline.USRNUM50 USRNUM50,
       outboundline.USRNUM51 USRNUM51,
       outboundline.USRNUM52 USRNUM52,
       outboundline.USRNUM53 USRNUM53,
       outboundline.USRNUM54 USRNUM54,
       outboundline.USRNUM55 USRNUM55,
       outboundline.USRNUM56 USRNUM56,
       outboundline.USRNUM57 USRNUM57,
       outboundline.USRNUM58 USRNUM58,
       outboundline.USRNUM59 USRNUM59,
       outboundline.USRNUM60 USRNUM60,
       outboundline.USRNUM61 USRNUM61,
       outboundline.USRNUM62 USRNUM62,
       outboundline.USRNUM63 USRNUM63,
       outboundline.USRNUM64 USRNUM64,
       outboundline.USRNUM65 USRNUM65,
       outboundline.USRTXT1 USRTXT1,
       outboundline.USRTXT2 USRTXT2,
       outboundline.USRTXT3 USRTXT3,
       outboundline.USRTXT4 USRTXT4,
       outboundline.USRTXT5 USRTXT5,
       outboundline.USRTXT6 USRTXT6,
       outboundline.USRTXT7 USRTXT7,
       outboundline.USRTXT8 USRTXT8,
       outboundline.USRTXT9 USRTXT9,
       outboundline.USRTXT10 USRTXT10,
       outboundline.USRTXT11 USRTXT11,
       outboundline.USRTXT12 USRTXT12,
       outboundline.USRTXT13 USRTXT13,
       outboundline.USRTXT14 USRTXT14,
       outboundline.USRTXT15 USRTXT15,
       outboundline.USRTXT16 USRTXT16,
       outboundline.USRTXT17 USRTXT17,
       outboundline.USRTXT18 USRTXT18,
       outboundline.USRTXT19 USRTXT19,
       outboundline.USRTXT20 USRTXT20,
       outboundline.USRTXT21 USRTXT21,
       outboundline.USRTXT22 USRTXT22,
       outboundline.USRTXT23 USRTXT23,
       outboundline.USRTXT24 USRTXT24,
       outboundline.USRTXT25 USRTXT25,
       outboundline.USRTXT26 USRTXT26,
       outboundline.USRTXT27 USRTXT27,
       outboundline.USRTXT28 USRTXT28,
       outboundline.USRTXT29 USRTXT29,
       outboundline.USRTXT30 USRTXT30,
       outboundline.USRTXT31 USRTXT31,
       outboundline.USRTXT32 USRTXT32,
       outboundline.USRTXT33 USRTXT33,
       outboundline.USRTXT34 USRTXT34,
       outboundline.USRTXT35 USRTXT35,
       outboundline.USRTXT36 USRTXT36,
       outboundline.USRTXT37 USRTXT37,
       outboundline.USRTXT38 USRTXT38,
       outboundline.USRTXT39 USRTXT39,
       outboundline.USRTXT40 USRTXT40,
       outboundline.USRTXT41 USRTXT41,
       outboundline.USRTXT42 USRTXT42,
       outboundline.USRTXT43 USRTXT43,
       outboundline.USRTXT44 USRTXT44,
       outboundline.USRTXT45 USRTXT45,
       outboundline.USRTXT46 USRTXT46,
       outboundline.USRTXT47 USRTXT47,
       outboundline.USRTXT48 USRTXT48,
       outboundline.USRTXT49 USRTXT49,
       outboundline.USRTXT50 USRTXT50,
       outboundline.USRTXT51 USRTXT51,
       outboundline.USRTXT52 USRTXT52,
       outboundline.USRTXT53 USRTXT53,
       outboundline.USRTXT54 USRTXT54,
       outboundline.USRTXT55 USRTXT55,
       outboundline.USRTXT56 USRTXT56,
       outboundline.USRTXT57 USRTXT57,
       outboundline.USRTXT58 USRTXT58,
       outboundline.USRTXT59 USRTXT59,
       outboundline.USRTXT60 USRTXT60,
       outboundline.USRTXT61 USRTXT61,
       outboundline.USRTXT62 USRTXT62,
       outboundline.USRTXT63 USRTXT63,
       outboundline.USRTXT64 USRTXT64,
       outboundline.USRTXT65 USRTXT65
FROM OBJT_OUTBOUNDOPERATION outboundline,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_OUTBOUNDITEMQTY outbounditemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE outboundline.BOTYPE = 0 -- TARGET
AND outboundorder.OID = outboundline.OUTBOUNDORDEROID
AND outboundline.OID = outbounditemqty.OUTBOUNDOPERATIONOID
AND outbounditemqty.UOMOID = uom.OID
AND outbounditemqty.LOTOID = lot.OID
/

-- ACTUAL OUTBOUNDOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_OUTBOUND_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ outbound_inventorytraceop.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       outboundline.OID OUTBOUNDLINE_OID,
       outbound_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       outbound_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       outbound_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       outbound_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       outbound_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       outbound_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       outbound_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       outbound_inventorytraceop.DTSSTART DTSSTART,
       outbound_inventorytraceop.DTSSTOP DTSSTOP,
       outbound_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       outbound_inventorytraceop.TOCSITQOID CONTAINER_OID,
       outbound_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       outbound_inventorytraceop.DEVICEOID DEVICE_OID,
       outbound_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION outbound_inventorytraceop,
     OBJT_OPERATIONLINK outboundop_outboundline_link,
     OBJT_OUTBOUNDOPERATION outboundline,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE outbound_inventorytraceop.BOTYPE = 1 -- OUTBOUND
AND outboundop_outboundline_link.CHILDOID = outbound_inventorytraceop.OID
AND outboundop_outboundline_link.PARENTOID = outboundline.OID
AND outboundorder.OID = outboundline.OUTBOUNDORDEROID
AND outbound_inventorytraceop.UOMOID = uom.OID
AND outbound_inventorytraceop.LOTOID = lot.OID
/

-- PICKORDERS --
CREATE OR REPLACE VIEW DCEREPORT_PICKORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ pickorder.OID OID,
       outboundorder.OID ORDER_OID,
       'ORDER' ORDER_TYPE,
       pickorder.NAME NAME,
       pickorder.ID ID,
       pickorder.DESCRIPTION DESCRIPTION,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pickorder.STATUS STATUS,
       pickorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       pickorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       pickorder.DTSSTART DTSSTART,
       pickorder.DTSSTOP DTSSTOP,
       pickorder.DTSDUEBEFORE DTSDUEBEFORE,
       pickorder.DTSUPDATE DTSUPDATE,
       pickorder.USRDTS1 USRDTS1,
       pickorder.USRDTS2 USRDTS2,
       pickorder.USRDTS3 USRDTS3,
       pickorder.USRDTS4 USRDTS4,
       pickorder.USRDTS5 USRDTS5,
       pickorder.USRFLG1 USRFLG1,
       pickorder.USRFLG2 USRFLG2,
       pickorder.USRFLG3 USRFLG3,
       pickorder.USRFLG4 USRFLG4,
       pickorder.USRFLG5 USRFLG5,
       pickorder.USRNUM1 USRNUM1,
       pickorder.USRNUM2 USRNUM2,
       pickorder.USRNUM3 USRNUM3,
       pickorder.USRNUM4 USRNUM4,
       pickorder.USRNUM5 USRNUM5,
       pickorder.USRTXT1 USRTXT1,
       pickorder.USRTXT2 USRTXT2,
       pickorder.USRTXT3 USRTXT3,
       pickorder.USRTXT4 USRTXT4,
       pickorder.USRTXT5 USRTXT5
FROM OBJT_PICKORDER pickorder,
     OBJT_ORDERLINK orderlink,
     OBJT_OUTBOUNDORDER outboundorder
WHERE orderlink.PARENTOID = outboundorder.OID
AND orderlink.CHILDOID = pickorder.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ pickorder.OID OID,
       productionorder.OID ORDER_OID,
       'PRODUCTION' ORDER_TYPE,
       pickorder.NAME NAME,
       pickorder.ID ID,
       pickorder.DESCRIPTION DESCRIPTION,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pickorder.STATUS STATUS,
       pickorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       pickorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       pickorder.DTSSTART DTSSTART,
       pickorder.DTSSTOP DTSSTOP,
       pickorder.DTSDUEBEFORE DTSDUEBEFORE,
       pickorder.DTSUPDATE DTSUPDATE,
       pickorder.USRDTS1 USRDTS1,
       pickorder.USRDTS2 USRDTS2,
       pickorder.USRDTS3 USRDTS3,
       pickorder.USRDTS4 USRDTS4,
       pickorder.USRDTS5 USRDTS5,
       pickorder.USRFLG1 USRFLG1,
       pickorder.USRFLG2 USRFLG2,
       pickorder.USRFLG3 USRFLG3,
       pickorder.USRFLG4 USRFLG4,
       pickorder.USRFLG5 USRFLG5,
       pickorder.USRNUM1 USRNUM1,
       pickorder.USRNUM2 USRNUM2,
       pickorder.USRNUM3 USRNUM3,
       pickorder.USRNUM4 USRNUM4,
       pickorder.USRNUM5 USRNUM5,
       pickorder.USRTXT1 USRTXT1,
       pickorder.USRTXT2 USRTXT2,
       pickorder.USRTXT3 USRTXT3,
       pickorder.USRTXT4 USRTXT4,
       pickorder.USRTXT5 USRTXT5
FROM OBJT_PICKORDER pickorder,
     OBJT_ORDERLINK orderlink,
     OBJT_PRODUCTIONORDER productionorder
WHERE orderlink.PARENTOID = productionorder.OID
AND orderlink.CHILDOID = pickorder.OID
AND productionorder.BOTYPE NOT IN (10,11) -- NOT IN (TYPE_WMS_KIT,TYPE_WMS_VAL)
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ pickorder.OID OID,
       makeorder.OID ORDER_OID, -- MTO (VAL/Kit) or MTS (Kit) ORDER
       CASE WHEN makeorder.BOTYPE = 0 THEN 'MTO' ELSE 'MTS' END AS ORDER_TYPE,
       pickorder.NAME NAME,
       pickorder.ID ID,
       pickorder.DESCRIPTION DESCRIPTION,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pickorder.STATUS STATUS,
       pickorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       pickorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       pickorder.DTSSTART DTSSTART,
       pickorder.DTSSTOP DTSSTOP,
       pickorder.DTSDUEBEFORE DTSDUEBEFORE,
       pickorder.DTSUPDATE DTSUPDATE,
       pickorder.USRDTS1 USRDTS1,
       pickorder.USRDTS2 USRDTS2,
       pickorder.USRDTS3 USRDTS3,
       pickorder.USRDTS4 USRDTS4,
       pickorder.USRDTS5 USRDTS5,
       pickorder.USRFLG1 USRFLG1,
       pickorder.USRFLG2 USRFLG2,
       pickorder.USRFLG3 USRFLG3,
       pickorder.USRFLG4 USRFLG4,
       pickorder.USRFLG5 USRFLG5,
       pickorder.USRNUM1 USRNUM1,
       pickorder.USRNUM2 USRNUM2,
       pickorder.USRNUM3 USRNUM3,
       pickorder.USRNUM4 USRNUM4,
       pickorder.USRNUM5 USRNUM5,
       pickorder.USRTXT1 USRTXT1,
       pickorder.USRTXT2 USRTXT2,
       pickorder.USRTXT3 USRTXT3,
       pickorder.USRTXT4 USRTXT4,
       pickorder.USRTXT5 USRTXT5
FROM OBJT_PICKORDER pickorder,
     OBJT_MAKEORDER makeorder,
     OBJT_ORDERLINK orderlink
WHERE pickorder.OID = orderlink.CHILDOID
AND orderlink.PARENTOID = makeorder.OID
/

-- PICKLINES --
CREATE OR REPLACE VIEW DCEREPORT_PICKLINES
AS
SELECT /*+ FIRST_ROWS(30) */ pickline.OID OID,
       outboundorder.OID ORDER_OID,
       outboundoperation.OID ORDERLINE_OID,
       'ORDER' ORDER_TYPE,
       pickorder.OID PICKORDER_OID,
       pickline.NAME NAME,
       pickline.DESCRIPTION DESCRIPTION,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pickline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       lot.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       pickitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       pickitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       pickitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       pickitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       pickitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       pickitemqty.QTYTARGET QTYTARGET,
       pickitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       pickline.DTSPLANNEDSTART DTSPLANNEDSTART,
       pickline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       pickline.DTSSTART DTSSTART,
       pickline.DTSSTOP DTSSTOP,
       CAST(GREATEST(pickline.DTSUPDATE, pickitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       pickline.USRDTS1 USRDTS1,
       pickline.USRDTS2 USRDTS2,
       pickline.USRDTS3 USRDTS3,
       pickline.USRDTS4 USRDTS4,
       pickline.USRDTS5 USRDTS5,
       pickline.USRFLG1 USRFLG1,
       pickline.USRFLG2 USRFLG2,
       pickline.USRFLG3 USRFLG3,
       pickline.USRFLG4 USRFLG4,
       pickline.USRFLG5 USRFLG5,
       pickline.USRNUM1 USRNUM1,
       pickline.USRNUM2 USRNUM2,
       pickline.USRNUM3 USRNUM3,
       pickline.USRNUM4 USRNUM4,
       pickline.USRNUM5 USRNUM5,
       pickline.USRTXT1 USRTXT1,
       pickline.USRTXT2 USRTXT2,
       pickline.USRTXT3 USRTXT3,
       pickline.USRTXT4 USRTXT4,
       pickline.USRTXT5 USRTXT5,
       pickline.DTSUPDATE AS DTSUPDATE_1,
       pickitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PICKOPERATION pickline,
     OBJT_PICKORDER pickorder,
     OBJT_OPERATIONLINK pickline_orderline_link,
     OBJT_OUTBOUNDOPERATION outboundoperation,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_PICKITEMQTY pickitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE pickline.BOTYPE = 0 -- TARGET
AND pickorder.OID = pickline.PICKORDEROID
AND pickline_orderline_link.CHILDOID = pickline.OID
AND pickline_orderline_link.PARENTOID = outboundoperation.OID
AND outboundorder.OID = outboundoperation.OUTBOUNDORDEROID
AND pickline.OID = pickitemqty.PICKOPERATIONOID
AND pickitemqty.UOMOID = uom.OID
AND pickitemqty.LOTOID = lot.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ pickline.OID OID,
       productionorder.OID ORDER_OID,
       productionoperation.OID ORDERLINE_OID,
       'PRODUCTION' AS ORDER_TYPE,
       pickorder.OID PICKORDER_OID,
       pickline.NAME NAME,
       pickline.DESCRIPTION DESCRIPTION,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pickline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       lot.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       pickitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       pickitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       pickitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       pickitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       pickitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       pickitemqty.QTYTARGET QTYTARGET,
       pickitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       pickline.DTSPLANNEDSTART DTSPLANNEDSTART,
       pickline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       pickline.DTSSTART DTSSTART,
       pickline.DTSSTOP DTSSTOP,
       CAST(GREATEST(pickline.DTSUPDATE, pickitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       pickline.USRDTS1 USRDTS1,
       pickline.USRDTS2 USRDTS2,
       pickline.USRDTS3 USRDTS3,
       pickline.USRDTS4 USRDTS4,
       pickline.USRDTS5 USRDTS5,
       pickline.USRFLG1 USRFLG1,
       pickline.USRFLG2 USRFLG2,
       pickline.USRFLG3 USRFLG3,
       pickline.USRFLG4 USRFLG4,
       pickline.USRFLG5 USRFLG5,
       pickline.USRNUM1 USRNUM1,
       pickline.USRNUM2 USRNUM2,
       pickline.USRNUM3 USRNUM3,
       pickline.USRNUM4 USRNUM4,
       pickline.USRNUM5 USRNUM5,
       pickline.USRTXT1 USRTXT1,
       pickline.USRTXT2 USRTXT2,
       pickline.USRTXT3 USRTXT3,
       pickline.USRTXT4 USRTXT4,
       pickline.USRTXT5 USRTXT5,
       pickline.DTSUPDATE AS DTSUPDATE_1,
       pickitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PICKOPERATION pickline,
     OBJT_PICKORDER pickorder,
     OBJT_OPERATIONLINK pickline_orderline_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_PICKITEMQTY pickitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE pickline.BOTYPE = 0 -- TARGET
AND pickorder.OID = pickline.PICKORDEROID
AND pickline_orderline_link.CHILDOID = pickline.OID
AND pickline_orderline_link.PARENTOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE NOT IN (10,11) -- NOT IN (TYPE_WMS_KIT,TYPE_WMS_VAL)
AND pickline.OID =pickitemqty.PICKOPERATIONOID
AND pickitemqty.UOMOID = uom.OID
AND pickitemqty.LOTOID = lot.OID
UNION ALL -- SELECT ALL PICKLINES FOR MTO or MTS ORDERS --
SELECT /*+ FIRST_ROWS(30) */ pickline.OID OID,
       makeorder.OID ORDER_OID, -- VAL/KIT MTO or MTS Order
       makeoperation.OID ORDERLINE_OID, -- VAL/KIT MTO or MTS LINE
       CASE WHEN (makeorder.BOTYPE = 0) THEN 'MTO' ELSE 'MTS' END AS ORDER_TYPE,
       pickorder.OID PICKORDER_OID,
       pickline.NAME NAME,
       pickline.DESCRIPTION DESCRIPTION,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pickline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       lot.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       pickitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       pickitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       pickitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       pickitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       pickitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       pickitemqty.QTYTARGET QTYTARGET,
       pickitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       pickline.DTSPLANNEDSTART DTSPLANNEDSTART,
       pickline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       pickline.DTSSTART DTSSTART,
       pickline.DTSSTOP DTSSTOP,
       CAST(GREATEST(pickline.DTSUPDATE, pickitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       pickline.USRDTS1 USRDTS1,
       pickline.USRDTS2 USRDTS2,
       pickline.USRDTS3 USRDTS3,
       pickline.USRDTS4 USRDTS4,
       pickline.USRDTS5 USRDTS5,
       pickline.USRFLG1 USRFLG1,
       pickline.USRFLG2 USRFLG2,
       pickline.USRFLG3 USRFLG3,
       pickline.USRFLG4 USRFLG4,
       pickline.USRFLG5 USRFLG5,
       pickline.USRNUM1 USRNUM1,
       pickline.USRNUM2 USRNUM2,
       pickline.USRNUM3 USRNUM3,
       pickline.USRNUM4 USRNUM4,
       pickline.USRNUM5 USRNUM5,
       pickline.USRTXT1 USRTXT1,
       pickline.USRTXT2 USRTXT2,
       pickline.USRTXT3 USRTXT3,
       pickline.USRTXT4 USRTXT4,
       pickline.USRTXT5 USRTXT5,
       pickline.DTSUPDATE AS DTSUPDATE_1,
       pickitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PICKOPERATION pickline,
     OBJT_PICKORDER pickorder,
     OBJT_OPERATIONLINK make_pickop_link,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_MAKEORDER makeorder,
     OBJT_PICKITEMQTY pickitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE pickline.BOTYPE = 0 -- TARGET
AND pickorder.OID = pickline.PICKORDEROID
AND pickline.OID = make_pickop_link.CHILDOID
AND make_pickop_link.PARENTOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
AND pickline.OID = pickitemqty.PICKOPERATIONOID
AND pickitemqty.UOMOID = uom.OID
AND pickitemqty.LOTOID = lot.OID
/
-- ACTUAL PICKOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_PICK_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ pick_inventorytraceop.OID OID,
       pickorder.OID PICKORDER_OID,
       pickline.OID PICKLINE_OID,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       pick_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       pick_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       pick_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       pick_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       pick_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       pick_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       pick_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       pick_inventorytraceop.DTSSTART DTSSTART,
       pick_inventorytraceop.DTSSTOP DTSSTOP,
       pick_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       pick_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       pick_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       pick_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       pick_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       pick_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       pick_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       pick_inventorytraceop.DEVICEOID DEVICE_OID,
       pick_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION pick_inventorytraceop,
     OBJT_OPERATIONLINK pickop_pickline_link,
     OBJT_PICKOPERATION pickline,
     OBJT_PICKORDER pickorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE pick_inventorytraceop.BOTYPE = 8 -- PICK
AND pickop_pickline_link.CHILDOID = pick_inventorytraceop.OID
AND pickop_pickline_link.PARENTOID = pickline.OID
AND pickorder.OID = pickline.PICKORDEROID
AND pick_inventorytraceop.UOMOID = uom.OID
AND pick_inventorytraceop.LOTOID = lot.OID
/

-- ACTUAL TRANSFEROPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_TRANSFER_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ transfer_inventorytraceop.OID OID,
       pickorder.OID PICKORDER_OID,
       pickline.OID PICKLINE_OID,
       CASE WHEN (pickorder.BOTYPE = 0) THEN 'ORDER'
            WHEN (pickorder.BOTYPE = 1) THEN 'BATCH'
            WHEN (pickorder.BOTYPE = 2) THEN 'WAVE' END AS PICK_TYPE,
       transfer_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       transfer_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       transfer_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       transfer_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       transfer_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       transfer_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       transfer_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       transfer_inventorytraceop.DTSSTART DTSSTART,
       transfer_inventorytraceop.DTSSTOP DTSSTOP,
       transfer_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       transfer_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       transfer_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       transfer_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       transfer_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       transfer_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       transfer_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       transfer_inventorytraceop.DEVICEOID DEVICE_OID,
       transfer_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION transfer_inventorytraceop,
     OBJT_OPERATIONLINK transferop_pickline_link,
     OBJT_PICKOPERATION pickline,
     OBJT_PICKORDER pickorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE transfer_inventorytraceop.BOTYPE = 12 -- TRANSFER
AND transferop_pickline_link.CHILDOID = transfer_inventorytraceop.OID
AND transferop_pickline_link.PARENTOID = pickline.OID
AND pickorder.OID = pickline.PICKORDEROID
AND transfer_inventorytraceop.UOMOID = uom.OID
AND transfer_inventorytraceop.LOTOID = lot.OID
/

-- BACKORDERS --
CREATE OR REPLACE VIEW DCEREPORT_BACKORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ backorder.OID OID,
       outboundorder.OID ORDER_OID,
       'ORDER' ORDER_TYPE,
       backorder.NAME NAME,
       backorder.ID ID,
       backorder.DESCRIPTION DESCRIPTION,
       backorder.STATUS STATUS,
       backorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       backorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       backorder.DTSSTART DTSSTART,
       backorder.DTSSTOP DTSSTOP,
       backorder.DTSDUEBEFORE DTSDUEBEFORE,
       backorder.DTSUPDATE DTSUPDATE
FROM OBJT_BACKORDERORDER backorder,
     OBJT_ORDERLINK orderlink,
     OBJT_OUTBOUNDORDER outboundorder
WHERE orderlink.PARENTOID = outboundorder.OID
AND orderlink.CHILDOID = backorder.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ backorder.OID OID,
       productionorder.OID ORDER_OID,
       'PRODUCTION' ORDER_TYPE,
       backorder.NAME NAME,
       backorder.ID ID,
       backorder.DESCRIPTION DESCRIPTION,
       backorder.STATUS STATUS,
       backorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       backorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       backorder.DTSSTART DTSSTART,
       backorder.DTSSTOP DTSSTOP,
       backorder.DTSDUEBEFORE DTSDUEBEFORE,
       backorder.DTSUPDATE DTSUPDATE
FROM OBJT_BACKORDERORDER backorder,
     OBJT_ORDERLINK orderlink,
     OBJT_PRODUCTIONORDER productionorder
WHERE orderlink.PARENTOID = productionorder.OID
AND orderlink.CHILDOID = backorder.OID
AND productionorder.BOTYPE NOT IN (10,11) -- NOT IN (TYPE_WMS_KIT,TYPE_WMS_VAL)
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ backorder.OID OID,
       makeorder.OID ORDER_OID, -- MTO (VAL/Kit) or MTS (Kit) ORDER
       CASE WHEN makeorder.BOTYPE = 0 THEN 'MTO' ELSE 'MTS' END AS ORDER_TYPE,
       backorder.NAME NAME,
       backorder.ID ID,
       backorder.DESCRIPTION DESCRIPTION,
       backorder.STATUS STATUS,
       backorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       backorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       backorder.DTSSTART DTSSTART,
       backorder.DTSSTOP DTSSTOP,
       backorder.DTSDUEBEFORE DTSDUEBEFORE,
       backorder.DTSUPDATE DTSUPDATE
FROM OBJT_BACKORDERORDER backorder,
     OBJT_MAKEORDER makeorder,
     OBJT_ORDERLINK orderlink
WHERE orderlink.PARENTOID = makeorder.OID
AND orderlink.CHILDOID = backorder.OID
/

-- BACKORDERLINES --
CREATE OR REPLACE VIEW DCEREPORT_BACKORDERLINES
AS
SELECT /*+ FIRST_ROWS(30) */ backorderline.OID OID,
       outboundorder.OID ORDER_OID,
       outboundoperation.OID ORDERLINE_OID,
       'ORDER' ORDER_TYPE,
       backorder.OID BACKORDER_OID,
       backorderline.NAME NAME,
       backorderline.DESCRIPTION DESCRIPTION,
       backorderline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       lot.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       backorderitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       backorderitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       backorderitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       backorderitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       backorderitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       backorderitemqty.QTYTARGET QTYTARGET,
       backorderitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       backorderline.DTSPLANNEDSTART DTSPLANNEDSTART,
       backorderline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       backorderline.DTSSTART DTSSTART,
       backorderline.DTSSTOP DTSSTOP,
       CAST(GREATEST(backorderline.DTSUPDATE, backorderitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       backorderline.DTSUPDATE AS DTSUPDATE_1,
       backorderitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_BACKORDEROPERATION backorderline,
     OBJT_BACKORDERORDER backorder,
     OBJT_OPERATIONLINK backorderline_orderline_link,
     OBJT_OUTBOUNDOPERATION outboundoperation,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_BACKORDERITEMQTY backorderitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE backorderline.BOTYPE = 0 -- TARGET
AND backorder.OID = backorderline.BACKORDERORDEROID
AND backorderline_orderline_link.CHILDOID = backorderline.OID
AND backorderline_orderline_link.PARENTOID = outboundoperation.OID
AND outboundorder.OID = outboundoperation.OUTBOUNDORDEROID
AND backorderline.OID = backorderitemqty.BACKORDEROPERATIONOID
AND backorderitemqty.UOMOID = uom.OID
AND backorderitemqty.LOTOID = lot.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ backorderline.OID OID,
       productionorder.OID ORDER_OID,
       productionoperation.OID ORDERLINE_OID,
       'PRODUCTION' ORDER_TYPE,
       backorder.OID BACKORDER_OID,
       backorderline.NAME NAME,
       backorderline.DESCRIPTION DESCRIPTION,
       backorderline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       lot.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       backorderitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       backorderitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       backorderitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       backorderitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       backorderitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       backorderitemqty.QTYTARGET QTYTARGET,
       backorderitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       backorderline.DTSPLANNEDSTART DTSPLANNEDSTART,
       backorderline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       backorderline.DTSSTART DTSSTART,
       backorderline.DTSSTOP DTSSTOP,
       CAST(GREATEST(backorderline.DTSUPDATE, backorderitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       backorderline.DTSUPDATE AS DTSUPDATE_1,
       backorderitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_BACKORDEROPERATION backorderline,
     OBJT_BACKORDERORDER backorder,
     OBJT_OPERATIONLINK backorderline_orderline_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_PRODUCTIONORDER productionorder,
     OBJT_BACKORDERITEMQTY backorderitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE backorderline.BOTYPE = 0 -- TARGET
AND backorder.OID = backorderline.BACKORDERORDEROID
AND backorderline_orderline_link.CHILDOID = backorderline.OID
AND backorderline_orderline_link.PARENTOID = productionoperation.OID
AND productionorder.OID = productionoperation.PRODUCTIONORDEROID
AND productionorder.BOTYPE NOT IN (10,11) -- NOT IN (TYPE_WMS_KIT,TYPE_WMS_VAL)
AND backorderline.OID = backorderitemqty.BACKORDEROPERATIONOID
AND backorderitemqty.UOMOID = uom.OID
AND backorderitemqty.LOTOID = lot.OID
UNION ALL -- SELECT ALL BACKORDERLINES FOR MTO or MTS ORDERS --
SELECT /*+ FIRST_ROWS(30) */ backorderline.OID OID,
       makeorder.OID ORDER_OID, -- VAL/KIT MTO or MTS Order
       makeoperation.OID ORDERLINE_OID, -- VAL/KIT MTO or MTS LINE
       CASE WHEN (makeorder.BOTYPE = 0) THEN 'MTO' ELSE 'MTS' END AS ORDER_TYPE,
       backorder.OID BACKORDER_OID,
       backorderline.NAME NAME,
       backorderline.DESCRIPTION DESCRIPTION,
       backorderline.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       lot.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       backorderitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       backorderitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       backorderitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       backorderitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       backorderitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       backorderitemqty.QTYTARGET QTYTARGET,
       backorderitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       backorderline.DTSPLANNEDSTART DTSPLANNEDSTART,
       backorderline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       backorderline.DTSSTART DTSSTART,
       backorderline.DTSSTOP DTSSTOP,
       CAST(GREATEST(backorderline.DTSUPDATE, backorderitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       backorderline.DTSUPDATE AS DTSUPDATE_1,
       backorderitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_BACKORDEROPERATION backorderline,
     OBJT_BACKORDERORDER backorder,
     OBJT_OPERATIONLINK make_backorderop_link,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_MAKEORDER makeorder,
     OBJT_BACKORDERITEMQTY backorderitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE backorderline.BOTYPE = 0 -- TARGET
AND backorder.OID = backorderline.BACKORDERORDEROID
AND backorderline.OID = make_backorderop_link.CHILDOID
AND make_backorderop_link.PARENTOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
AND backorderline.OID = backorderitemqty.BACKORDEROPERATIONOID
AND backorderitemqty.UOMOID = uom.OID
AND backorderitemqty.LOTOID = lot.OID
/

-- PACKORDERS --

CREATE OR REPLACE VIEW DCEREPORT_PACKORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ packorder.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       processresource.OID PROCESSRESOURCE_OID,
       packorder.NAME NAME,
       packorder.ID ID,
       packorder.DESCRIPTION DESCRIPTION,
       packorder.STATUS STATUS,
       packorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       packorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       packorder.DTSSTART DTSSTART,
       packorder.DTSSTOP DTSTSTOP,
       packorder.DTSDUEBEFORE DTSDUEBEFORE,
       packorder.DTSUPDATE DTSUPDATE
FROM OBJT_PACKORDER packorder,
     OBJT_ORDERLINK orderlink,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_ORDERRESOURCELINK orderresourcelink,
     OBJT_PROCESSUNIT processresource
WHERE orderlink.PARENTOID = outboundorder.OID
AND orderlink.CHILDOID = packorder.OID
AND packorder.OID = orderresourcelink.ORDEROID
AND orderresourcelink.RESOURCEOID = processresource.OID
/

-- PACKLINES --

CREATE OR REPLACE VIEW DCEREPORT_PACKLINES
AS
SELECT /*+ FIRST_ROWS(30) */ packoperation.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       outboundoperation.OID OUTBOUNDLINE_OID,
       packorder.OID PACKORDER_OID,
       packoperation.NAME NAME,
       packoperation.DESCRIPTION DESCRIPTION,
       packoperation.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       packitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       packitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       packitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       packitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       packitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       packitemqty.QTYRESERVED QTYRESERVED,
       packitemqty.QTYPICKED QTYPICKED,
       packitemqty.QTYTARGET QTYTARGET,
       packitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       packoperation.DTSPLANNEDSTART DTSPLANNEDSTART,
       packoperation.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       packoperation.DTSSTART DTSSTART,
       packoperation.DTSSTOP DTSSTOP,
       CAST(GREATEST(packoperation.DTSUPDATE, packitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       packoperation.DTSUPDATE AS DTSUPDATE_1,
       packitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_PACKOPERATION packoperation,
     OBJT_PACKORDER packorder,
     OBJT_OPERATIONLINK pickop_packop_link,
     OBJT_OPERATIONLINK outboundop_pickop_link,
     OBJT_OUTBOUNDOPERATION outboundoperation,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_PACKITEMQTY packitemqty,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE packoperation.BOTYPE = 0 -- TARGET
AND packorder.OID = packoperation.PACKORDEROID
AND pickop_packop_link.CHILDOID = packoperation.OID
AND pickop_packop_link.PARENTOID = outboundop_pickop_link.CHILDOID -- pickop_packop_link.PARENTOID = pickoperation.OID = outboundoper_pickop_link.CHILDOID
AND outboundop_pickop_link.PARENTOID = outboundoperation.OID
AND outboundorder.OID = outboundoperation.OUTBOUNDORDEROID
AND packoperation.OID = packitemqty.PACKOPERATIONOID
AND packitemqty.UOMOID = uom.OID
AND packitemqty.LOTOID = lot.OID
/

-- ACTUAL PACKOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_PACK_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ pack_inventorytraceop.OID OID,
       packorder.OID PACKORDER_OID,
       packline.OID PACKLINE_OID,
       pack_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       pack_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       pack_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       pack_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       pack_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       pack_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       pack_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       pack_inventorytraceop.DTSSTART DTSSTART,
       pack_inventorytraceop.DTSSTOP DTSSTOP,
       pack_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       pack_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       pack_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       pack_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       pack_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       pack_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       pack_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       pack_inventorytraceop.DEVICEOID DEVICE_OID,
       pack_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION pack_inventorytraceop,
     OBJT_OPERATIONLINK packop_packline_link,
     OBJT_PACKOPERATION packline,
     OBJT_PACKORDER packorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE pack_inventorytraceop.BOTYPE = 11 -- PACK
AND packop_packline_link.CHILDOID = pack_inventorytraceop.OID
AND packop_packline_link.PARENTOID = packline.OID
AND packorder.OID = packline.PACKORDEROID
AND pack_inventorytraceop.UOMOID = uom.OID
AND pack_inventorytraceop.LOTOID = lot.OID
/

-- DELIVERYORDERS --

CREATE OR REPLACE VIEW DCEREPORT_DELIVERYORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ deliveryorder.OID OID,
       deliveryorder.NAME NAME,
       deliveryorder.ID ID,
       deliveryorder.DESCRIPTION DESCRIPTION,
       carrier.OID CARRIER_OID,
       deliveryorder.STATUS STATUS,
       deliveryorder.DTSPLANNEDSTART DTSPLANNEDSTART,
       deliveryorder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       deliveryorder.DTSSTART DTSTART,
       deliveryorder.DTSSTOP DTSSTOP,
       deliveryorder.DTSDUEBEFORE DTSDUEBEFORE,
       deliveryorder.DTSUPDATE DTSUPDATE
FROM (OBJT_DELIVERYORDER deliveryorder
   LEFT OUTER JOIN OBJT_ORDERRESOURCELINK ordreslink ON deliveryorder.OID = ordreslink.ORDEROID)
        LEFT OUTER JOIN OBJT_CARRIER carrier ON ordreslink.RESOURCEOID = carrier.OID
/

-- SHIPORDERS --

CREATE OR REPLACE VIEW DCEREPORT_SHIPORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ shiporder.OID OID,
       deliveryorder.OID DELIVERYORDER_OID,
       shiporder.NAME NAME,
       shiporder.ID ID,
       CAST((SELECT carrier.OID  FROM OBJT_CARRIER carrier, OBJT_ORDERRESOURCELINK shiporder_carrier_link
                            WHERE shiporder_carrier_link.RESOURCEOID = carrier.OID
                            AND shiporder_carrier_link.ORDEROID = shiporder.OID AND ROWNUM = 1) AS NUMBER(19)) AS CARRIER_OID,
       shiporder.TRUCKID TRUCKID,
       CAST((SELECT location.OID FROM OBJT_WAREHOUSELOCATION location, OBJT_ORDERRESOURCELINK shiporder_location_link
                            WHERE shiporder_location_link.RESOURCEOID = location.OID
                            AND shiporder_location_link.ORDEROID = shiporder.OID AND ROWNUM = 1) AS NUMBER(19)) AS TO_LOCATION_OID,
       DECODE(BITAND(shiporder.ORDEROPTION, 1), 1, 'T', 'F') AS SEQUENCED,
       shiporder.DESCRIPTION DESCRIPTION,
       shiporder.STATUS STATUS,
       shiporder.DTSPLANNEDSTART DTSPLANNEDSTART,
       shiporder.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       shiporder.DTSSTART DTSSTART,
       shiporder.DTSSTOP DTSSTOP,
       shiporder.DTSDUEBEFORE DTSDUEBEFORE,
       shiporder.DTSUPDATE DTSUPDATE,
       shiporder.USRDTS1 USRDTS1,
       shiporder.USRDTS2 USRDTS2,
       shiporder.USRDTS3 USRDTS3,
       shiporder.USRDTS4 USRDTS4,
       shiporder.USRDTS5 USRDTS5,
       shiporder.USRFLG1 USRFLG1,
       shiporder.USRFLG2 USRFLG2,
       shiporder.USRFLG3 USRFLG3,
       shiporder.USRFLG4 USRFLG4,
       shiporder.USRFLG5 USRFLG5,
       shiporder.USRNUM1 USRNUM1,
       shiporder.USRNUM2 USRNUM2,
       shiporder.USRNUM3 USRNUM3,
       shiporder.USRNUM4 USRNUM4,
       shiporder.USRNUM5 USRNUM5,
       shiporder.USRTXT1 USRTXT1,
       shiporder.USRTXT2 USRTXT2,
       shiporder.USRTXT3 USRTXT3,
       shiporder.USRTXT4 USRTXT4,
       shiporder.USRTXT5 USRTXT5
FROM  (OBJT_SHIPORDER shiporder
        LEFT JOIN OBJT_ORDERLINK orderlink ON shiporder.OID = orderlink.CHILDOID)
  LEFT JOIN OBJT_DELIVERYORDER deliveryorder ON orderlink.PARENTOID = deliveryorder.OID
/

-- SHIPLINES --

CREATE OR REPLACE VIEW DCEREPORT_SHIPLINES
AS
SELECT /*+ FIRST_ROWS(30) */ shipline.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       outboundline.OID OUTBOUNDLINE_OID,
       shiporder.OID SHIPORDER_OID,
       shipline.NAME NAME,
       shipline.DESCRIPTION DESCRIPTION,
       shipline.STATUS STATUS,
       shipitemqty.ITEMOID ITEM_OID,
       shipitemqty.QTYTARGET QTYTARGET,
       shipitemqty.VALUE QTY,
       uom.SYMBOL UOM,
       shipline.DTSPLANNEDSTART DTSPLANNEDSTART,
       shipline.DTSSCHEDULEDSTART DTSSCHEDULEDSTART,
       shipline.DTSSTART DTSSTART,
       shipline.DTSSTOP DTSSTOP,
       shipline.USRDTS1 USRDTS1,
       shipline.USRDTS2 USRDTS2,
       shipline.USRDTS3 USRDTS3,
       shipline.USRDTS4 USRDTS4,
       shipline.USRDTS5 USRDTS5,
       shipline.USRFLG1 USRFLG1,
       shipline.USRFLG2 USRFLG2,
       shipline.USRFLG3 USRFLG3,
       shipline.USRFLG4 USRFLG4,
       shipline.USRFLG5 USRFLG5,
       shipline.USRNUM1 USRNUM1,
       shipline.USRNUM2 USRNUM2,
       shipline.USRNUM3 USRNUM3,
       shipline.USRNUM4 USRNUM4,
       shipline.USRNUM5 USRNUM5,
       shipline.USRTXT1 USRTXT1,
       shipline.USRTXT2 USRTXT2,
       shipline.USRTXT3 USRTXT3,
       shipline.USRTXT4 USRTXT4,
       shipline.USRTXT5 USRTXT5,
       CAST(GREATEST(shipline.DTSUPDATE, shipitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       shipline.DTSUPDATE AS DTSUPDATE_1,
       shipitemqty.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_SHIPOPERATION shipline,
     OBJT_SHIPORDER shiporder,
     OBJT_OPERATIONLINK shipline_outboundline_link,
     OBJT_OUTBOUNDOPERATION outboundline,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_SHIPITEMQTY shipitemqty,
     OBJT_UOM uom
WHERE shipline.BOTYPE = 0 -- TARGET
AND shiporder.OID = shipline.SHIPORDEROID
AND shipline_outboundline_link.PARENTOID = shipline.OID
AND shipline_outboundline_link.CHILDOID = outboundline.OID
AND outboundorder.OID = outboundline.OUTBOUNDORDEROID
AND shipline.OID = shipitemqty.SHIPOPERATIONOID
AND shipitemqty.UOMOID = uom.OID
/

-- ACTUAL SHIPOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_SHIP_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ ship_inventorytraceop.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       outboundline.OID OUTBOUNDLINE_OID,
       shiporder.OID SHIPORDER_OID,
       shipline.OID SHIPLINE_OID,
       ship_inventorytraceop.CATEGORY CATEGORY,
       ship_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       ship_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       ship_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       ship_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       ship_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       ship_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       ship_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       ship_inventorytraceop.DTSSTART DTSSTART,
       ship_inventorytraceop.DTSSTOP DTSSTOP,
       ship_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       ship_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       ship_inventorytraceop.TOCSITQOID CONTAINER_OID,
       ship_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       ship_inventorytraceop.DEVICEOID DEVICE_OID,
       ship_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION ship_inventorytraceop,
     OBJT_OPERATIONLINK shipop_shipline_link,
     OBJT_SHIPOPERATION shipline,
     OBJT_SHIPORDER shiporder,
     OBJT_OPERATIONLINK shipline_outboundline_link,
     OBJT_OUTBOUNDOPERATION outboundline,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE ship_inventorytraceop.BOTYPE IN (4, 5) -- LOAD, UNLOAD
AND shipop_shipline_link.CHILDOID = ship_inventorytraceop.OID
AND shipop_shipline_link.PARENTOID = shipline.OID
AND shiporder.OID = shipline.SHIPORDEROID
AND shipline_outboundline_link.PARENTOID = shipline.OID
AND shipline_outboundline_link.CHILDOID = outboundline.OID
AND outboundorder.OID = outboundline.OUTBOUNDORDEROID
AND ship_inventorytraceop.UOMOID = uom.OID
AND ship_inventorytraceop.LOTOID = lot.OID
/

-- ACTUAL REPLENISHOPERATIONS --

CREATE OR REPLACE VIEW DCEREPORT_REPLENISH_ACTUALS
AS
SELECT replenish_inventorytraceop.OID OID,
       replenish_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       replenish_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       replenish_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       replenish_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       replenish_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       replenish_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       replenish_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       replenish_inventorytraceop.DTSSTART DTSSTART,
       replenish_inventorytraceop.DTSSTOP DTSSTOP,
       replenish_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       replenish_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       replenish_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       replenish_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       replenish_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       replenish_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       replenish_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       replenish_inventorytraceop.DEVICEOID DEVICE_OID,
       replenish_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION replenish_inventorytraceop,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE replenish_inventorytraceop.BOTYPE = 14 -- REPLENISH
AND replenish_inventorytraceop.UOMOID = uom.OID
AND replenish_inventorytraceop.LOTOID = lot.OID
/


-- TASK REASONS --

CREATE OR REPLACE VIEW DCEREPORT_TASKREASONS
AS
SELECT taskreason.OID OID,
       taskreason.NAME NAME,
       taskreason.ID ID,
       taskreason.DESCRIPTION DESCRIPTION,
       taskreason.CATEGORY CATEGORY,
       taskreasongroup.NAME REASONGROUP_NAME,
       taskreasongroup.DESCRIPTION REASONGROUP_DESCRIPTION,
       taskreasongroup.USRDTS1 USRDTS1,
       taskreasongroup.USRDTS2 USRDTS2,
       taskreasongroup.USRDTS3 USRDTS3,
       taskreasongroup.USRDTS4 USRDTS4,
       taskreasongroup.USRDTS5 USRDTS5,
       taskreasongroup.USRFLG1 USRFLG1,
       taskreasongroup.USRFLG2 USRFLG2,
       taskreasongroup.USRFLG3 USRFLG3,
       taskreasongroup.USRFLG4 USRFLG4,
       taskreasongroup.USRFLG5 USRFLG5,
       taskreasongroup.USRNUM1 USRNUM1,
       taskreasongroup.USRNUM2 USRNUM2,
       taskreasongroup.USRNUM3 USRNUM3,
       taskreasongroup.USRNUM4 USRNUM4,
       taskreasongroup.USRNUM5 USRNUM5,
       taskreasongroup.USRTXT1 USRTXT1,
       taskreasongroup.USRTXT2 USRTXT2,
       taskreasongroup.USRTXT3 USRTXT3,
       taskreasongroup.USRTXT4 USRTXT4,
       taskreasongroup.USRTXT5 USRTXT5,
       taskreason.DTSVALIDFROM DTSVALIDFROM,
       taskreason.DTSVALIDUNTIL DTSVALIDUNTIL,
       CAST(GREATEST(taskreason.DTSUPDATE, taskreasongroup.DTSUPDATE) AS DATE) DTSUPDATE,
       taskreason.DTSUPDATE AS DTSUPDATE_1,
       taskreasongroup.DTSUPDATE AS DTSUPDATE_2
FROM OBJT_TASKREASON taskreason,
     OBJT_REASONGROUP taskreasongroup
WHERE taskreason.GROUPOID = taskreasongroup.OID
/


-- TASKS --

CREATE OR REPLACE VIEW DCEREPORT_TASKS
AS
SELECT /*+ FIRST_ROWS(30) */ task.OID OID,
       tasktype.category TASK_TYPE,
       CASE WHEN (task.BOTYPE = 10) THEN 'LPN'
            WHEN (task.BOTYPE = 11) THEN 'SKU' END AS TYPE,
       task.ORDEROID ORDER_OID,
       task.WORKZONEOID WORKZONE_OID,
       CASE WHEN (task.SUBSTATUS IS NOT NULL) THEN task.SUBSTATUS
            ELSE task.STATUS END AS STATUS,
       task.ITEMOID ITEM_OID,
       task.REASONOID REASON_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       storageitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       storageitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       storageitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       storageitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       storageitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       task.qty QTY,
       CASE WHEN (task.BOTYPE = 10) THEN 'LPN'
            WHEN (task.BOTYPE = 11) THEN CAST((SELECT uom.SYMBOL FROM OBJT_ITEMUOMLINK itemuomlink, OBJT_UOM uom
                                          WHERE itemuomlink.ITEMOID = task.ITEMOID AND itemuomlink.UOMOID = uom.OID 
                                          AND itemuomlink.SEQ = 0 AND ROWNUM = 1) AS VARCHAR2(32)) END AS UOM,
       task.DTSSTART DTSSTART,
       task.DTSSTOP DTSSTOP,
       task.SOURCELOCATIONOID FROM_LOCATION_OID,
       task.TARGETLOCATIONOID TO_LOCATION_OID,
       task.CONTAINERSTORAGEITEMQTYOID CONTAINER_OID,
       task.EMPLOYEEOID EMPLOYEE_OID,
       task.DEVICEOID DEVICE_OID,
       CAST(GREATEST(task.DTSUPDATE, NVL(storageitemqty.DTSUPDATE, task.DTSUPDATE)) AS DATE) DTSUPDATE,
       task.DTSUPDATE AS DTSUPDATE_1,
       storageitemqty.DTSUPDATE AS DTSUPDATE_2
FROM (OBJT_TASK task
        LEFT JOIN OBJT_STORAGEITEMQTY storageitemqty ON task.storageitemqtyoid = storageitemqty.OID )
          LEFT JOIN OBJT_LOT lot ON storageitemqty.LOTOID = lot.OID,
     OBJT_TASKTYPE tasktype
WHERE task.OPERATIONOID = tasktype.OID
/


-- WAREHOUSMGT VIEWS --

-- WAREHOUSES --

CREATE OR REPLACE VIEW DCEREPORT_WAREHOUSES
AS
SELECT /*+ FIRST_ROWS(30) */ warehouse.OID OID,
       warehouse.NAME NAME,
       warehouse.DESCRIPTION DESCRIPTION,
       warehouse.ID ID,
       warehouse.CATEGORY CATEGORY,
       warehouse.ISNETTABLE ISNETTABLE,
       warehouse.DTSVALIDFROM DTSVALIDFROM,
       warehouse.DTSVALIDUNTIL DTSVALIDUNTIL,
       warehouse.DTSUPDATE DTSUPDATE,
       department.OID as DEPARTMENT_OID,
       department.NAME as DEPARTMENT_NAME,
       warehouse.USRDTS1 USRDTS1,
       warehouse.USRDTS2 USRDTS2,
       warehouse.USRDTS3 USRDTS3,
       warehouse.USRDTS4 USRDTS4,
       warehouse.USRDTS5 USRDTS5,
       warehouse.USRDTS6 USRDTS6,
       warehouse.USRDTS7 USRDTS7,
       warehouse.USRDTS8 USRDTS8,
       warehouse.USRDTS9 USRDTS9,
       warehouse.USRDTS10 USRDTS10,
       warehouse.USRDTS11 USRDTS11,
       warehouse.USRDTS12 USRDTS12,
       warehouse.USRDTS13 USRDTS13,
       warehouse.USRDTS14 USRDTS14,
       warehouse.USRDTS15 USRDTS15,
       warehouse.USRDTS16 USRDTS16,
       warehouse.USRDTS17 USRDTS17,
       warehouse.USRDTS18 USRDTS18,
       warehouse.USRDTS19 USRDTS19,
       warehouse.USRDTS20 USRDTS20,
       warehouse.USRDTS21 USRDTS21,
       warehouse.USRDTS22 USRDTS22,
       warehouse.USRDTS23 USRDTS23,
       warehouse.USRDTS24 USRDTS24,
       warehouse.USRDTS25 USRDTS25,
       warehouse.USRDTS26 USRDTS26,
       warehouse.USRDTS27 USRDTS27,
       warehouse.USRDTS28 USRDTS28,
       warehouse.USRDTS29 USRDTS29,
       warehouse.USRDTS30 USRDTS30,
       warehouse.USRFLG1 USRFLG1,
       warehouse.USRFLG2 USRFLG2,
       warehouse.USRFLG3 USRFLG3,
       warehouse.USRFLG4 USRFLG4,
       warehouse.USRFLG5 USRFLG5,
       warehouse.USRFLG6 USRFLG6,
       warehouse.USRFLG7 USRFLG7,
       warehouse.USRFLG8 USRFLG8,
       warehouse.USRFLG9 USRFLG9,
       warehouse.USRFLG10 USRFLG10,
       warehouse.USRFLG11 USRFLG11,
       warehouse.USRFLG12 USRFLG12,
       warehouse.USRFLG13 USRFLG13,
       warehouse.USRFLG14 USRFLG14,
       warehouse.USRFLG15 USRFLG15,
       warehouse.USRFLG16 USRFLG16,
       warehouse.USRFLG17 USRFLG17,
       warehouse.USRFLG18 USRFLG18,
       warehouse.USRFLG19 USRFLG19,
       warehouse.USRFLG20 USRFLG20,
       warehouse.USRFLG21 USRFLG21,
       warehouse.USRFLG22 USRFLG22,
       warehouse.USRFLG23 USRFLG23,
       warehouse.USRFLG24 USRFLG24,
       warehouse.USRFLG25 USRFLG25,
       warehouse.USRFLG26 USRFLG26,
       warehouse.USRFLG27 USRFLG27,
       warehouse.USRFLG28 USRFLG28,
       warehouse.USRFLG29 USRFLG29,
       warehouse.USRFLG30 USRFLG30,
       warehouse.USRNUM1 USRNUM1,
       warehouse.USRNUM2 USRNUM2,
       warehouse.USRNUM3 USRNUM3,
       warehouse.USRNUM4 USRNUM4,
       warehouse.USRNUM5 USRNUM5,
       warehouse.USRNUM6 USRNUM6,
       warehouse.USRNUM7 USRNUM7,
       warehouse.USRNUM8 USRNUM8,
       warehouse.USRNUM9 USRNUM9,
       warehouse.USRNUM10 USRNUM10,
       warehouse.USRNUM11 USRNUM11,
       warehouse.USRNUM12 USRNUM12,
       warehouse.USRNUM13 USRNUM13,
       warehouse.USRNUM14 USRNUM14,
       warehouse.USRNUM15 USRNUM15,
       warehouse.USRNUM16 USRNUM16,
       warehouse.USRNUM17 USRNUM17,
       warehouse.USRNUM18 USRNUM18,
       warehouse.USRNUM19 USRNUM19,
       warehouse.USRNUM20 USRNUM20,
       warehouse.USRNUM21 USRNUM21,
       warehouse.USRNUM22 USRNUM22,
       warehouse.USRNUM23 USRNUM23,
       warehouse.USRNUM24 USRNUM24,
       warehouse.USRNUM25 USRNUM25,
       warehouse.USRNUM26 USRNUM26,
       warehouse.USRNUM27 USRNUM27,
       warehouse.USRNUM28 USRNUM28,
       warehouse.USRNUM29 USRNUM29,
       warehouse.USRNUM30 USRNUM30,
       warehouse.USRNUM31 USRNUM31,
       warehouse.USRNUM32 USRNUM32,
       warehouse.USRNUM33 USRNUM33,
       warehouse.USRNUM34 USRNUM34,
       warehouse.USRNUM35 USRNUM35,
       warehouse.USRNUM36 USRNUM36,
       warehouse.USRNUM37 USRNUM37,
       warehouse.USRNUM38 USRNUM38,
       warehouse.USRNUM39 USRNUM39,
       warehouse.USRNUM40 USRNUM40,
       warehouse.USRNUM41 USRNUM41,
       warehouse.USRNUM42 USRNUM42,
       warehouse.USRNUM43 USRNUM43,
       warehouse.USRNUM44 USRNUM44,
       warehouse.USRNUM45 USRNUM45,
       warehouse.USRNUM46 USRNUM46,
       warehouse.USRNUM47 USRNUM47,
       warehouse.USRNUM48 USRNUM48,
       warehouse.USRNUM49 USRNUM49,
       warehouse.USRNUM50 USRNUM50,
       warehouse.USRNUM51 USRNUM51,
       warehouse.USRNUM52 USRNUM52,
       warehouse.USRNUM53 USRNUM53,
       warehouse.USRNUM54 USRNUM54,
       warehouse.USRNUM55 USRNUM55,
       warehouse.USRNUM56 USRNUM56,
       warehouse.USRNUM57 USRNUM57,
       warehouse.USRNUM58 USRNUM58,
       warehouse.USRNUM59 USRNUM59,
       warehouse.USRNUM60 USRNUM60,
       warehouse.USRNUM61 USRNUM61,
       warehouse.USRNUM62 USRNUM62,
       warehouse.USRNUM63 USRNUM63,
       warehouse.USRNUM64 USRNUM64,
       warehouse.USRNUM65 USRNUM65,
       warehouse.USRTXT1 USRTXT1,
       warehouse.USRTXT2 USRTXT2,
       warehouse.USRTXT3 USRTXT3,
       warehouse.USRTXT4 USRTXT4,
       warehouse.USRTXT5 USRTXT5,
       warehouse.USRTXT6 USRTXT6,
       warehouse.USRTXT7 USRTXT7,
       warehouse.USRTXT8 USRTXT8,
       warehouse.USRTXT9 USRTXT9,
       warehouse.USRTXT10 USRTXT10,
       warehouse.USRTXT11 USRTXT11,
       warehouse.USRTXT12 USRTXT12,
       warehouse.USRTXT13 USRTXT13,
       warehouse.USRTXT14 USRTXT14,
       warehouse.USRTXT15 USRTXT15,
       warehouse.USRTXT16 USRTXT16,
       warehouse.USRTXT17 USRTXT17,
       warehouse.USRTXT18 USRTXT18,
       warehouse.USRTXT19 USRTXT19,
       warehouse.USRTXT20 USRTXT20,
       warehouse.USRTXT21 USRTXT21,
       warehouse.USRTXT22 USRTXT22,
       warehouse.USRTXT23 USRTXT23,
       warehouse.USRTXT24 USRTXT24,
       warehouse.USRTXT25 USRTXT25,
       warehouse.USRTXT26 USRTXT26,
       warehouse.USRTXT27 USRTXT27,
       warehouse.USRTXT28 USRTXT28,
       warehouse.USRTXT29 USRTXT29,
       warehouse.USRTXT30 USRTXT30,
       warehouse.USRTXT31 USRTXT31,
       warehouse.USRTXT32 USRTXT32,
       warehouse.USRTXT33 USRTXT33,
       warehouse.USRTXT34 USRTXT34,
       warehouse.USRTXT35 USRTXT35,
       warehouse.USRTXT36 USRTXT36,
       warehouse.USRTXT37 USRTXT37,
       warehouse.USRTXT38 USRTXT38,
       warehouse.USRTXT39 USRTXT39,
       warehouse.USRTXT40 USRTXT40,
       warehouse.USRTXT41 USRTXT41,
       warehouse.USRTXT42 USRTXT42,
       warehouse.USRTXT43 USRTXT43,
       warehouse.USRTXT44 USRTXT44,
       warehouse.USRTXT45 USRTXT45,
       warehouse.USRTXT46 USRTXT46,
       warehouse.USRTXT47 USRTXT47,
       warehouse.USRTXT48 USRTXT48,
       warehouse.USRTXT49 USRTXT49,
       warehouse.USRTXT50 USRTXT50,
       warehouse.USRTXT51 USRTXT51,
       warehouse.USRTXT52 USRTXT52,
       warehouse.USRTXT53 USRTXT53,
       warehouse.USRTXT54 USRTXT54,
       warehouse.USRTXT55 USRTXT55,
       warehouse.USRTXT56 USRTXT56,
       warehouse.USRTXT57 USRTXT57,
       warehouse.USRTXT58 USRTXT58,
       warehouse.USRTXT59 USRTXT59,
       warehouse.USRTXT60 USRTXT60,
       warehouse.USRTXT61 USRTXT61,
       warehouse.USRTXT62 USRTXT62,
       warehouse.USRTXT63 USRTXT63,
       warehouse.USRTXT64 USRTXT64,
       warehouse.USRTXT65 USRTXT65
FROM OBJT_WAREHOUSE warehouse
LEFT OUTER JOIN OBJT_RESOURCELINK departmentwarehouselink on warehouse.oid = departmentwarehouselink.CHILDOID and departmentwarehouselink.PARENTCLASSNAME = 'dce.bo.resourcemgt.Department'
LEFT OUTER JOIN OBJT_DEPARTMENT department on departmentwarehouselink.PARENTOID = department.oid
WHERE warehouse.NAME <> 'SYSTEM'
/

-- LOCATIONS --

CREATE OR REPLACE VIEW DCEREPORT_LOCATIONS
AS
SELECT /*+ FIRST_ROWS(30) */ warehouselocation.OID OID,
       warehouse.OID WAREHOUSE_OID,
       warehouselocation.NAME NAME,
       warehouselocation.DESCRIPTION DESCRIPTION,
       warehouselocation.ID ID,
       warehouselocation.FULLNAME FULLNAME,
       warehouselocation.CATEGORY CATEGORY,
       CASE WHEN (warehouselocation.BINTYPE = 0) THEN 'GENERAL'
            WHEN (warehouselocation.BINTYPE = 1) THEN 'SILO'
            WHEN (warehouselocation.BINTYPE = 2) THEN 'FIFO'
            WHEN (warehouselocation.BINTYPE = 3) THEN 'LIFO'
            WHEN (warehouselocation.BINTYPE = 4) THEN 'AUTO REMOVE' END AS BINTYPE,
       CASE WHEN (warehouselocation.BOTYPE = 10) THEN 'AISLE'
            WHEN (warehouselocation.BOTYPE = 20) THEN 'RACK'
            WHEN (warehouselocation.BOTYPE = 30) THEN 'SHELF'
            WHEN (warehouselocation.BOTYPE = 40) THEN 'BIN' END AS TYPE,
       warehouselocation.DTSVALIDFROM DTSVALIDFROM,
       warehouselocation.DTSVALIDUNTIL DTSVALIDUNTIL,
       warehouselocation.DTSUPDATE DTSUPDATE,
       warehouselocation.USRDTS1 USRDTS1,
       warehouselocation.USRDTS2 USRDTS2,
       warehouselocation.USRDTS3 USRDTS3,
       warehouselocation.USRDTS4 USRDTS4,
       warehouselocation.USRDTS5 USRDTS5,
       warehouselocation.USRDTS6 USRDTS6,
       warehouselocation.USRDTS7 USRDTS7,
       warehouselocation.USRDTS8 USRDTS8,
       warehouselocation.USRDTS9 USRDTS9,
       warehouselocation.USRDTS10 USRDTS10,
       warehouselocation.USRDTS11 USRDTS11,
       warehouselocation.USRDTS12 USRDTS12,
       warehouselocation.USRDTS13 USRDTS13,
       warehouselocation.USRDTS14 USRDTS14,
       warehouselocation.USRDTS15 USRDTS15,
       warehouselocation.USRDTS16 USRDTS16,
       warehouselocation.USRDTS17 USRDTS17,
       warehouselocation.USRDTS18 USRDTS18,
       warehouselocation.USRDTS19 USRDTS19,
       warehouselocation.USRDTS20 USRDTS20,
       warehouselocation.USRDTS21 USRDTS21,
       warehouselocation.USRDTS22 USRDTS22,
       warehouselocation.USRDTS23 USRDTS23,
       warehouselocation.USRDTS24 USRDTS24,
       warehouselocation.USRDTS25 USRDTS25,
       warehouselocation.USRDTS26 USRDTS26,
       warehouselocation.USRDTS27 USRDTS27,
       warehouselocation.USRDTS28 USRDTS28,
       warehouselocation.USRDTS29 USRDTS29,
       warehouselocation.USRDTS30 USRDTS30,
       warehouselocation.USRFLG1 USRFLG1,
       warehouselocation.USRFLG2 USRFLG2,
       warehouselocation.USRFLG3 USRFLG3,
       warehouselocation.USRFLG4 USRFLG4,
       warehouselocation.USRFLG5 USRFLG5,
       warehouselocation.USRFLG6 USRFLG6,
       warehouselocation.USRFLG7 USRFLG7,
       warehouselocation.USRFLG8 USRFLG8,
       warehouselocation.USRFLG9 USRFLG9,
       warehouselocation.USRFLG10 USRFLG10,
       warehouselocation.USRFLG11 USRFLG11,
       warehouselocation.USRFLG12 USRFLG12,
       warehouselocation.USRFLG13 USRFLG13,
       warehouselocation.USRFLG14 USRFLG14,
       warehouselocation.USRFLG15 USRFLG15,
       warehouselocation.USRFLG16 USRFLG16,
       warehouselocation.USRFLG17 USRFLG17,
       warehouselocation.USRFLG18 USRFLG18,
       warehouselocation.USRFLG19 USRFLG19,
       warehouselocation.USRFLG20 USRFLG20,
       warehouselocation.USRFLG21 USRFLG21,
       warehouselocation.USRFLG22 USRFLG22,
       warehouselocation.USRFLG23 USRFLG23,
       warehouselocation.USRFLG24 USRFLG24,
       warehouselocation.USRFLG25 USRFLG25,
       warehouselocation.USRFLG26 USRFLG26,
       warehouselocation.USRFLG27 USRFLG27,
       warehouselocation.USRFLG28 USRFLG28,
       warehouselocation.USRFLG29 USRFLG29,
       warehouselocation.USRFLG30 USRFLG30,
       warehouselocation.USRNUM1 USRNUM1,
       warehouselocation.USRNUM2 USRNUM2,
       warehouselocation.USRNUM3 USRNUM3,
       warehouselocation.USRNUM4 USRNUM4,
       warehouselocation.USRNUM5 USRNUM5,
       warehouselocation.USRNUM6 USRNUM6,
       warehouselocation.USRNUM7 USRNUM7,
       warehouselocation.USRNUM8 USRNUM8,
       warehouselocation.USRNUM9 USRNUM9,
       warehouselocation.USRNUM10 USRNUM10,
       warehouselocation.USRNUM11 USRNUM11,
       warehouselocation.USRNUM12 USRNUM12,
       warehouselocation.USRNUM13 USRNUM13,
       warehouselocation.USRNUM14 USRNUM14,
       warehouselocation.USRNUM15 USRNUM15,
       warehouselocation.USRNUM16 USRNUM16,
       warehouselocation.USRNUM17 USRNUM17,
       warehouselocation.USRNUM18 USRNUM18,
       warehouselocation.USRNUM19 USRNUM19,
       warehouselocation.USRNUM20 USRNUM20,
       warehouselocation.USRNUM21 USRNUM21,
       warehouselocation.USRNUM22 USRNUM22,
       warehouselocation.USRNUM23 USRNUM23,
       warehouselocation.USRNUM24 USRNUM24,
       warehouselocation.USRNUM25 USRNUM25,
       warehouselocation.USRNUM26 USRNUM26,
       warehouselocation.USRNUM27 USRNUM27,
       warehouselocation.USRNUM28 USRNUM28,
       warehouselocation.USRNUM29 USRNUM29,
       warehouselocation.USRNUM30 USRNUM30,
       warehouselocation.USRNUM31 USRNUM31,
       warehouselocation.USRNUM32 USRNUM32,
       warehouselocation.USRNUM33 USRNUM33,
       warehouselocation.USRNUM34 USRNUM34,
       warehouselocation.USRNUM35 USRNUM35,
       warehouselocation.USRNUM36 USRNUM36,
       warehouselocation.USRNUM37 USRNUM37,
       warehouselocation.USRNUM38 USRNUM38,
       warehouselocation.USRNUM39 USRNUM39,
       warehouselocation.USRNUM40 USRNUM40,
       warehouselocation.USRNUM41 USRNUM41,
       warehouselocation.USRNUM42 USRNUM42,
       warehouselocation.USRNUM43 USRNUM43,
       warehouselocation.USRNUM44 USRNUM44,
       warehouselocation.USRNUM45 USRNUM45,
       warehouselocation.USRNUM46 USRNUM46,
       warehouselocation.USRNUM47 USRNUM47,
       warehouselocation.USRNUM48 USRNUM48,
       warehouselocation.USRNUM49 USRNUM49,
       warehouselocation.USRNUM50 USRNUM50,
       warehouselocation.USRNUM51 USRNUM51,
       warehouselocation.USRNUM52 USRNUM52,
       warehouselocation.USRNUM53 USRNUM53,
       warehouselocation.USRNUM54 USRNUM54,
       warehouselocation.USRNUM55 USRNUM55,
       warehouselocation.USRNUM56 USRNUM56,
       warehouselocation.USRNUM57 USRNUM57,
       warehouselocation.USRNUM58 USRNUM58,
       warehouselocation.USRNUM59 USRNUM59,
       warehouselocation.USRNUM60 USRNUM60,
       warehouselocation.USRNUM61 USRNUM61,
       warehouselocation.USRNUM62 USRNUM62,
       warehouselocation.USRNUM63 USRNUM63,
       warehouselocation.USRNUM64 USRNUM64,
       warehouselocation.USRNUM65 USRNUM65,
       warehouselocation.USRTXT1 USRTXT1,
       warehouselocation.USRTXT2 USRTXT2,
       warehouselocation.USRTXT3 USRTXT3,
       warehouselocation.USRTXT4 USRTXT4,
       warehouselocation.USRTXT5 USRTXT5,
       warehouselocation.USRTXT6 USRTXT6,
       warehouselocation.USRTXT7 USRTXT7,
       warehouselocation.USRTXT8 USRTXT8,
       warehouselocation.USRTXT9 USRTXT9,
       warehouselocation.USRTXT10 USRTXT10,
       warehouselocation.USRTXT11 USRTXT11,
       warehouselocation.USRTXT12 USRTXT12,
       warehouselocation.USRTXT13 USRTXT13,
       warehouselocation.USRTXT14 USRTXT14,
       warehouselocation.USRTXT15 USRTXT15,
       warehouselocation.USRTXT16 USRTXT16,
       warehouselocation.USRTXT17 USRTXT17,
       warehouselocation.USRTXT18 USRTXT18,
       warehouselocation.USRTXT19 USRTXT19,
       warehouselocation.USRTXT20 USRTXT20,
       warehouselocation.USRTXT21 USRTXT21,
       warehouselocation.USRTXT22 USRTXT22,
       warehouselocation.USRTXT23 USRTXT23,
       warehouselocation.USRTXT24 USRTXT24,
       warehouselocation.USRTXT25 USRTXT25,
       warehouselocation.USRTXT26 USRTXT26,
       warehouselocation.USRTXT27 USRTXT27,
       warehouselocation.USRTXT28 USRTXT28,
       warehouselocation.USRTXT29 USRTXT29,
       warehouselocation.USRTXT30 USRTXT30,
       warehouselocation.USRTXT31 USRTXT31,
       warehouselocation.USRTXT32 USRTXT32,
       warehouselocation.USRTXT33 USRTXT33,
       warehouselocation.USRTXT34 USRTXT34,
       warehouselocation.USRTXT35 USRTXT35,
       warehouselocation.USRTXT36 USRTXT36,
       warehouselocation.USRTXT37 USRTXT37,
       warehouselocation.USRTXT38 USRTXT38,
       warehouselocation.USRTXT39 USRTXT39,
       warehouselocation.USRTXT40 USRTXT40,
       warehouselocation.USRTXT41 USRTXT41,
       warehouselocation.USRTXT42 USRTXT42,
       warehouselocation.USRTXT43 USRTXT43,
       warehouselocation.USRTXT44 USRTXT44,
       warehouselocation.USRTXT45 USRTXT45,
       warehouselocation.USRTXT46 USRTXT46,
       warehouselocation.USRTXT47 USRTXT47,
       warehouselocation.USRTXT48 USRTXT48,
       warehouselocation.USRTXT49 USRTXT49,
       warehouselocation.USRTXT50 USRTXT50,
       warehouselocation.USRTXT51 USRTXT51,
       warehouselocation.USRTXT52 USRTXT52,
       warehouselocation.USRTXT53 USRTXT53,
       warehouselocation.USRTXT54 USRTXT54,
       warehouselocation.USRTXT55 USRTXT55,
       warehouselocation.USRTXT56 USRTXT56,
       warehouselocation.USRTXT57 USRTXT57,
       warehouselocation.USRTXT58 USRTXT58,
       warehouselocation.USRTXT59 USRTXT59,
       warehouselocation.USRTXT60 USRTXT60,
       warehouselocation.USRTXT61 USRTXT61,
       warehouselocation.USRTXT62 USRTXT62,
       warehouselocation.USRTXT63 USRTXT63,
       warehouselocation.USRTXT64 USRTXT64,
       warehouselocation.USRTXT65 USRTXT65
FROM OBJT_WAREHOUSELOCATION warehouselocation,
     OBJT_WAREHOUSE warehouse
WHERE warehouselocation.WAREHOUSEOID = warehouse.OID
AND warehouse.NAME <> 'SYSTEM'
/

-- WORKZONES --

CREATE OR REPLACE VIEW DCEREPORT_WORKZONES
AS
SELECT /*+ FIRST_ROWS(30) */ workzone.OID OID,
       workzone.NAME NAME,
       workzone.DESCRIPTION DESCRIPTION,
       workzone.CATEGORY CATEGORY,
       workzone.DTSVALIDFROM DTSVALIDFROM,
       workzone.DTSVALIDUNTIL DTSVALIDUNTIL,
       workzone.DTSUPDATE DTSUPDATE,
       workzone.USRDTS1 USRDTS1,
       workzone.USRDTS2 USRDTS2,
       workzone.USRDTS3 USRDTS3,
       workzone.USRDTS4 USRDTS4,
       workzone.USRDTS5 USRDTS5,
       workzone.USRFLG1 USRFLG1,
       workzone.USRFLG2 USRFLG2,
       workzone.USRFLG3 USRFLG3,
       workzone.USRFLG4 USRFLG4,
       workzone.USRFLG5 USRFLG5,
       workzone.USRNUM1 USRNUM1,
       workzone.USRNUM2 USRNUM2,
       workzone.USRNUM3 USRNUM3,
       workzone.USRNUM4 USRNUM4,
       workzone.USRNUM5 USRNUM5,
       workzone.USRTXT1 USRTXT1,
       workzone.USRTXT2 USRTXT2,
       workzone.USRTXT3 USRTXT3,
       workzone.USRTXT4 USRTXT4,
       workzone.USRTXT5 USRTXT5
FROM OBJT_ZONE workzone
WHERE workzone.BOTYPE = 1
/

-- MOVE ACTUALS --

CREATE OR REPLACE VIEW DCEREPORT_MOVE_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ move_inventorytraceop.OID OID,
       move_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       move_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       move_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       move_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       move_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       move_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       move_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       move_inventorytraceop.DTSSTART DTSSTART,
       move_inventorytraceop.DTSSTOP DTSSTOP,
       move_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       move_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       move_inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       move_inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       move_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       move_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       move_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       move_inventorytraceop.DEVICEOID DEVICE_OID,
       move_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION move_inventorytraceop,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE move_inventorytraceop.BOTYPE = 9 -- MOVE
AND move_inventorytraceop.UOMOID = uom.OID
AND move_inventorytraceop.LOTOID = lot.OID
/

-- NEST ACTUALS --

CREATE OR REPLACE VIEW DCEREPORT_NEST_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ nest_inventorytraceop.OID OID,
       nest_inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       nest_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       nest_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       nest_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       nest_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       nest_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       nest_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       nest_inventorytraceop.DTSSTART DTSSTART,
       nest_inventorytraceop.DTSSTOP DTSSTOP,
       nest_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       nest_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       nest_inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       nest_inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       nest_inventorytraceop.TOCSITQOID CONTAINER_OID,
       nest_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       nest_inventorytraceop.DEVICEOID DEVICE_OID,
       nest_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION nest_inventorytraceop,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE nest_inventorytraceop.BOTYPE = 10 -- NEST
AND nest_inventorytraceop.UOMOID = uom.OID
AND nest_inventorytraceop.LOTOID = lot.OID
/

-- INVENTORY ADJUSTMENTS --
CREATE OR REPLACE VIEW DCEREPORT_INVENTORY_ADJUSTS
AS
SELECT /*+ FIRST_ROWS(30) */ inventory_inventorytraceop.OID OID,
       inventory_inventorytraceop.STATUS STATUS,
       inventory_inventorytraceop.CATEGORY CATEGORY,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inventory_inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       inventory_inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       inventory_inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       inventory_inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       inventory_inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       inventory_inventorytraceop.FROMQTYINITIAL FROM_QTY,
       inventory_inventorytraceop.TOQTYINITIAL + inventory_inventorytraceop.TOQTYDELTA TO_QTY,
       uom.SYMBOL UOM,
       inventory_inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       inventory_inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       reason.NAME REASON_NAME,
       reason.DESCRIPTION REASON_DESCRIPTION,
       inventory_inventorytraceop.TOCSITQOID CONTAINER_OID,
       inventory_inventorytraceop.TONESTCSITQOID NEST_CONTAINER_OID,
       inventory_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       inventory_inventorytraceop.DEVICEOID DEVICE_OID,
       inventory_inventorytraceop.DTSSTART DTSSTART,
       inventory_inventorytraceop.DTSSTOP DTSSTOP,
       inventory_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION inventory_inventorytraceop
        LEFT JOIN OBJT_REASON reason ON inventory_inventorytraceop.REASONOID = reason.OID,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE inventory_inventorytraceop.BOTYPE = 15 -- INVENTORY
AND inventory_inventorytraceop.TOQTYDELTA <> 0
AND inventory_inventorytraceop.UOMOID = uom.OID
AND inventory_inventorytraceop.LOTOID = lot.OID
/

-- ASSETS --

CREATE OR REPLACE VIEW DCEREPORT_ASSETTRACES
AS
SELECT /*+ FIRST_ROWS(30) */ assettrace.OID OID,
       assettrace.ITEMOID CONTAINER_TYPE_OID,
       assettrace.EMPLOYEEOID EMPLOYEE_OID,
       assettrace.DTS DTS,
       assettrace.DESCRIPTION DESCRIPTION,
       assettrace.QTYDELTA QTY,
       CASE WHEN (assettrace.BOTYPE = 0) THEN 'ADJUST'
            WHEN (assettrace.BOTYPE = 1) THEN 'TRANSFER' END AS TYPE,
       CAST((SELECT customer.OID FROM OBJT_CUSTOMER customer
                            WHERE assettrace.RESOURCEOID = customer.OID
                              AND ROWNUM = 1) AS NUMBER(19)) AS CUSTOMER_OID,
       CAST((SELECT supplier.OID FROM OBJT_SUPPLIER supplier
                            WHERE assettrace.RESOURCEOID = supplier.OID
                              AND ROWNUM = 1) AS NUMBER(19)) AS SUPPLIER_OID,
       CAST((SELECT carrier.OID FROM OBJT_CARRIER carrier
                            WHERE assettrace.RESOURCEOID = carrier.OID
                              AND ROWNUM = 1) AS NUMBER(19)) AS CARRIER_OID,
       CAST((SELECT inboundorder.OID FROM OBJT_INBOUNDORDER inboundorder
                            WHERE assettrace.ORDEROID = inboundorder.OID
                              AND ROWNUM = 1) AS NUMBER(19)) AS INBOUNDORDER_OID,
       CAST((SELECT shiporder.OID FROM OBJT_SHIPORDER shiporder
                            WHERE assettrace.ORDEROID = shiporder.OID
                              AND ROWNUM = 1) AS NUMBER(19)) AS SHIPORDER_OID,
       assettrace.DTSUPDATE DTSUPDATE
FROM OBJT_ASSETTRACE assettrace
/

-- MTO ORDERS (VAL/KIT ORDERS) --

CREATE OR REPLACE VIEW DCEREPORT_MTO_ORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ makeorder.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       backorder.OID BACKORDER_OID,
       makeorder.NAME NAME,
       makeorder.ID ID,
       makeorder.DESCRIPTION DESCRIPTION,
       makeorder.CATEGORY TYPE,
       makeorder.DTSPLANNEDSTART DTSPLANNED,
       makeorder.DTSSCHEDULEDSTART DTSALLOCATED,
       makeorder.DTSSCHEDULEDSTOP DTSRELEASED,
       makeorder.DTSSTART DTSSTART,
       makeorder.DTSSTOP DTSSTOP,
       makeorder.STATUS STATUS,
       CAST((SELECT workcenter.OID
             FROM OBJT_PROCESSUNIT workcenter,
                  OBJT_MAKEOPERATION makeoperation
             WHERE makeoperation.MAKEORDEROID = makeorder.OID
             AND workcenter.CLASSOID = 9000000000000037041
             AND makeoperation.PROCESSUNITOID = workcenter.OID
             AND ROWNUM = 1) AS NUMBER(19)) AS PROCESSRESOURCE_OID,
       CAST((SELECT valoperation.name
             FROM OBJT_MANUFACTURINGOPERATION valoperation,
                  OBJT_MAKEOPERATION makeoperation
             WHERE makeoperation.MAKEORDEROID = makeorder.OID
             AND valoperation.OID = makeoperation.VALOPERATIONOID
             AND ROWNUM = 1) AS VARCHAR2(64)) AS VALOPERATION,
       makeorder.DTSUPDATE DTSUPDATE
FROM OBJT_MAKEORDER makeorder,
     OBJT_ORDERLINK make_backorderlink,
     OBJT_BACKORDERORDER backorder,
     OBJT_ORDERLINK backorder_outboundorderlink,
     OBJT_OUTBOUNDORDER outboundorder
WHERE makeorder.OID = make_backorderlink.CHILDOID
AND makeorder.BOTYPE = 0 -- MTO
AND make_backorderlink.PARENTOID = backorder.OID
AND backorder.OID = backorder_outboundorderlink.CHILDOID
AND backorder_outboundorderlink.PARENTOID = outboundorder.OID
UNION ALL
SELECT /*+ FIRST_ROWS(30) */ makeorder.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       backorder.OID BACKORDER_OID,
       child_makeorder.NAME NAME,
       child_makeorder.ID ID,
       child_makeorder.DESCRIPTION DESCRIPTION,
       child_makeorder.CATEGORY TYPE,
       child_makeorder.DTSPLANNEDSTART DTSPLANNED,
       child_makeorder.DTSSCHEDULEDSTART DTSALLOCATED,
       child_makeorder.DTSSCHEDULEDSTOP DTSRELEASED,
       child_makeorder.DTSSTART DTSSTART,
       child_makeorder.DTSSTOP DTSSTOP,
       child_makeorder.STATUS STATUS,
       CAST((SELECT workcenter.OID
             FROM OBJT_PROCESSUNIT workcenter,
                  OBJT_MAKEOPERATION makeoperation
             WHERE makeoperation.MAKEORDEROID = makeorder.OID
             AND workcenter.CLASSOID = 9000000000000037041
             AND makeoperation.PROCESSUNITOID = workcenter.OID
             AND ROWNUM = 1) AS NUMBER(19)) AS PROCESSRESOURCE_OID,
       CAST((SELECT valoperation.name
             FROM OBJT_MANUFACTURINGOPERATION valoperation,
                  OBJT_MAKEOPERATION makeoperation
             WHERE makeoperation.MAKEORDEROID = makeorder.OID
             AND valoperation.OID = makeoperation.VALOPERATIONOID
             AND ROWNUM = 1) AS VARCHAR2(64)) AS VALOPERATION,
       child_makeorder.DTSUPDATE DTSUPDATE
FROM OBJT_MAKEORDER child_makeorder,
     OBJT_ORDERLINK child_make_backorderlink,
     OBJT_BACKORDERORDER child_backorder,
     OBJT_ORDERLINK backorder_makelink,
     OBJT_MAKEORDER makeorder,
     OBJT_ORDERLINK make_backorderlink,
     OBJT_BACKORDERORDER backorder,
     OBJT_ORDERLINK backorder_outboundorderlink,
     OBJT_OUTBOUNDORDER outboundorder
WHERE child_makeorder.BOTYPE = 0 -- MTO
AND child_makeorder.OID = child_make_backorderlink.CHILDOID
AND child_make_backorderlink.PARENTOID = child_backorder.OID
AND child_backorder.OID = backorder_makelink.CHILDOID
AND backorder_makelink.PARENTOID = makeorder.OID
AND makeorder.OID = make_backorderlink.CHILDOID
AND make_backorderlink.PARENTOID = backorder.OID
AND backorder.OID = backorder_outboundorderlink.CHILDOID
AND backorder_outboundorderlink.PARENTOID =  outboundorder.OID
/

-- MTS ORDERS --

CREATE OR REPLACE VIEW DCEREPORT_MTS_ORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ makeorder.OID OID,
       makeorder.NAME NAME,
       makeorder.ID ID,
       makeorder.DESCRIPTION DESCRIPTION,
       makeorder.CATEGORY TYPE,
       makeorder.DTSPLANNEDSTART DTSPLANNED,
       makeorder.DTSSCHEDULEDSTART DTSALLOCATED,
       makeorder.DTSSCHEDULEDSTOP DTSRELEASED,
       makeorder.DTSSTART DTSSTART,
       makeorder.DTSSTOP DTSSTOP,
       makeorder.STATUS STATUS,
       CAST((SELECT workcenter.OID
             FROM OBJT_PROCESSUNIT workcenter,
                  OBJT_MAKEOPERATION makeoperation
             WHERE makeorder.OID = makeoperation.MAKEORDEROID
             AND makeoperation.PROCESSUNITOID = workcenter.OID
             AND workcenter.CLASSOID = 9000000000000037041
             AND ROWNUM = 1) AS NUMBER(19)) AS PROCESSRESOURCE_OID,
       makeorder.DTSUPDATE DTSUPDATE
FROM OBJT_MAKEORDER makeorder
WHERE makeorder.BOTYPE = 1 -- MTS

/

-- MTO LINES (VAL/KIT LINES) --

CREATE OR REPLACE VIEW DCEREPORT_MTO_LINES
AS --- SELECT VAL/KIT LINES ---
SELECT /*+ FIRST_ROWS(30) */ makeoperation.OID OID,
       outboundorder.OID OUTBOUNDORDER_OID,
       outboundoperation.OID OUTBOUNDLINE_OID,
       backorder.OID BACKORDER_OID,
       backorderline.OID BACKORDERLINE_OID,
       makeorder.OID MTO_ORDER_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       makeitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       makeitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       makeitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       makeitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       makeitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       makeitemqty.QTYTARGET QTYTOPRODUCE,
       makeitemqty.VALUE QTYPRODUCED,
       CAST ((SELECT uom.SYMBOL
              FROM OBJT_UOM uom
              WHERE uom.OID = makeitemqty.UOMOID
              AND ROWNUM = 1) AS VARCHAR2(32)) AS UOM,
       CAST(GREATEST(makeoperation.DTSUPDATE, makeitemqty.DTSUPDATE) AS DATE) DTSUPDATE
FROM OBJT_MAKEITEMQTY makeitemqty,
     OBJT_OPERATIONITEMQTYLINK make_opitqlink,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_OPERATIONLINK make_backorderoplink,
     OBJT_BACKORDEROPERATION backorderline,
     OBJT_OPERATIONLINK outboundop_backorderop_link,
     OBJT_BACKORDERORDER backorder,
     OBJT_MAKEORDER makeorder,
     OBJT_OUTBOUNDOPERATION outboundoperation,
     OBJT_OUTBOUNDORDER outboundorder,
     OBJT_LOT lot
WHERE makeitemqty.BOTYPE = 0 -- OUTPUT
AND makeitemqty.OID = make_opitqlink.ITEMQTYOID
AND make_opitqlink.OPERATIONOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
AND makeorder.BOTYPE = 0 -- MTO
AND makeitemqty.LOTOID = lot.OID
AND makeoperation.oid = make_backorderoplink.CHILDOID
AND make_backorderoplink.PARENTOID = backorderline.OID
AND backorder.OID = backorderline.BACKORDERORDEROID
AND backorderline.OID = outboundop_backorderop_link.CHILDOID
AND outboundop_backorderop_link.PARENTOID = outboundoperation.OID
AND outboundorder.OID = outboundoperation.OUTBOUNDORDEROID
/

-- MTS LINES --

CREATE OR REPLACE VIEW DCEREPORT_MTS_LINES
AS --- SELECT KIT LINES ---
SELECT /*+ FIRST_ROWS(30) */ makeoperation.OID OID,
       makeorder.OID MTS_ORDER_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       makeitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       makeitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       makeitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       makeitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       makeitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       makeitemqty.QTYTARGET QTYTOPRODUCE,
       makeitemqty.VALUE QTYPRODUCED,
       CAST ((SELECT uom.SYMBOL
              FROM OBJT_UOM uom
              WHERE uom.OID = makeitemqty.UOMOID
              AND ROWNUM = 1) AS VARCHAR2(32)) AS UOM,
       CAST(GREATEST(makeoperation.DTSUPDATE, makeitemqty.DTSUPDATE) AS DATE) DTSUPDATE
FROM OBJT_MAKEITEMQTY makeitemqty,
     OBJT_OPERATIONITEMQTYLINK make_opitqlink,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_MAKEORDER makeorder,
     OBJT_LOT lot
WHERE makeitemqty.BOTYPE = 0
AND makeitemqty.OID = make_opitqlink.ITEMQTYOID
AND make_opitqlink.OPERATIONOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
AND makeorder.BOTYPE = 1 -- MTS
AND makeitemqty.LOTOID = lot.OID
/

-- MTO INPUT ACTUALS --

CREATE OR REPLACE VIEW DCEREPORT_MTO_INPUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ input_inventorytraceop.OID OID,
       makeorder.OID MTO_ORDER_OID,
       makeoperation.OID MTO_LINE_OID,
       processresource.OID PROCESSRESOURCE_OID,
       input_inventorytraceop.FROMLOCATIONOID LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       ABS(input_inventorytraceop.TOQTYDELTA) AS QTY,
       uom.SYMBOL UOM,
       input_inventorytraceop.DTSSTART DTSSTART,
       input_inventorytraceop.DTSSTOP DTSSTOP,
       input_inventorytraceop.FROMCSITQOID CONTAINER_OID,
       input_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       input_inventorytraceop.DEVICEOID DEVICE_OID,
       input_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION input_inventorytraceop,
     OBJT_OPERATIONLINK inputoperation_link,
     OBJT_INPUTOPERATION target_inputop,
     OBJT_OPERATIONLINK inputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_OPERATIONLINK machinop_productionop_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_OPERATIONLINK make_productionop_link,
     OBJT_LOT lot,
     OBJT_UOM uom,
     OBJT_MAKEORDER makeorder
WHERE input_inventorytraceop.BOTYPE = 2 -- INPUT
AND input_inventorytraceop.OID = inputoperation_link.CHILDOID
AND inputoperation_link.PARENTOID = target_inputop.OID
AND target_inputop.BOTYPE = 0 -- TARGET
AND target_inputop.OID = inputop_machineop_link.CHILDOID
AND inputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionoperation.OID = make_productionop_link.CHILDOID
AND make_productionop_link.PARENTOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
AND makeorder.BOTYPE = 0 -- MTO
AND input_inventorytraceop.LOTOID = lot.OID
AND input_inventorytraceop.UOMOID = uom.OID
/

-- MTS INPUT ACTUALS --

CREATE OR REPLACE VIEW DCEREPORT_MTS_INPUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ input_inventorytraceop.OID OID,
       makeorder.OID MTS_ORDER_OID,
       makeoperation.OID MTS_LINE_OID,
       processresource.OID PROCESSRESOURCE_OID,
       input_inventorytraceop.FROMLOCATIONOID LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       ABS(input_inventorytraceop.TOQTYDELTA) AS QTY,
       uom.SYMBOL UOM,
       input_inventorytraceop.DTSSTART DTSSTART,
       input_inventorytraceop.DTSSTOP DTSSTOP,
       input_inventorytraceop.FROMCSITQOID CONTAINER_OID,
       input_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       input_inventorytraceop.DEVICEOID DEVICE_OID,
       input_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION input_inventorytraceop,
     OBJT_OPERATIONLINK inputoperation_link,
     OBJT_INPUTOPERATION target_inputop,
     OBJT_OPERATIONLINK inputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_OPERATIONLINK machinop_productionop_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_OPERATIONLINK make_productionop_link,
     OBJT_LOT lot,
     OBJT_UOM uom,
     OBJT_MAKEORDER makeorder
WHERE input_inventorytraceop.BOTYPE = 2 -- INPUT
AND input_inventorytraceop.OID = inputoperation_link.CHILDOID
AND inputoperation_link.PARENTOID = target_inputop.OID
AND target_inputop.BOTYPE = 0 -- TARGET
AND target_inputop.OID = inputop_machineop_link.CHILDOID
AND inputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionoperation.OID = make_productionop_link.CHILDOID
AND make_productionop_link.PARENTOID = makeoperation.OID
AND makeoperation.CATEGORY = 'KIT'
AND makeorder.OID = makeoperation.MAKEORDEROID
AND makeorder.BOTYPE = 1 -- MTS
AND input_inventorytraceop.LOTOID = lot.OID
AND input_inventorytraceop.UOMOID = uom.OID
/

-- MTO OUTPUT ACTUALS --

CREATE OR REPLACE VIEW DCEREPORT_MTO_OUTPUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ output_inventorytraceop.OID OID,
       makeorder.OID MTO_ORDER_OID,
       makeoperation.OID MTO_LINE_OID,
       processresource.OID PROCESSRESOURCE_OID,
       output_inventorytraceop.TOLOCATIONOID LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       output_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       output_inventorytraceop.DTSSTART DTSSTART,
       output_inventorytraceop.DTSSTOP DTSSTOP,
       output_inventorytraceop.TOCSITQOID CONTAINER_OID,
       output_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       output_inventorytraceop.DEVICEOID DEVICE_OID,
       output_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION output_inventorytraceop,
     OBJT_OPERATIONLINK outputoperation_link,
     OBJT_OUTPUTOPERATION target_outputop,
     OBJT_OPERATIONLINK outputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_OPERATIONLINK machinop_productionop_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_OPERATIONLINK make_productionop_link,
     OBJT_LOT lot,
     OBJT_UOM uom,
     OBJT_MAKEORDER makeorder
WHERE output_inventorytraceop.BOTYPE = 3 -- OUTPUT
AND output_inventorytraceop.OID = outputoperation_link.CHILDOID
AND outputoperation_link.PARENTOID = target_outputop.OID
AND target_outputop.BOTYPE = 0 -- TARGET
AND target_outputop.OID = outputop_machineop_link.CHILDOID
AND outputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionoperation.OID = make_productionop_link.CHILDOID
AND make_productionop_link.PARENTOID = makeoperation.OID
AND makeorder.OID = makeoperation.MAKEORDEROID
AND makeorder.BOTYPE = 0 -- MTO
AND output_inventorytraceop.UOMOID = uom.OID
AND output_inventorytraceop.LOTOID = lot.OID
/

-- MTS OUTPUT ACTUALS --

CREATE OR REPLACE VIEW DCEREPORT_MTS_OUTPUT_ACTUALS
AS
SELECT /*+ FIRST_ROWS(30) */ output_inventorytraceop.OID OID,
       makeorder.OID MTS_ORDER_OID,
       makeoperation.OID MTS_LINE_OID,
       processresource.OID PROCESSRESOURCE_OID,
       output_inventorytraceop.TOLOCATIONOID LOCATION_OID,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       output_inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       output_inventorytraceop.DTSSTART DTSSTART,
       output_inventorytraceop.DTSSTOP DTSSTOP,
       output_inventorytraceop.TOCSITQOID CONTAINER_OID,
       output_inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       output_inventorytraceop.DEVICEOID DEVICE_OID,
       output_inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION output_inventorytraceop,
     OBJT_OPERATIONLINK outputoperation_link,
     OBJT_OUTPUTOPERATION target_outputop,
     OBJT_OPERATIONLINK outputop_machineop_link,
     OBJT_MACHINEOPERATION machineoperation,
     OBJT_PROCESSUNIT processresource,
     OBJT_OPERATIONLINK machinop_productionop_link,
     OBJT_PRODUCTIONOPERATION productionoperation,
     OBJT_MAKEOPERATION makeoperation,
     OBJT_OPERATIONLINK make_productionop_link,
     OBJT_LOT lot,
     OBJT_UOM uom,
     OBJT_MAKEORDER makeorder
WHERE output_inventorytraceop.BOTYPE = 3  -- OUTPUT
AND output_inventorytraceop.OID = outputoperation_link.CHILDOID
AND outputoperation_link.PARENTOID = target_outputop.OID
AND target_outputop.BOTYPE = 0 -- TARGET
AND target_outputop.OID = outputop_machineop_link.CHILDOID
AND outputop_machineop_link.PARENTOID = machineoperation.OID
AND machineoperation.PRODUCTIONOPERATIONOID = productionoperation.OID
AND machineoperation.PROCESSUNITOID = processresource.OID
AND (processresource.CLASSOID = 9000000000000010923 OR processresource.CLASSOID = 9000000000000037041)
AND productionoperation.OID = make_productionop_link.CHILDOID
AND make_productionop_link.PARENTOID = makeoperation.OID
AND makeoperation.CATEGORY = 'KIT'
AND makeorder.OID = makeoperation.MAKEORDEROID
AND makeorder.BOTYPE = 1 -- MTS
AND output_inventorytraceop.UOMOID = uom.OID
AND output_inventorytraceop.LOTOID = lot.OID
/


-- CURRENT INVENTORY (only useable on runtime)--

CREATE OR REPLACE VIEW DCEREPORT_INVENTORY
AS
SELECT /*+ FIRST_ROWS(30) */storageitemqty.OID OID,
       csitq.OID CONTAINER_OID,
       item.OID ITEM_OID,
       lot.OID LOT_OID,
       storageitemqty.UOMOID UOM_OID,
       location.OID LOCATION_OID,
       location.WAREHOUSEOID WAREHOUSE_OID,
       location.FULLNAME LOCATION,
       warehouse.name WAREHOUSE,
       csitq.NAME LPN,
       item.name ITEM_NAME,
       item.description ITEM_DESCRIPTION,
       storageitemqty.VALUE,
       uom.symbol UOM,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       storageitemqty.INVENTORYCODE1,
       storageitemqty.INVENTORYCODE2,
       storageitemqty.INVENTORYCODE3,
       storageitemqty.INVENTORYCODE4,
       storageitemqty.INVENTORYCODE5,
       storageitemqty.DTSUPDATE,
       department.OID as DEPARTMENT_OID,
       department.NAME as DEPARTMENT_NAME
FROM OBJT_STORAGEITEMQTY storageitemqty
     LEFT OUTER JOIN OBJT_CONTAINERSTORAGEITEMQTY csitq ON storageitemqty.CONTAINERSTORAGEITEMQTYOID = csitq.oid,
     OBJT_WAREHOUSELOCATION location,
     OBJT_WAREHOUSE warehouse
     LEFT OUTER JOIN OBJT_RESOURCELINK departmentwarehouselink on warehouse.OID = departmentwarehouselink.CHILDOID and departmentwarehouselink.PARENTCLASSNAME = 'dce.bo.resourcemgt.Department'
     LEFT OUTER JOIN OBJT_DEPARTMENT department on departmentwarehouselink.PARENTOID = department.oid,     OBJT_LOT lot,
     OBJT_ITEM item,
     OBJT_UOM uom
WHERE storageitemqty.DTSVALIDUNTIL is null
AND storageitemqty.UOMOID = uom.OID
AND storageitemqty.WAREHOUSELOCATIONOID = location.OID
AND location.WAREHOUSEOID = warehouse.OID
AND warehouse.NAME <> 'SYSTEM'
AND storageitemqty.LOTOID = lot.OID
AND storageitemqty.ITEMOID = item.OID
AND (csitq.CLASSOID IS NULL OR csitq.CLASSOID = 9000000000000095836)
/

-- RUNTIME INSPECTIONSHEETS --

CREATE OR REPLACE VIEW OBJTREP_INSPECTION
AS
SELECT runtimeinspectionsheet.OID OID,
     runtimeinspectionsheet.NAME INSPECTION,
     inspectionsheet.NAME NAME,
     inspectionsheet.DESCRIPTION DESCRIPTION,
     CASE WHEN (runtimeinspectionsheet.BOTYPE = 0) THEN 'INBOUND_ORDER'
      WHEN (runtimeinspectionsheet.BOTYPE = 1) THEN 'INVENTORY'
      WHEN (runtimeinspectionsheet.BOTYPE = 2) THEN 'SERIAL' END AS INSPECTION_TYPE,
     runtimeinspectionsheet.ORIGIN ORIGIN,
     runtimeinspectionsheet.DTSUPDATE DTSUPDATE,
     runtimeinspectionsheet.DTSSTART DTSSTART,
     runtimeinspectionsheet.DTSSTOP DTSSTOP,
     runtimeinspectionsheet.DTSVALIDFROM DTSVALIDFROM,
     runtimeinspectionsheet.CARRIEROID CARRIER_OID,
     runtimeinspectionsheet.CONTAINEROID CONTAINER_OID,
     runtimeinspectionsheet.CUSTOMEROID CUSTOMER_OID,
     runtimeinspectionsheet.SUPPLIEROID SUPPLIER_OID,
     runtimeinspectionsheet.EMPLOYEEOID EMPLOYEE_OID,
     runtimeinspectionsheet.INBOUNDORDEROID INBOUNDORDER_OID,
     runtimeinspectionsheet.PRODUCTIONORDEROID PRODUCTIONORDER_OID,
     runtimeinspectionsheet.PRODUCTIONOPERATIONOID PRODUCTIONOPERATION_OID,
     runtimeinspectionsheet.MACHINEOPERATIONOID MACHINEOPERATION_OID,
     runtimeinspectionsheet.ITEMOID ITEM_OID,
     runtimeinspectionsheet.LOTID LOTID,
     runtimeinspectionsheet.LOTOID LOT_OID,
     runtimeinspectionsheet.SUBLOTID SUBLOTID,
     runtimeinspectionsheet.SERIALOID SERIAL_OID,
     runtimeinspectionsheet.QUALITYCONTROLSTATUSOID QUALITYCONTROLSTATUS_OID,
     runtimeinspectionsheet.RESULT RESULT, -- 0 = OK, 1 = WARNING, 2 = ERROR
     runtimeinspectionsheet.STATUS STATUS -- 0 = IDLE, 2 = SCHEDULED, 4 = STOPPED, 5 = COMPLETE, 6 = ABORTED
FROM OBJT_RUNTIMEINSPECTIONSHEET runtimeinspectionsheet
    LEFT OUTER JOIN OBJT_INSPECTIONSHEET inspectionsheet ON runtimeinspectionsheet.INSPECTIONSHEETOID = inspectionsheet.OID
      LEFT OUTER JOIN OBJT_ITEM item ON runtimeinspectionsheet.ITEMOID = item.OID
/

-- RUNTIME CHECK INSTRUCTIONS --

CREATE OR REPLACE VIEW OBJTREP_INSPEC_CHECKINSTR
AS
SELECT runtimecheckinstr.OID OID,
     runtimecheckinstr.DTSUPDATE DTSUPDATE,
     runtimecheckinstr.NAME NAME,
     runtimecheckinstr.DESCRIPTION DESCRIPTION,
     runtimecheckinstr.ID ID,
     runtimecheckinstr.CATEGORY CATEGORY,
     CASE WHEN (runtimecheckinstr.BOTYPE = 0) THEN 'YES/NO'
      WHEN (runtimecheckinstr.BOTYPE = 1) THEN 'OK/NOK' END AS INSTRUCTION_TYPE,
     runtimecheckinstr.QTYSAMPLES QTYSAMPLES,
     sampletype.NAME SAMPLETYPE,
     runtimecheckinstr.SEQ SEQ,
     CASE WHEN (runtimecheckinstr.MANDATORY IS NULL) THEN 'F' ELSE runtimecheckinstr.MANDATORY END AS MANDATORY,
     CASE WHEN (runtimecheckinstr.DESTRUCTIVE IS NULL) THEN 'F' ELSE runtimecheckinstr.DESTRUCTIVE END AS DESTRUCTIVE,
     CASE WHEN (runtimecheckinstr.CRITICAL IS NULL) THEN 'F' ELSE runtimecheckinstr.CRITICAL END AS CRITICAL,
     CASE WHEN (runtimecheckinstr.SINGLEEXECUTION IS NULL) THEN 'F' ELSE  runtimecheckinstr.SINGLEEXECUTION END AS SINGLEEXECUTION,
     runtimecheckinstr.RUNTIMEINSPECTIONSHEETOID INSPECTION_OID,
     runtimecheckinstr.DTSLASTEXECUTED DTSLASTEXECUTED,
     runtimecheckinstr.RESULT RESULT,  -- 0 = OK, 1 = WARNING, 2 = ERROR
     runtimecheckinstr.STATUS STATUS, -- 0 = IDLE, 2 = SCHEDULED, 4 = STOPPED, 5 = COMPLETE, 6 = ABORTED
     runtimecheckinstr.STRINGVALUE STRINGVALUE
FROM OBJT_RUNTIMEINSPECTIONINSTR runtimecheckinstr
      LEFT OUTER JOIN OBJT_SAMPLETYPE sampletype ON runtimecheckinstr.SAMPLETYPEOID = sampletype.OID
WHERE runtimecheckinstr.CLASSOID = 9000000000000088768
/

-- RUNTIME INPUT INSTRUCTIONS --

CREATE OR REPLACE VIEW OBJTREP_INSPEC_INPUTINSTR
AS
SELECT runtimeinputinstr.OID OID,
     runtimeinputinstr.DTSUPDATE DTSUPDATE,
     runtimeinputinstr.NAME NAME,
     runtimeinputinstr.DESCRIPTION DESCRIPTION,
     runtimeinputinstr.ID ID,
     runtimeinputinstr.CATEGORY CATEGORY,
     CASE WHEN (runtimeinputinstr.BOTYPE = 0) THEN 'NUMERIC'
      WHEN (runtimeinputinstr.BOTYPE = 1) THEN 'TEXT'
      WHEN (runtimeinputinstr.BOTYPE = 2) THEN 'LIST' END AS INSTRUCTION_TYPE,
     runtimeinputinstr.MAXVALUE MAXVALUE,
       runtimeinputinstr.MINVALUE MINVALUE,
       runtimeinputinstr.UOMOID UOM_OID,
     runtimeinputinstr.QTYSAMPLES QTYSAMPLES,
     sampletype.NAME SAMPLETYPE,
     runtimeinputinstr.SEQ SEQ,
     CASE WHEN (runtimeinputinstr.MANDATORY IS NULL) THEN 'F' ELSE runtimeinputinstr.MANDATORY END AS MANDATORY,
     CASE WHEN (runtimeinputinstr.DESTRUCTIVE IS NULL) THEN 'F' ELSE runtimeinputinstr.DESTRUCTIVE END AS DESTRUCTIVE,
     CASE WHEN (runtimeinputinstr.CRITICAL IS NULL) THEN 'F' ELSE runtimeinputinstr.CRITICAL END AS CRITICAL,
     CASE WHEN (runtimeinputinstr.SINGLEEXECUTION IS NULL) THEN 'F' ELSE  runtimeinputinstr.SINGLEEXECUTION END AS SINGLEEXECUTION,
     runtimeinputinstr.RUNTIMEINSPECTIONSHEETOID INSPECTION_OID,
     runtimeinputinstr.DTSLASTEXECUTED DTSLASTEXECUTED,
       runtimeinputinstr.RESULT RESULT,  -- 0 = OK, 1 = WARNING, 2 = ERROR
     runtimeinputinstr.STATUS STATUS, -- 0 = IDLE, 2 = SCHEDULED, 4 = STOPPED, 5 = COMPLETE, 6 = ABORTED
     runtimeinputinstr.STRINGVALUE STRINGVALUE,
     runtimeinputinstr.LISTVALUES LISTVALUES
FROM OBJT_RUNTIMEINSPECTIONINSTR runtimeinputinstr
      LEFT OUTER JOIN OBJT_SAMPLETYPE sampletype ON runtimeinputinstr.SAMPLETYPEOID = sampletype.OID
WHERE runtimeinputinstr.CLASSOID = 9000000000000088752
/

-- RUNTIME SAMPLE INSTRUCTIONS --

CREATE OR REPLACE VIEW OBJTREP_INSPEC_SAMPLEININSTR
AS
SELECT runtimesampleinstr.OID OID,
     runtimesampleinstr.DTSUPDATE DTSUPDATE,
     runtimesampleinstr.NAME NAME,
     runtimesampleinstr.DESCRIPTION DESCRIPTION,
     runtimesampleinstr.ID ID,
     runtimesampleinstr.CATEGORY CATEGORY,
     runtimesampleinstr.QTYSAMPLES QTYSAMPLES,
     sampletype.NAME SAMPLETYPE,
     runtimesampleinstr.PRINTLABEL PRINTLABEL,
     runtimesampleinstr.SEQ SEQ,
     CASE WHEN (runtimesampleinstr.MANDATORY IS NULL) THEN 'F' ELSE runtimesampleinstr.MANDATORY END AS MANDATORY,
     CASE WHEN (runtimesampleinstr.CRITICAL IS NULL) THEN 'F' ELSE runtimesampleinstr.CRITICAL END AS CRITICAL,
     CASE WHEN (runtimesampleinstr.SINGLEEXECUTION IS NULL) THEN 'F' ELSE  runtimesampleinstr.SINGLEEXECUTION END AS SINGLEEXECUTION,
     runtimesampleinstr.RUNTIMEINSPECTIONSHEETOID INSPECTION_OID,
     runtimesampleinstr.DTSLASTEXECUTED DTSLASTEXECUTED,
     runtimesampleinstr.RESULT RESULT,  -- 0 = OK, 1 = WARNING, 2 = ERROR
     runtimesampleinstr.STATUS STATUS -- 0 = IDLE, 2 = SCHEDULED, 4 = STOPPED, 5 = COMPLETE, 6 = ABORTED
FROM OBJT_RUNTIMEINSPECTIONINSTR runtimesampleinstr
      LEFT OUTER JOIN OBJT_SAMPLETYPE sampletype ON sampletype.OID = runtimesampleinstr.SAMPLETYPEOID
WHERE runtimesampleinstr.CLASSOID = 9000000000000088771
/

CREATE OR REPLACE VIEW OBJTREP_INSPEC_MEASUREMNTINSTR
AS
SELECT runtimemeasurementinstr.OID OID,
     runtimemeasurementinstr.DTSUPDATE DTSUPDATE,
     runtimemeasurementinstr.NAME NAME,
     runtimemeasurementinstr.DESCRIPTION DESCRIPTION,
     runtimemeasurementinstr.ID ID,
     runtimemeasurementinstr.CATEGORY CATEGORY,
     measurement.QTYSTANDARD QTYSTANDARD,
     measurement.QTYLOW LCL,
     measurement.QTYHIGH UCL,
     measurement.QTYLOWLOW LSL,
     measurement.QTYHIGHHIGH USL,
     measurement.RANGEHIGH RCL,
     measurement.RANGEHIGHHIGH RSL,
     measurement.SAMPLESIZE MEASUREMENT_COUNT,
     CASE WHEN (measurement.SAMPLETYPE = 1) THEN 'T' ELSE 'F' END AS MEASUREMENT_COUNT_FIXED,
     measurement.UOMOID UOM_OID,
     runtimemeasurementinstr.QTYSAMPLES QTYSAMPLES,
     sampletype.NAME SAMPLETYPE,
     runtimemeasurementinstr.SEQ SEQ,
     CASE WHEN (runtimemeasurementinstr.MANDATORY IS NULL) THEN 'F' ELSE runtimemeasurementinstr.MANDATORY END AS MANDATORY,
     CASE WHEN (runtimemeasurementinstr.DESTRUCTIVE IS NULL) THEN 'F' ELSE runtimemeasurementinstr.DESTRUCTIVE END AS DESTRUCTIVE,
     CASE WHEN (runtimemeasurementinstr.CRITICAL IS NULL) THEN 'F' ELSE runtimemeasurementinstr.CRITICAL  END AS CRITICAL,
     CASE WHEN (runtimemeasurementinstr.SINGLEEXECUTION IS NULL) THEN 'F' ELSE runtimemeasurementinstr.SINGLEEXECUTION END AS SINGLEEXECUTION,
     runtimemeasurementinstr.RUNTIMEINSPECTIONSHEETOID INSPECTION_OID,
     runtimemeasurementinstr.DTSLASTEXECUTED DTSLASTEXECUTED,
     runtimemeasurementinstr.RESULT RESULT,  -- 0 = OK, 1 = WARNING, 2 = ERROR
     runtimemeasurementinstr.STATUS STATUS, -- 0 = IDLE, 2 = SCHEDULED, 4 = STOPPED, 5 = COMPLETE, 6 = ABORTED
     runtimemeasurementinstr.STRINGVALUE AVERAGE
FROM OBJT_RUNTIMEINSPECTIONINSTR runtimemeasurementinstr
       LEFT OUTER JOIN OBJT_SAMPLETYPE sampletype ON runtimemeasurementinstr.SAMPLETYPEOID = sampletype.OID,
     OBJT_MEASUREMENT measurement
WHERE runtimemeasurementinstr.CLASSOID = 9000000000000088788
AND runtimemeasurementinstr.OID = measurement.OWNEROID
AND measurement.CLASSOID = 9000000000000093059
/

-- INSPECTION EVENTS --

CREATE OR REPLACE VIEW OBJTREP_INSPEC_INSPECTIONEVENT
AS
SELECT inspectionevent.OID OID,
     inspectionevent.DTSUPDATE DTSUPDATE,
     inspectionevent.CATEGORY CATEGORY,
     inspectionevent.REFERENCEID REFERENCEID,
     inspectionevent.COMMENTS COMMENTS,
     inspectionevent.DEVICEOID DEVICE_OID,
     inspectionevent.DTS DTS,
     inspectionevent.EMPLOYEEOID EMPLOYEE_OID,
     inspectionevent.RUNTIMEINSPECTIONINSTROID INSTRUCTION_OID,
     inspectionevent.RUNTIMEINSPECTIONSHEETOID INSPECTION_OID,
     inspectionevent.RUNTIMEINSPECTIONRESULTOID RESULT_OID,
     inspectionevent.RESULT RESULT, -- 0 = OK, 1 = WARNING, 2 = ERROR
     inspectionevent.STRINGVALUE STRINGVALUE
FROM OBJT_INSPECTIONEVENT inspectionevent
WHERE inspectionevent.CLASSOID = 9000000000000088942
/

-- SAMPLE EVENTS --

CREATE OR REPLACE VIEW OBJTREP_INSPEC_SAMPLEEVENT
AS
SELECT sampleevent.OID OID,
     sampleevent.DTSUPDATE DTSUPDATE,
     sampleevent.CATEGORY CATEGORY,
     sampleevent.COMMENTS COMMENTS,
     sampleevent.DEVICEOID DEVICE_OID,
     sampleevent.DTS DTS,
     sampleevent.EMPLOYEEOID EMPLOYEE_OID,
     sampleevent.PARENTINSPECTIONEVENTOID INSPECTIONEVENT_OID,
     sampleevent.RUNTIMEINSPECTIONINSTROID INSTRUCTION_OID,
     sampleevent.RUNTIMEINSPECTIONSHEETOID INSPECTION_OID,
     sampleevent.RESULT RESULT, -- 0 = OK, 1 = WARNING, 2 = ERROR
     sampleevent.SAMPLEOID SAMPLE_OID,
     sampleevent.TARGETLOCATIONOID TARGETLOCATION_OID,
     sampleevent.SOURCELOCATIONOID SOURCELOCATION_OID,
     sampleevent.FROMCONTAINERSTORAGEITEMQTYOID FROM_CONTAINER_OID
FROM OBJT_INSPECTIONEVENT sampleevent
WHERE sampleevent.CLASSOID = 9000000000000088951
/

-- RUNTIME INSPECTION RESULTS --

CREATE OR REPLACE VIEW OBJTREP_INSPEC_INSPRESULT
AS
SELECT runtimeinspectionresult.OID OID,
     runtimeinspectionresult.DTSUPDATE DTSUPDATE,
     runtimeinspectionresult.DTSLASTEXECUTED DTSLASTEXECUTED,
     runtimeinspectionresult.REFERENCEID REFERENCEID,
     runtimeinspectionresult.COMMENTS COMMENTS,
     runtimeinspectionresult.RESULT RESULT, -- 0 = OK, 1 = WARNING, 2 = ERROR
     runtimeinspectionresult.STRINGVALUE STRINGVALUE,
     runtimeinspectionresult.RUNTIMEINSPECTIONINSTROID INSTRUCTION_OID
FROM OBJT_RUNTIMEINSPECTIONRESULT runtimeinspectionresult
/

-- SAMPLES --

CREATE OR REPLACE VIEW OBJTREP_SAMPLES
AS
SELECT sample.OID OID,
     sample.NAME NAME,  
     sampletype.NAME SAMPLETYPE,
     sample.ITEMOID ITEM_OID,
     sample.LOTOID LOT_OID,
     sample.LOTID LOTID,
     sample.SUBLOTID SUBLOTID,
     sample.WAREHOUSELOCATIONOID LOCATION_OID,
     sample.RUNTIMESAMPLEINSTRUCTIONOID SAMPLEINSTR_OID,
     sample.DTSUPDATE DTSUPDATE,
     sample.USRDTS1 USRDTS1,
     sample.USRDTS2 USRDTS2,
     sample.USRDTS3 USRDTS3,
     sample.USRDTS4 USRDTS4,
     sample.USRDTS5 USRDTS5,
     sample.USRFLG1 USRFLG1,
     sample.USRFLG2 USRFLG2,
     sample.USRFLG3 USRFLG3,
     sample.USRFLG4 USRFLG4,
     sample.USRFLG5 USRFLG5,
     sample.USRNUM1 USRNUM1,
     sample.USRNUM2 USRNUM2,
     sample.USRNUM3 USRNUM3,
     sample.USRNUM4 USRNUM4,
     sample.USRNUM5 USRNUM5,
     sample.USRTXT1 USRTXT1,
     sample.USRTXT2 USRTXT2,
     sample.USRTXT3 USRTXT3,
     sample.USRTXT4 USRTXT4,
     sample.USRTXT5 USRTXT5
FROM OBJT_SAMPLE sample
LEFT OUTER JOIN OBJT_SAMPLETYPE sampletype ON sample.SAMPLETYPEOID = sampletype.OID
/

-- SERIALS --

CREATE OR REPLACE VIEW OBJTREP_SERIALS
AS
-- select all valid serials --
SELECT serial.OID OID,
       serial.NAME SERIAL,
       serial.DTSVALIDFROM DTSVALIDFROM,
       serial.DTSVALIDUNTIL DTSVALIDUNTIL,
       serial.ITEMOID ITEM_OID,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       serial.LOTOID LOT_OID,
       serial.LOTID LOT,
       serial.SUBLOTID SUBLOT,
       storageitemqty.INVENTORYCODE1 INVENTORYCODE1,
       storageitemqty.INVENTORYCODE2 INVENTORYCODE2,
       storageitemqty.INVENTORYCODE3 INVENTORYCODE3,
       storageitemqty.INVENTORYCODE4 INVENTORYCODE4,
       storageitemqty.INVENTORYCODE5 INVENTORYCODE5,
       storageitemqty.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       location.FULLNAME LOCATION,
       CAST(storageitemqty.WAREHOUSELOCATIONOID AS NUMBER(19)) LOCATION_OID,
       CAST(location.WAREHOUSEOID AS NUMBER(19)) WAREHOUSE_OID,
       containerstorageitemqty.NAME LPN,
       CAST(containerstorageitemqty.OID AS NUMBER(19)) CONTAINER_OID,
       serial.DTSUPDATE DTSUPDATE,
       serial.INORDERID ORIGIN_ORDER_ID,
       serial.INORDEROID ORIGIN_ORDER_OID,
       CASE WHEN (serial.INORDERCLASSNAME = 'objt.wms.bo.inboundmgt.InboundOrder') THEN 'INBOUNDORDER'
            WHEN (serial.INORDERCLASSNAME = 'objt.mes.bo.productionmgt.ProductionOrder') THEN 'PRODUCTIONORDER' END AS ORIGIN_ORDER_TYPE,
       serial.INRESOURCEOID ORIGIN_RESOURCE_OID,
       CASE WHEN (serial.INRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Supplier') THEN 'SUPPLIER'
            WHEN (serial.INRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Customer') THEN 'CUSTOMER' END AS ORIGIN_RESOURCE_TYPE,
       serial.OUTORDERID DESTINATION_ORDER_ID,
       serial.OUTORDEROID DESTINATION_ORDER_OID,
       CASE WHEN (serial.OUTORDERCLASSNAME = 'objt.wms.bo.outboundmgt.OutboundOrder') THEN 'OUTBOUNDORDER'
            WHEN (serial.OUTORDERCLASSNAME = 'objt.mes.bo.productionmgt.ProductionOrder') THEN 'PRODUCTIONORDER' END AS DESTINATION_ORDER_TYPE,
       serial.OUTRESOURCEOID DESTINATION_RESOURCE_OID,
       CASE WHEN (serial.OUTRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Supplier') THEN 'SUPPLIER'
            WHEN (serial.OUTRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Customer') THEN 'CUSTOMER' END AS DESTINATION_RESOURCE_TYPE,
       serial.USRDTS1 USRDTS1,
       serial.USRDTS2 USRDTS2,
       serial.USRDTS3 USRDTS3,
       serial.USRDTS4 USRDTS4,
       serial.USRDTS5 USRDTS5,
       serial.USRFLG1 USRFLG1,
       serial.USRFLG2 USRFLG2,
       serial.USRFLG3 USRFLG3,
       serial.USRFLG4 USRFLG4,
       serial.USRFLG5 USRFLG5,
       serial.USRNUM1 USRNUM1,
       serial.USRNUM2 USRNUM2,
       serial.USRNUM3 USRNUM3,
       serial.USRNUM4 USRNUM4,
       serial.USRNUM5 USRNUM5,
       serial.USRTXT1 USRTXT1,
       serial.USRTXT2 USRTXT2,
       serial.USRTXT3 USRTXT3,
       serial.USRTXT4 USRTXT4,
       serial.USRTXT5 USRTXT5
FROM OBJT_SERIAL serial
     LEFT OUTER JOIN OBJT_STORAGEITEMQTY storageitemqty ON serial.STORAGEITEMQTYOID = storageitemqty.OID
     LEFT OUTER JOIN OBJT_CONTAINERSTORAGEITEMQTY containerstorageitemqty ON storageitemqty.CONTAINERSTORAGEITEMQTYOID = containerstorageitemqty.OID
  LEFT OUTER JOIN OBJT_WAREHOUSELOCATION location ON storageitemqty.WAREHOUSELOCATIONOID = location.OID,
     OBJT_ITEM item
WHERE serial.ITEMOID = item.OID
AND serial.ISVALID = 'T'
UNION ALL
-- select all invalid serials --
SELECT serial.OID OID,
       serial.NAME SERIAL,
       serial.DTSVALIDFROM DTSVALIDFROM,
       serial.DTSVALIDUNTIL DTSVALIDUNTIL,
       serial.ITEMOID ITEM_OID,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       serial.LOTOID LOT_OID,
       serial.LOTID LOT,
       serial.SUBLOTID SUBLOT,
       serial.INVENTORYCODE1 INVENTORYCODE1,
       serial.INVENTORYCODE2 INVENTORYCODE2,
       serial.INVENTORYCODE3 INVENTORYCODE3,
       serial.INVENTORYCODE4 INVENTORYCODE4,
       serial.INVENTORYCODE5 INVENTORYCODE5,
       serial.QUALITYCONTROLSTATUSOID QCSTATUS_OID,
       null AS LOCATION,
       CAST(null AS NUMBER(19)) AS LOCATION_OID,
       CAST(null AS NUMBER(19)) AS WAREHOUSE_OID,
       null AS LPN,
       CAST(null AS NUMBER(19)) AS CONTAINER_OID,
       serial.DTSUPDATE DTSUPDATE,
       serial.INORDERID ORIGIN_ORDER_ID,
       serial.INORDEROID ORIGIN_ORDER_OID,
       CASE WHEN (serial.INORDERCLASSNAME = 'objt.wms.bo.inboundmgt.InboundOrder') THEN 'INBOUNDORDER'
            WHEN (serial.INORDERCLASSNAME = 'objt.mes.bo.productionmgt.ProductionOrder') THEN 'PRODUCTIONORDER' END AS ORIGIN_ORDER_TYPE,
       serial.INRESOURCEOID ORIGIN_RESOURCE_OID,
       CASE WHEN (serial.INRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Supplier') THEN 'SUPPLIER'
            WHEN (serial.INRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Customer') THEN 'CUSTOMER' END AS ORIGIN_RESOURCE_TYPE,
       serial.OUTORDERID DESTINATION_ORDER_ID,
       serial.OUTORDEROID DESTINATION_ORDER_OID,
       CASE WHEN (serial.OUTORDERCLASSNAME = 'objt.wms.bo.outboundmgt.OutboundOrder') THEN 'OUTBOUNDORDER'
            WHEN (serial.OUTORDERCLASSNAME = 'objt.mes.bo.productionmgt.ProductionOrder') THEN 'PRODUCTIONORDER' END AS DESTINATION_ORDER_TYPE,
       serial.OUTRESOURCEOID DESTINATION_RESOURCE_OID,
       CASE WHEN (serial.OUTRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Supplier') THEN 'SUPPLIER'
            WHEN (serial.OUTRESOURCECLASSNAME = 'objt.common.resourcemgt.bo.Customer') THEN 'CUSTOMER' END AS DESTINATION_RESOURCE_TYPE,
       serial.USRDTS1 USRDTS1,
       serial.USRDTS2 USRDTS2,
       serial.USRDTS3 USRDTS3,
       serial.USRDTS4 USRDTS4,
       serial.USRDTS5 USRDTS5,
       serial.USRFLG1 USRFLG1,
       serial.USRFLG2 USRFLG2,
       serial.USRFLG3 USRFLG3,
       serial.USRFLG4 USRFLG4,
       serial.USRFLG5 USRFLG5,
       serial.USRNUM1 USRNUM1,
       serial.USRNUM2 USRNUM2,
       serial.USRNUM3 USRNUM3,
       serial.USRNUM4 USRNUM4,
       serial.USRNUM5 USRNUM5,
       serial.USRTXT1 USRTXT1,
       serial.USRTXT2 USRTXT2,
       serial.USRTXT3 USRTXT3,
       serial.USRTXT4 USRTXT4,
       serial.USRTXT5 USRTXT5
FROM OBJT_SERIAL serial,
     OBJT_ITEM item
WHERE serial.ITEMOID = item.OID
AND serial.ISVALID = 'F'
/

-- INVENTORYTRACES --
CREATE OR REPLACE VIEW OBJTREP_INVENTORYTRACE
AS
SELECT inventorytraceop.OID OID,
       CASE WHEN inventorytraceop.BOTYPE = 0 THEN 'RECEIPT'
            WHEN inventorytraceop.BOTYPE = 1 THEN 'OUTBOUND'
            WHEN inventorytraceop.BOTYPE = 2 THEN 'INPUT'
            WHEN inventorytraceop.BOTYPE = 3 THEN 'OUTPUT'
            WHEN inventorytraceop.BOTYPE = 4 THEN 'LOAD'
            WHEN inventorytraceop.BOTYPE = 5 THEN 'UNLOAD'
            WHEN inventorytraceop.BOTYPE = 6 THEN 'PRERECEIPT'
            WHEN inventorytraceop.BOTYPE = 7 THEN 'PUT'
            WHEN inventorytraceop.BOTYPE = 8 THEN 'PICK'
            WHEN inventorytraceop.BOTYPE = 9 THEN 'MOVE'
            WHEN inventorytraceop.BOTYPE = 10 THEN 'NEST'
            WHEN inventorytraceop.BOTYPE = 11 THEN 'PACK'
            WHEN inventorytraceop.BOTYPE = 12 THEN 'TRANSFER'
            WHEN inventorytraceop.BOTYPE = 13 THEN 'CROSSDOCK'
            WHEN inventorytraceop.BOTYPE = 14 THEN 'REPLENISH'
            WHEN inventorytraceop.BOTYPE = 15 THEN 'INVENTORY'
            ELSE NULL
       END AS TYPE,
       inventorytraceop.CATEGORY CATEGORY,
       inventorytraceop.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inventorytraceop.INVENTORYCODE1 INVENTORY_CODE_1,
       inventorytraceop.INVENTORYCODE2 INVENTORY_CODE_2,
       inventorytraceop.INVENTORYCODE3 INVENTORY_CODE_3,
       inventorytraceop.INVENTORYCODE4 INVENTORY_CODE_4,
       inventorytraceop.INVENTORYCODE5 INVENTORY_CODE_5,
       inventorytraceop.TOQTYDELTA QTY,
       uom.SYMBOL UOM,
       inventorytraceop.DTSSTART DTSSTART,
       inventorytraceop.DTSSTOP DTSSTOP,
       inventorytraceop.FROMLOCATIONOID FROM_LOCATION_OID,
       inventorytraceop.TOLOCATIONOID TO_LOCATION_OID,
       inventorytraceop.FROMCSITQOID FROM_CONTAINER_OID,
       inventorytraceop.TOCSITQOID TO_CONTAINER_OID,
       inventorytraceop.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       inventorytraceop.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       inventorytraceop.EMPLOYEEOID EMPLOYEE_OID,
       inventorytraceop.DEVICEOID DEVICE_OID,
       inventorytraceop.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION inventorytraceop,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE inventorytraceop.UOMOID = uom.OID
AND inventorytraceop.LOTOID = lot.OID
/

-- SERIALINVENTORYTRACES --
CREATE OR REPLACE VIEW OBJTREP_SERIALINVENTORYTRACE
AS
SELECT serialinventorytrace.OID OID,
       inventorytrace.OID INVENTORYTRACE_OID,
       CASE WHEN inventorytrace.BOTYPE = 0 THEN 'RECEIPT'
       WHEN inventorytrace.BOTYPE = 1 THEN 'OUTBOUND'
            WHEN inventorytrace.BOTYPE = 2 THEN 'INPUT'
            WHEN inventorytrace.BOTYPE = 3 THEN 'OUTPUT'
            WHEN inventorytrace.BOTYPE = 4 THEN 'LOAD'
            WHEN inventorytrace.BOTYPE = 5 THEN 'UNLOAD'
            WHEN inventorytrace.BOTYPE = 6 THEN 'PRERECEIPT'
            WHEN inventorytrace.BOTYPE = 7 THEN 'PUT'
            WHEN inventorytrace.BOTYPE = 8 THEN 'PICK'
            WHEN inventorytrace.BOTYPE = 9 THEN 'MOVE'
            WHEN inventorytrace.BOTYPE = 10 THEN 'NEST'
            WHEN inventorytrace.BOTYPE = 11 THEN 'PACK'
            WHEN inventorytrace.BOTYPE = 12 THEN 'TRANSFER'
            WHEN inventorytrace.BOTYPE = 13 THEN 'CROSSDOCK'
            WHEN inventorytrace.BOTYPE = 14 THEN 'REPLENISH'
            WHEN inventorytrace.BOTYPE = 15 THEN 'INVENTORY'
            ELSE NULL
       END AS TYPE,
       inventorytrace.CATEGORY CATEGORY,
       inventorytrace.STATUS STATUS,
       lot.ITEMOID ITEM_OID,
       lot.OID LOT_OID,
       lot.LOTID LOT,
       lot.SUBLOTID SUBLOT,
       inventorytrace.INVENTORYCODE1 INVENTORY_CODE_1,
       inventorytrace.INVENTORYCODE2 INVENTORY_CODE_2,
       inventorytrace.INVENTORYCODE3 INVENTORY_CODE_3,
       inventorytrace.INVENTORYCODE4 INVENTORY_CODE_4,
       inventorytrace.INVENTORYCODE5 INVENTORY_CODE_5,
       CASE WHEN inventorytrace.TOQTYDELTA < 0 THEN CAST(-1 AS NUMBER(10))
            WHEN inventorytrace.TOQTYDELTA > 0 THEN CAST(1 AS NUMBER(10))
            ELSE CAST(0 AS NUMBER(10))
       END AS QTY,
       serial.OID SERIAL_OID,
       serial.NAME SERIAL,
       uom.SYMBOL UOM,
       inventorytrace.DTSSTART DTSSTART,
       inventorytrace.DTSSTOP DTSSTOP,
       inventorytrace.FROMLOCATIONOID FROM_LOCATION_OID,
       inventorytrace.TOLOCATIONOID TO_LOCATION_OID,
       inventorytrace.FROMCSITQOID FROM_CONTAINER_OID,
       inventorytrace.TOCSITQOID TO_CONTAINER_OID,
       inventorytrace.FROMNESTCSITQOID FROM_NEST_CONTAINER_OID,
       inventorytrace.TONESTCSITQOID TO_NEST_CONTAINER_OID,
       inventorytrace.EMPLOYEEOID EMPLOYEE_OID,
       inventorytrace.DEVICEOID DEVICE_OID,
       inventorytrace.DTSUPDATE DTSUPDATE
FROM OBJT_INVENTORYTRACEOPERATION inventorytrace,
     OBJT_SERIALINVENTORYTRACE serialinventorytrace,
     OBJT_SERIAL serial,
     OBJT_LOT lot,
     OBJT_UOM uom
WHERE inventorytrace.OID = serialinventorytrace.INVENTORYTRACEOID
AND serialinventorytrace.SERIALOID = serial.oid
AND inventorytrace.UOMOID = uom.OID
AND inventorytrace.LOTOID = lot.OID
/

-- PURCHASEORDERS --

CREATE OR REPLACE VIEW OBJTREP_PURCHASEORDERS
AS
SELECT /*+ FIRST_ROWS(30) */ purchaseorder.OID OID,
       purchaseorder.NAME NAME,
       purchaseorder.ID ID,
       purchaseorder.DESCRIPTION DESCRIPTION,
       CAST((SELECT supplier.OID FROM OBJT_SUPPLIER supplier, OBJT_ORDERRESOURCELINK purchaseorder_supplier_link
                                  WHERE purchaseorder_supplier_link.RESOURCEOID = supplier.OID
                                  AND purchaseorder_supplier_link.ORDEROID = purchaseorder.OID AND ROWNUM = 1) AS NUMBER(19)) AS SUPPLIER_OID,
       purchaseorder.STATUS STATUS,
       purchaseorder.DTSVALIDFROM DTSVALIDFROM,
       purchaseorder.DTSSTART DTSSTART,
       purchaseorder.DTSSTOP DTSSTOP,
       purchaseorder.DTSUPDATE DTSUPDATE,
       purchaseorder.USRDTS1 USRDTS1,
       purchaseorder.USRDTS2 USRDTS2,
       purchaseorder.USRDTS3 USRDTS3,
       purchaseorder.USRDTS4 USRDTS4,
       purchaseorder.USRDTS5 USRDTS5,
       purchaseorder.USRDTS6 USRDTS6,
       purchaseorder.USRDTS7 USRDTS7,
       purchaseorder.USRDTS8 USRDTS8,
       purchaseorder.USRDTS9 USRDTS9,
       purchaseorder.USRDTS10 USRDTS10,
       purchaseorder.USRDTS11 USRDTS11,
       purchaseorder.USRDTS12 USRDTS12,
       purchaseorder.USRDTS13 USRDTS13,
       purchaseorder.USRDTS14 USRDTS14,
       purchaseorder.USRDTS15 USRDTS15,
       purchaseorder.USRDTS16 USRDTS16,
       purchaseorder.USRDTS17 USRDTS17,
       purchaseorder.USRDTS18 USRDTS18,
       purchaseorder.USRDTS19 USRDTS19,
       purchaseorder.USRDTS20 USRDTS20,
       purchaseorder.USRDTS21 USRDTS21,
       purchaseorder.USRDTS22 USRDTS22,
       purchaseorder.USRDTS23 USRDTS23,
       purchaseorder.USRDTS24 USRDTS24,
       purchaseorder.USRDTS25 USRDTS25,
       purchaseorder.USRDTS26 USRDTS26,
       purchaseorder.USRDTS27 USRDTS27,
       purchaseorder.USRDTS28 USRDTS28,
       purchaseorder.USRDTS29 USRDTS29,
       purchaseorder.USRDTS30 USRDTS30,
       purchaseorder.USRFLG1 USRFLG1,
       purchaseorder.USRFLG2 USRFLG2,
       purchaseorder.USRFLG3 USRFLG3,
       purchaseorder.USRFLG4 USRFLG4,
       purchaseorder.USRFLG5 USRFLG5,
       purchaseorder.USRFLG6 USRFLG6,
       purchaseorder.USRFLG7 USRFLG7,
       purchaseorder.USRFLG8 USRFLG8,
       purchaseorder.USRFLG9 USRFLG9,
       purchaseorder.USRFLG10 USRFLG10,
       purchaseorder.USRFLG11 USRFLG11,
       purchaseorder.USRFLG12 USRFLG12,
       purchaseorder.USRFLG13 USRFLG13,
       purchaseorder.USRFLG14 USRFLG14,
       purchaseorder.USRFLG15 USRFLG15,
       purchaseorder.USRFLG16 USRFLG16,
       purchaseorder.USRFLG17 USRFLG17,
       purchaseorder.USRFLG18 USRFLG18,
       purchaseorder.USRFLG19 USRFLG19,
       purchaseorder.USRFLG20 USRFLG20,
       purchaseorder.USRFLG21 USRFLG21,
       purchaseorder.USRFLG22 USRFLG22,
       purchaseorder.USRFLG23 USRFLG23,
       purchaseorder.USRFLG24 USRFLG24,
       purchaseorder.USRFLG25 USRFLG25,
       purchaseorder.USRFLG26 USRFLG26,
       purchaseorder.USRFLG27 USRFLG27,
       purchaseorder.USRFLG28 USRFLG28,
       purchaseorder.USRFLG29 USRFLG29,
       purchaseorder.USRFLG30 USRFLG30,
       purchaseorder.USRNUM1 USRNUM1,
       purchaseorder.USRNUM2 USRNUM2,
       purchaseorder.USRNUM3 USRNUM3,
       purchaseorder.USRNUM4 USRNUM4,
       purchaseorder.USRNUM5 USRNUM5,
       purchaseorder.USRNUM6 USRNUM6,
       purchaseorder.USRNUM7 USRNUM7,
       purchaseorder.USRNUM8 USRNUM8,
       purchaseorder.USRNUM9 USRNUM9,
       purchaseorder.USRNUM10 USRNUM10,
       purchaseorder.USRNUM11 USRNUM11,
       purchaseorder.USRNUM12 USRNUM12,
       purchaseorder.USRNUM13 USRNUM13,
       purchaseorder.USRNUM14 USRNUM14,
       purchaseorder.USRNUM15 USRNUM15,
       purchaseorder.USRNUM16 USRNUM16,
       purchaseorder.USRNUM17 USRNUM17,
       purchaseorder.USRNUM18 USRNUM18,
       purchaseorder.USRNUM19 USRNUM19,
       purchaseorder.USRNUM20 USRNUM20,
       purchaseorder.USRNUM21 USRNUM21,
       purchaseorder.USRNUM22 USRNUM22,
       purchaseorder.USRNUM23 USRNUM23,
       purchaseorder.USRNUM24 USRNUM24,
       purchaseorder.USRNUM25 USRNUM25,
       purchaseorder.USRNUM26 USRNUM26,
       purchaseorder.USRNUM27 USRNUM27,
       purchaseorder.USRNUM28 USRNUM28,
       purchaseorder.USRNUM29 USRNUM29,
       purchaseorder.USRNUM30 USRNUM30,
       purchaseorder.USRNUM31 USRNUM31,
       purchaseorder.USRNUM32 USRNUM32,
       purchaseorder.USRNUM33 USRNUM33,
       purchaseorder.USRNUM34 USRNUM34,
       purchaseorder.USRNUM35 USRNUM35,
       purchaseorder.USRNUM36 USRNUM36,
       purchaseorder.USRNUM37 USRNUM37,
       purchaseorder.USRNUM38 USRNUM38,
       purchaseorder.USRNUM39 USRNUM39,
       purchaseorder.USRNUM40 USRNUM40,
       purchaseorder.USRNUM41 USRNUM41,
       purchaseorder.USRNUM42 USRNUM42,
       purchaseorder.USRNUM43 USRNUM43,
       purchaseorder.USRNUM44 USRNUM44,
       purchaseorder.USRNUM45 USRNUM45,
       purchaseorder.USRNUM46 USRNUM46,
       purchaseorder.USRNUM47 USRNUM47,
       purchaseorder.USRNUM48 USRNUM48,
       purchaseorder.USRNUM49 USRNUM49,
       purchaseorder.USRNUM50 USRNUM50,
       purchaseorder.USRNUM51 USRNUM51,
       purchaseorder.USRNUM52 USRNUM52,
       purchaseorder.USRNUM53 USRNUM53,
       purchaseorder.USRNUM54 USRNUM54,
       purchaseorder.USRNUM55 USRNUM55,
       purchaseorder.USRNUM56 USRNUM56,
       purchaseorder.USRNUM57 USRNUM57,
       purchaseorder.USRNUM58 USRNUM58,
       purchaseorder.USRNUM59 USRNUM59,
       purchaseorder.USRNUM60 USRNUM60,
       purchaseorder.USRNUM61 USRNUM61,
       purchaseorder.USRNUM62 USRNUM62,
       purchaseorder.USRNUM63 USRNUM63,
       purchaseorder.USRNUM64 USRNUM64,
       purchaseorder.USRNUM65 USRNUM65,
       purchaseorder.USRTXT1 USRTXT1,
       purchaseorder.USRTXT2 USRTXT2,
       purchaseorder.USRTXT3 USRTXT3,
       purchaseorder.USRTXT4 USRTXT4,
       purchaseorder.USRTXT5 USRTXT5,
       purchaseorder.USRTXT6 USRTXT6,
       purchaseorder.USRTXT7 USRTXT7,
       purchaseorder.USRTXT8 USRTXT8,
       purchaseorder.USRTXT9 USRTXT9,
       purchaseorder.USRTXT10 USRTXT10,
       purchaseorder.USRTXT11 USRTXT11,
       purchaseorder.USRTXT12 USRTXT12,
       purchaseorder.USRTXT13 USRTXT13,
       purchaseorder.USRTXT14 USRTXT14,
       purchaseorder.USRTXT15 USRTXT15,
       purchaseorder.USRTXT16 USRTXT16,
       purchaseorder.USRTXT17 USRTXT17,
       purchaseorder.USRTXT18 USRTXT18,
       purchaseorder.USRTXT19 USRTXT19,
       purchaseorder.USRTXT20 USRTXT20,
       purchaseorder.USRTXT21 USRTXT21,
       purchaseorder.USRTXT22 USRTXT22,
       purchaseorder.USRTXT23 USRTXT23,
       purchaseorder.USRTXT24 USRTXT24,
       purchaseorder.USRTXT25 USRTXT25,
       purchaseorder.USRTXT26 USRTXT26,
       purchaseorder.USRTXT27 USRTXT27,
       purchaseorder.USRTXT28 USRTXT28,
       purchaseorder.USRTXT29 USRTXT29,
       purchaseorder.USRTXT30 USRTXT30,
       purchaseorder.USRTXT31 USRTXT31,
       purchaseorder.USRTXT32 USRTXT32,
       purchaseorder.USRTXT33 USRTXT33,
       purchaseorder.USRTXT34 USRTXT34,
       purchaseorder.USRTXT35 USRTXT35,
       purchaseorder.USRTXT36 USRTXT36,
       purchaseorder.USRTXT37 USRTXT37,
       purchaseorder.USRTXT38 USRTXT38,
       purchaseorder.USRTXT39 USRTXT39,
       purchaseorder.USRTXT40 USRTXT40,
       purchaseorder.USRTXT41 USRTXT41,
       purchaseorder.USRTXT42 USRTXT42,
       purchaseorder.USRTXT43 USRTXT43,
       purchaseorder.USRTXT44 USRTXT44,
       purchaseorder.USRTXT45 USRTXT45,
       purchaseorder.USRTXT46 USRTXT46,
       purchaseorder.USRTXT47 USRTXT47,
       purchaseorder.USRTXT48 USRTXT48,
       purchaseorder.USRTXT49 USRTXT49,
       purchaseorder.USRTXT50 USRTXT50,
       purchaseorder.USRTXT51 USRTXT51,
       purchaseorder.USRTXT52 USRTXT52,
       purchaseorder.USRTXT53 USRTXT53,
       purchaseorder.USRTXT54 USRTXT54,
       purchaseorder.USRTXT55 USRTXT55,
       purchaseorder.USRTXT56 USRTXT56,
       purchaseorder.USRTXT57 USRTXT57,
       purchaseorder.USRTXT58 USRTXT58,
       purchaseorder.USRTXT59 USRTXT59,
       purchaseorder.USRTXT60 USRTXT60,
       purchaseorder.USRTXT61 USRTXT61,
       purchaseorder.USRTXT62 USRTXT62,
       purchaseorder.USRTXT63 USRTXT63,
       purchaseorder.USRTXT64 USRTXT64,
       purchaseorder.USRTXT65 USRTXT65

FROM OBJT_PURCHASEORDER purchaseorder
/

-- PURCHASELINES --

CREATE OR REPLACE VIEW OBJTREP_PURCHASEORDERLINES
AS
SELECT /*+ FIRST_ROWS(30) */ purchaseline.OID OID,
       purchaseorder.OID PURCHASEORDER_OID,
       purchaseline.NAME NAME,
       purchaseline.DESCRIPTION DESCRIPTION,
       purchaseline.STATUS STATUS,
       purchaseitemqty.ITEMOID ITEM_OID,
       purchaseitemqty.INVENTORYCODE1 INVENTORY_CODE_1,
       purchaseitemqty.INVENTORYCODE2 INVENTORY_CODE_2,
       purchaseitemqty.INVENTORYCODE3 INVENTORY_CODE_3,
       purchaseitemqty.INVENTORYCODE4 INVENTORY_CODE_4,
       purchaseitemqty.INVENTORYCODE5 INVENTORY_CODE_5,
       purchaseitemqty.QTYTARGET QTYPURCHASED,
       purchaseitemqty.VALUE QTYRECEIVED,
       uom.SYMBOL UOM,
       CAST(GREATEST(purchaseline.DTSUPDATE, purchaseitemqty.DTSUPDATE) AS DATE) DTSUPDATE,
       purchaseline.DTSUPDATE AS DTSUPDATE_1,
       purchaseitemqty.DTSUPDATE AS DTSUPDATE_2,
       purchaseline.USRDTS1 USRDTS1,
       purchaseline.USRDTS2 USRDTS2,
       purchaseline.USRDTS3 USRDTS3,
       purchaseline.USRDTS4 USRDTS4,
       purchaseline.USRDTS5 USRDTS5,
       purchaseline.USRDTS6 USRDTS6,
       purchaseline.USRDTS7 USRDTS7,
       purchaseline.USRDTS8 USRDTS8,
       purchaseline.USRDTS9 USRDTS9,
       purchaseline.USRDTS10 USRDTS10,
       purchaseline.USRDTS11 USRDTS11,
       purchaseline.USRDTS12 USRDTS12,
       purchaseline.USRDTS13 USRDTS13,
       purchaseline.USRDTS14 USRDTS14,
       purchaseline.USRDTS15 USRDTS15,
       purchaseline.USRDTS16 USRDTS16,
       purchaseline.USRDTS17 USRDTS17,
       purchaseline.USRDTS18 USRDTS18,
       purchaseline.USRDTS19 USRDTS19,
       purchaseline.USRDTS20 USRDTS20,
       purchaseline.USRDTS21 USRDTS21,
       purchaseline.USRDTS22 USRDTS22,
       purchaseline.USRDTS23 USRDTS23,
       purchaseline.USRDTS24 USRDTS24,
       purchaseline.USRDTS25 USRDTS25,
       purchaseline.USRDTS26 USRDTS26,
       purchaseline.USRDTS27 USRDTS27,
       purchaseline.USRDTS28 USRDTS28,
       purchaseline.USRDTS29 USRDTS29,
       purchaseline.USRDTS30 USRDTS30,
       purchaseline.USRFLG1 USRFLG1,
       purchaseline.USRFLG2 USRFLG2,
       purchaseline.USRFLG3 USRFLG3,
       purchaseline.USRFLG4 USRFLG4,
       purchaseline.USRFLG5 USRFLG5,
       purchaseline.USRFLG6 USRFLG6,
       purchaseline.USRFLG7 USRFLG7,
       purchaseline.USRFLG8 USRFLG8,
       purchaseline.USRFLG9 USRFLG9,
       purchaseline.USRFLG10 USRFLG10,
       purchaseline.USRFLG11 USRFLG11,
       purchaseline.USRFLG12 USRFLG12,
       purchaseline.USRFLG13 USRFLG13,
       purchaseline.USRFLG14 USRFLG14,
       purchaseline.USRFLG15 USRFLG15,
       purchaseline.USRFLG16 USRFLG16,
       purchaseline.USRFLG17 USRFLG17,
       purchaseline.USRFLG18 USRFLG18,
       purchaseline.USRFLG19 USRFLG19,
       purchaseline.USRFLG20 USRFLG20,
       purchaseline.USRFLG21 USRFLG21,
       purchaseline.USRFLG22 USRFLG22,
       purchaseline.USRFLG23 USRFLG23,
       purchaseline.USRFLG24 USRFLG24,
       purchaseline.USRFLG25 USRFLG25,
       purchaseline.USRFLG26 USRFLG26,
       purchaseline.USRFLG27 USRFLG27,
       purchaseline.USRFLG28 USRFLG28,
       purchaseline.USRFLG29 USRFLG29,
       purchaseline.USRFLG30 USRFLG30,
       purchaseline.USRNUM1 USRNUM1,
       purchaseline.USRNUM2 USRNUM2,
       purchaseline.USRNUM3 USRNUM3,
       purchaseline.USRNUM4 USRNUM4,
       purchaseline.USRNUM5 USRNUM5,
       purchaseline.USRNUM6 USRNUM6,
       purchaseline.USRNUM7 USRNUM7,
       purchaseline.USRNUM8 USRNUM8,
       purchaseline.USRNUM9 USRNUM9,
       purchaseline.USRNUM10 USRNUM10,
       purchaseline.USRNUM11 USRNUM11,
       purchaseline.USRNUM12 USRNUM12,
       purchaseline.USRNUM13 USRNUM13,
       purchaseline.USRNUM14 USRNUM14,
       purchaseline.USRNUM15 USRNUM15,
       purchaseline.USRNUM16 USRNUM16,
       purchaseline.USRNUM17 USRNUM17,
       purchaseline.USRNUM18 USRNUM18,
       purchaseline.USRNUM19 USRNUM19,
       purchaseline.USRNUM20 USRNUM20,
       purchaseline.USRNUM21 USRNUM21,
       purchaseline.USRNUM22 USRNUM22,
       purchaseline.USRNUM23 USRNUM23,
       purchaseline.USRNUM24 USRNUM24,
       purchaseline.USRNUM25 USRNUM25,
       purchaseline.USRNUM26 USRNUM26,
       purchaseline.USRNUM27 USRNUM27,
       purchaseline.USRNUM28 USRNUM28,
       purchaseline.USRNUM29 USRNUM29,
       purchaseline.USRNUM30 USRNUM30,
       purchaseline.USRNUM31 USRNUM31,
       purchaseline.USRNUM32 USRNUM32,
       purchaseline.USRNUM33 USRNUM33,
       purchaseline.USRNUM34 USRNUM34,
       purchaseline.USRNUM35 USRNUM35,
       purchaseline.USRNUM36 USRNUM36,
       purchaseline.USRNUM37 USRNUM37,
       purchaseline.USRNUM38 USRNUM38,
       purchaseline.USRNUM39 USRNUM39,
       purchaseline.USRNUM40 USRNUM40,
       purchaseline.USRNUM41 USRNUM41,
       purchaseline.USRNUM42 USRNUM42,
       purchaseline.USRNUM43 USRNUM43,
       purchaseline.USRNUM44 USRNUM44,
       purchaseline.USRNUM45 USRNUM45,
       purchaseline.USRNUM46 USRNUM46,
       purchaseline.USRNUM47 USRNUM47,
       purchaseline.USRNUM48 USRNUM48,
       purchaseline.USRNUM49 USRNUM49,
       purchaseline.USRNUM50 USRNUM50,
       purchaseline.USRNUM51 USRNUM51,
       purchaseline.USRNUM52 USRNUM52,
       purchaseline.USRNUM53 USRNUM53,
       purchaseline.USRNUM54 USRNUM54,
       purchaseline.USRNUM55 USRNUM55,
       purchaseline.USRNUM56 USRNUM56,
       purchaseline.USRNUM57 USRNUM57,
       purchaseline.USRNUM58 USRNUM58,
       purchaseline.USRNUM59 USRNUM59,
       purchaseline.USRNUM60 USRNUM60,
       purchaseline.USRNUM61 USRNUM61,
       purchaseline.USRNUM62 USRNUM62,
       purchaseline.USRNUM63 USRNUM63,
       purchaseline.USRNUM64 USRNUM64,
       purchaseline.USRNUM65 USRNUM65,
       purchaseline.USRTXT1 USRTXT1,
       purchaseline.USRTXT2 USRTXT2,
       purchaseline.USRTXT3 USRTXT3,
       purchaseline.USRTXT4 USRTXT4,
       purchaseline.USRTXT5 USRTXT5,
       purchaseline.USRTXT6 USRTXT6,
       purchaseline.USRTXT7 USRTXT7,
       purchaseline.USRTXT8 USRTXT8,
       purchaseline.USRTXT9 USRTXT9,
       purchaseline.USRTXT10 USRTXT10,
       purchaseline.USRTXT11 USRTXT11,
       purchaseline.USRTXT12 USRTXT12,
       purchaseline.USRTXT13 USRTXT13,
       purchaseline.USRTXT14 USRTXT14,
       purchaseline.USRTXT15 USRTXT15,
       purchaseline.USRTXT16 USRTXT16,
       purchaseline.USRTXT17 USRTXT17,
       purchaseline.USRTXT18 USRTXT18,
       purchaseline.USRTXT19 USRTXT19,
       purchaseline.USRTXT20 USRTXT20,
       purchaseline.USRTXT21 USRTXT21,
       purchaseline.USRTXT22 USRTXT22,
       purchaseline.USRTXT23 USRTXT23,
       purchaseline.USRTXT24 USRTXT24,
       purchaseline.USRTXT25 USRTXT25,
       purchaseline.USRTXT26 USRTXT26,
       purchaseline.USRTXT27 USRTXT27,
       purchaseline.USRTXT28 USRTXT28,
       purchaseline.USRTXT29 USRTXT29,
       purchaseline.USRTXT30 USRTXT30,
       purchaseline.USRTXT31 USRTXT31,
       purchaseline.USRTXT32 USRTXT32,
       purchaseline.USRTXT33 USRTXT33,
       purchaseline.USRTXT34 USRTXT34,
       purchaseline.USRTXT35 USRTXT35,
       purchaseline.USRTXT36 USRTXT36,
       purchaseline.USRTXT37 USRTXT37,
       purchaseline.USRTXT38 USRTXT38,
       purchaseline.USRTXT39 USRTXT39,
       purchaseline.USRTXT40 USRTXT40,
       purchaseline.USRTXT41 USRTXT41,
       purchaseline.USRTXT42 USRTXT42,
       purchaseline.USRTXT43 USRTXT43,
       purchaseline.USRTXT44 USRTXT44,
       purchaseline.USRTXT45 USRTXT45,
       purchaseline.USRTXT46 USRTXT46,
       purchaseline.USRTXT47 USRTXT47,
       purchaseline.USRTXT48 USRTXT48,
       purchaseline.USRTXT49 USRTXT49,
       purchaseline.USRTXT50 USRTXT50,
       purchaseline.USRTXT51 USRTXT51,
       purchaseline.USRTXT52 USRTXT52,
       purchaseline.USRTXT53 USRTXT53,
       purchaseline.USRTXT54 USRTXT54,
       purchaseline.USRTXT55 USRTXT55,
       purchaseline.USRTXT56 USRTXT56,
       purchaseline.USRTXT57 USRTXT57,
       purchaseline.USRTXT58 USRTXT58,
       purchaseline.USRTXT59 USRTXT59,
       purchaseline.USRTXT60 USRTXT60,
       purchaseline.USRTXT61 USRTXT61,
       purchaseline.USRTXT62 USRTXT62,
       purchaseline.USRTXT63 USRTXT63,
       purchaseline.USRTXT64 USRTXT64,
       purchaseline.USRTXT65 USRTXT65

FROM OBJT_PURCHASEOPERATION purchaseline,
     OBJT_PURCHASEORDER purchaseorder,
     OBJT_PURCHASEITEMQTY purchaseitemqty,
     OBJT_UOM uom
WHERE purchaseorder.OID = purchaseline.PURCHASEORDEROID
AND purchaseline.OID = purchaseitemqty.PURCHASEOPERATIONOID
AND purchaseitemqty.UOMOID = uom.OID
/
