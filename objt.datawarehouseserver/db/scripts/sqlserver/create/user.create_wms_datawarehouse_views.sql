-- SQL Server DATAWAREHOUSE views --

-- ACTUAL INBOUNDOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_INBOUND_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_INBOUND_ACTUALS
GO

CREATE VIEW DCEVIEW_INBOUND_ACTUALS
AS
SELECT inboundorder.ID INBOUNDORDER_ID,
       inboundorder.NAME INBOUNDORDER_DESCRIPTION,
       inboundline.NAME INBOUNDLINE_NAME,
       inboundline.DESCRIPTION INBOUNDLINE_DESCRIPTION,
       inbound_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       inbound_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       inbound_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       inbound_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       inbound_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       inbound_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       inbound_actual.QTY QTY,
       inbound_actual.UOM UOM,
       inbound_actual.DTSSTART DTSSTART,
       inbound_actual.DTSSTOP DTSSTOP,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,   
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_INBOUND_ACTUALS inbound_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON inbound_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON inbound_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON inbound_actual.CONTAINER_OID = container.OID)
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_INBOUNDORDERS inboundorder WITH (NOLOCK),
     DCEREPORT_INBOUNDLINES inboundline WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
	 DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE inbound_actual.INBOUNDORDER_OID = inboundorder.OID
AND inbound_actual.INBOUNDLINE_OID = inboundline.OID
AND inbound_actual.LOT_OID = lot.OID
AND inbound_actual.ITEM_OID = item.OID
AND inbound_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL PRERECEIPTOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_PRERECEIPT_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_PRERECEIPT_ACTUALS
GO

CREATE VIEW DCEVIEW_PRERECEIPT_ACTUALS
AS
SELECT inboundorder.ID INBOUNDORDER_ID,
       inboundorder.NAME INBOUNDORDER_DESCRIPTION,
       inboundline.NAME INBOUNDLINE_NAME,
       inboundline.DESCRIPTION INBOUNDLINE_DESCRIPTION,
       prereceipt_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       prereceipt_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       prereceipt_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       prereceipt_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       prereceipt_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       prereceipt_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       prereceipt_actual.QTY QTY,
       prereceipt_actual.UOM UOM,
       prereceipt_actual.DTSSTART DTSSTART,
       prereceipt_actual.DTSSTOP DTSSTOP,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_PRERECEIPT_ACTUALS prereceipt_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON prereceipt_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON prereceipt_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON prereceipt_actual.CONTAINER_OID = container.OID)
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_INBOUNDORDERS inboundorder WITH (NOLOCK),
     DCEREPORT_INBOUNDLINES inboundline WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK)
WHERE prereceipt_actual.INBOUNDORDER_OID = inboundorder.OID
AND prereceipt_actual.INBOUNDLINE_OID = inboundline.OID
AND prereceipt_actual.LOT_OID = lot.OID
AND prereceipt_actual.ITEM_OID = item.OID
GO

-- ACTUAL PUTOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_PUT_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_PUT_ACTUALS
GO

CREATE VIEW DCEVIEW_PUT_ACTUALS
AS
SELECT CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN productionorder.ID
	          WHEN (putline.ORDER_TYPE = 'MTO') THEN mto_order.ID
	          WHEN (putline.ORDER_TYPE = 'MTS') THEN mts_order.ID
	          WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundorder.ID END AS ORDER_ID,
       CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN productionorder.DESCRIPTION
			      WHEN (putline.ORDER_TYPE = 'MTO') THEN  mto_order.DESCRIPTION
			      WHEN (putline.ORDER_TYPE = 'MTS') THEN  mts_order.DESCRIPTION
			      WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundorder.DESCRIPTION END AS ORDER_DESCRIPTION,
       CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN productionoperation.NAME
			      WHEN (putline.ORDER_TYPE = 'MTO' OR putline.ORDER_TYPE = 'MTS') THEN ''
			      WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundline.NAME END AS ORDERLINE_NAME,
       CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN productionoperation.DESCRIPTION
			      WHEN (putline.ORDER_TYPE = 'MTO' OR putline.ORDER_TYPE = 'MTS') THEN ''
			      WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundline.DESCRIPTION END AS ORDERLINE_DESCRIPTION,
       putline.ORDER_TYPE ORDER_TYPE,
       putorder.ID PUTORDER_ID,
       putorder.DESCRIPTION PUTORDER_DESCRIPTION,
       putline.NAME PUTLINE_NAME,
       putline.DESCRIPTION PUTLINE_DESCRIPTION,
       put_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       put_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       put_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       put_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       put_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       put_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       put_actual.QTY QTY,
       put_actual.UOM UOM,
       put_actual.DTSSTART DTSSTART,
       put_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_PUT_ACTUALS put_actual WITH (NOLOCK)
	      LEFT OUTER JOIN DCEREPORT_PUTLINES putline WITH (NOLOCK) ON put_actual.PUTLINE_OID = putline.OID
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON put_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON put_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON put_actual.TO_CONTAINER_OID = container.OID)
         	  LEFT OUTER JOIN DCEREPORT_INBOUNDORDERS inboundorder WITH (NOLOCK) ON putline.ORDER_OID = inboundorder.OID
        	  LEFT OUTER JOIN DCEREPORT_INBOUNDLINES inboundline WITH (NOLOCK) ON putline.ORDERLINE_OID = inboundline.OID
            LEFT OUTER JOIN DCEREPORT_PRODUCTIONORDERS productionorder WITH (NOLOCK) ON putline.ORDER_OID = productionorder.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONOPERATIONS productionoperation WITH (NOLOCK) ON putline.ORDERLINE_OID = productionoperation.OID
            LEFT OUTER JOIN DCEREPORT_MTO_ORDERS mto_order WITH (NOLOCK) ON putline.ORDER_OID = mto_order.OID
            LEFT OUTER JOIN DCEREPORT_MTS_ORDERS mts_order WITH (NOLOCK) ON putline.ORDER_OID = mts_order.OID
        	  LEFT OUTER JOIN DCEREPORT_MTO_LINES mto_line WITH (NOLOCK) ON putline.ORDERLINE_OID = mto_line.OID
        	  LEFT OUTER JOIN DCEREPORT_MTS_LINES mts_line WITH (NOLOCK) ON putline.ORDERLINE_OID = mts_line.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_PUTORDERS putorder WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE put_actual.PUTORDER_OID = putorder.OID
AND put_actual.LOT_OID = lot.OID
AND put_actual.ITEM_OID = item.OID
AND put_actual.FROM_LOCATION_OID = from_location.OID
AND put_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL CROSSDOCKOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_CROSSDOCK_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_CROSSDOCK_ACTUALS
GO

CREATE VIEW DCEVIEW_CROSSDOCK_ACTUALS
AS
SELECT CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN from_productionorder.ID
	          WHEN (putline.ORDER_TYPE = 'MTO') THEN from_mto_order.ID
	          WHEN (putline.ORDER_TYPE = 'MTS') THEN from_mts_order.ID
	          WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundorder.ID END AS ORDER_ID,
       CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN from_productionorder.DESCRIPTION
		        WHEN (putline.ORDER_TYPE = 'MTO') THEN  from_mto_order.DESCRIPTION
		        WHEN (putline.ORDER_TYPE = 'MTS') THEN  from_mts_order.DESCRIPTION
		        WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundorder.DESCRIPTION END AS ORDER_DESCRIPTION,
       CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN from_productionoperation.NAME
		        WHEN (putline.ORDER_TYPE = 'MTO' OR putline.ORDER_TYPE = 'MTS') THEN ''
	          WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundline.NAME END AS ORDERLINE_NAME,
       CASE WHEN (putline.ORDER_TYPE = 'PRODUCTION') THEN from_productionoperation.DESCRIPTION
	          WHEN (putline.ORDER_TYPE = 'MTO' OR putline.ORDER_TYPE = 'MTS') THEN ''
	          WHEN (putline.ORDER_TYPE = 'RECEIPT' OR putline.ORDER_TYPE = 'RETURN') THEN inboundline.DESCRIPTION END AS ORDERLINE_DESCRIPTION,--
       putline.ORDER_TYPE FROM_ORDER_TYPE,
       putorder.ID PUTORDER_ID,
       putorder.DESCRIPTION PUTORDER_DESCRIPTION,
       putline.NAME PUTLINE_NAME,
       putline.DESCRIPTION PUTLINE_DESCRIPTION,
       CASE WHEN (backorderline.ORDER_TYPE = 'PRODUCTION') THEN to_productionorder.ID
            WHEN (backorderline.ORDER_TYPE = 'MTO') THEN to_mto_order.ID
            WHEN (backorderline.ORDER_TYPE = 'MTS') THEN to_mts_order.ID
       	    WHEN (backorderline.ORDER_TYPE = 'ORDER') THEN outboundorder.ID END AS TO_ORDER_ID,
       CASE WHEN (backorderline.ORDER_TYPE = 'PRODUCTION') THEN to_productionorder.DESCRIPTION
            WHEN (backorderline.ORDER_TYPE = 'MTO') THEN to_mto_order.DESCRIPTION
            WHEN (backorderline.ORDER_TYPE = 'MTS') THEN to_mts_order.DESCRIPTION
       	    WHEN (backorderline.ORDER_TYPE = 'ORDER') THEN outboundorder.DESCRIPTION END AS TO_ORDER_DESCRIPTION,
       CASE WHEN (backorderline.ORDER_TYPE = 'PRODUCTION') THEN to_productionoperation.NAME
            WHEN (backorderline.ORDER_TYPE = 'MTO' OR backorderline.ORDER_TYPE = 'MTS') THEN ''
       	    WHEN (backorderline.ORDER_TYPE = 'ORDER') THEN outboundline.NAME END AS TO_ORDERLINE_NAME,
       CASE WHEN (backorderline.ORDER_TYPE = 'PRODUCTION') THEN to_productionoperation.DESCRIPTION
            WHEN (backorderline.ORDER_TYPE = 'MTO' OR backorderline.ORDER_TYPE = 'MTS') THEN ''
       	    WHEN (backorderline.ORDER_TYPE = 'ORDER') THEN outboundline.DESCRIPTION END AS TO_ORDERLINE_DESCRIPTION,
       backorderline.ORDER_TYPE TO_ORDER_TYPE,
       backorder.ID BACKORDER_ID,
       backorder.DESCRIPTION BACKORDER_DESCRIPTION,
       backorderline.NAME BACKORDERLINE_NAME,
       backorderline.DESCRIPTION BACKORDERLINE_DESCRIPTION,
       crossdock_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       crossdock_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       crossdock_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       crossdock_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       crossdock_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       crossdock_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       crossdock_actual.QTY QTY,
       crossdock_actual.UOM UOM,
       crossdock_actual.DTSSTART DTSSTART,
       crossdock_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_CROSSDOCK_ACTUALS crossdock_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_PUTLINES putline WITH (NOLOCK) ON crossdock_actual.PUTLINE_OID = putline.OID
        LEFT OUTER JOIN DCEREPORT_BACKORDERLINES backorderline WITH (NOLOCK) ON crossdock_actual.BACKORDERLINE_OID = backorderline.OID
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON crossdock_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON crossdock_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON crossdock_actual.TO_CONTAINER_OID = container.OID)
            LEFT OUTER JOIN DCEREPORT_INBOUNDORDERS inboundorder WITH (NOLOCK) ON putline.ORDER_OID = inboundorder.OID
        	  LEFT OUTER JOIN DCEREPORT_INBOUNDLINES inboundline WITH (NOLOCK) ON putline.ORDERLINE_OID = inboundline.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONORDERS from_productionorder WITH (NOLOCK) ON putline.ORDER_OID = from_productionorder.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONOPERATIONS from_productionoperation WITH (NOLOCK) ON putline.ORDERLINE_OID = from_productionoperation.OID
        	  LEFT OUTER JOIN DCEREPORT_MTO_ORDERS from_mto_order WITH (NOLOCK) ON putline.ORDER_OID = from_mto_order.OID
        	  LEFT OUTER JOIN DCEREPORT_MTS_ORDERS from_mts_order WITH (NOLOCK) ON putline.ORDER_OID = from_mts_order.OID
        	  LEFT OUTER JOIN DCEREPORT_MTO_LINES from_mto_line WITH (NOLOCK) ON putline.ORDERLINE_OID = from_mto_line.OID
        	  LEFT OUTER JOIN DCEREPORT_MTS_LINES from_mts_line WITH (NOLOCK) ON putline.ORDERLINE_OID = from_mts_line.OID
        	  LEFT OUTER JOIN DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK) ON backorderline.ORDER_OID = outboundorder.OID
        	  LEFT OUTER JOIN DCEREPORT_OUTBOUNDLINES outboundline WITH (NOLOCK) ON backorderline.ORDERLINE_OID = outboundline.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONORDERS to_productionorder WITH (NOLOCK) ON backorderline.ORDER_OID = to_productionorder.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONOPERATIONS to_productionoperation WITH (NOLOCK) ON backorderline.ORDERLINE_OID = to_productionoperation.OID
        	  LEFT OUTER JOIN DCEREPORT_MTO_ORDERS to_mto_order WITH (NOLOCK) ON backorderline.ORDER_OID = to_mto_order.OID
        	  LEFT OUTER JOIN DCEREPORT_MTS_ORDERS to_mts_order WITH (NOLOCK) ON backorderline.ORDER_OID = to_mts_order.OID
        	  LEFT OUTER JOIN DCEREPORT_MTO_LINES to_mto_line WITH (NOLOCK) ON backorderline.ORDERLINE_OID = to_mto_line.OID
        	  LEFT OUTER JOIN DCEREPORT_MTS_LINES to_mts_line WITH (NOLOCK) ON backorderline.ORDERLINE_OID = to_mts_line.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_PUTORDERS putorder WITH (NOLOCK),
     DCEREPORT_BACKORDERS backorder WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE crossdock_actual.PUTORDER_OID = putorder.OID
AND crossdock_actual.BACKORDER_OID = backorder.OID
AND crossdock_actual.LOT_OID = lot.OID
AND crossdock_actual.ITEM_OID = item.OID
AND crossdock_actual.FROM_LOCATION_OID = from_location.OID
AND crossdock_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL OUTBOUNDOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_OUTBOUND_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_OUTBOUND_ACTUALS
GO

CREATE VIEW DCEVIEW_OUTBOUND_ACTUALS
AS
SELECT outboundorder.ID OUTBOUNDORDER_ID,
       outboundorder.NAME OUTBOUNDORDER_DESCRIPTION,
       outboundline.NAME OUTBOUNDLINE_NAME,
       outboundline.DESCRIPTION OUTBOUNDLINE_DESCRIPTION,
       outbound_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       outbound_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       outbound_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       outbound_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       outbound_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       outbound_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       outbound_actual.QTY QTY,
       outbound_actual.UOM UOM,
       outbound_actual.DTSSTART DTSSTART,
       outbound_actual.DTSSTOP DTSSTOP,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_OUTBOUND_ACTUALS outbound_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON outbound_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON outbound_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON outbound_actual.CONTAINER_OID = container.OID)
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK),
     DCEREPORT_OUTBOUNDLINES outboundline WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE outbound_actual.OUTBOUNDORDER_OID = outboundorder.OID
AND outbound_actual.OUTBOUNDLINE_OID = outboundline.OID
AND outbound_actual.LOT_OID = lot.OID
AND outbound_actual.ITEM_OID = item.OID
AND outbound_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL PICKOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_PICK_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_PICK_ACTUALS
GO

CREATE VIEW DCEVIEW_PICK_ACTUALS
AS
SELECT DISTINCT
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionorder.ID
            WHEN (pickline.ORDER_TYPE = 'MTO') THEN mto_order.ID
            WHEN (pickline.ORDER_TYPE = 'MTS') THEN mts_order.ID
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundorder.ID END AS ORDER_ID,
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionorder.DESCRIPTION
            WHEN (pickline.ORDER_TYPE = 'MTO') THEN mto_order.DESCRIPTION
            WHEN (pickline.ORDER_TYPE = 'MTS') THEN mts_order.DESCRIPTION
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundorder.DESCRIPTION END AS ORDER_DESCRIPTION,
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionoperation.NAME
            WHEN (pickline.ORDER_TYPE = 'MTO' OR pickline.ORDER_TYPE = 'MTS') THEN ''
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundline.NAME END AS ORDERLINE_NAME,
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionoperation.DESCRIPTION
            WHEN (pickline.ORDER_TYPE = 'MTO' OR pickline.ORDER_TYPE = 'MTS') THEN ''
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundline.DESCRIPTION END AS ORDERLINE_DESCRIPTION,
       pickline.ORDER_TYPE ORDER_TYPE,
       pickorder.ID PICKORDER_ID,
       pickorder.DESCRIPTION PICKORDER_DESCRIPTION,
       pickline.NAME PICKLINE_NAME,
       pickline.DESCRIPTION PICKLINE_DESCRIPTION,
       pick_actual.PICK_TYPE PICK_TYPE,
       pick_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       pick_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       pick_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       pick_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       pick_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       pick_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       pick_actual.QTY QTY,
       pick_actual.UOM UOM,
       pick_actual.DTSSTART DTSSTART,
       pick_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       from_container.LPN FROM_CONTAINER_LPN,
       from_container.SERIAL FROM_CONTAINER_SERIAL,
       from_container_type.NAME FROM_CONTAINER_TYPE_NAME,
       from_container_type.DESCRIPTION FROM_CONTAINER_TYPE_DESCR,
       to_container.LPN TO_CONTAINER_LPN,
       to_container.SERIAL TO_CONTAINER_SERIAL,
       to_container_type.NAME TO_CONTAINER_TYPE_NAME,
       to_container_type.DESCRIPTION TO_CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_PICK_ACTUALS pick_actual WITH (NOLOCK)
	      LEFT OUTER JOIN DCEREPORT_PICKLINES pickline WITH (NOLOCK) ON pick_actual.PICKLINE_OID = pickline.OID
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON pick_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON pick_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS from_container WITH (NOLOCK) ON pick_actual.FROM_CONTAINER_OID = from_container.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS to_container WITH (NOLOCK) ON pick_actual.TO_CONTAINER_OID = to_container.OID)
            LEFT OUTER JOIN DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK) ON pickline.ORDER_OID = outboundorder.OID
        	  LEFT OUTER JOIN DCEREPORT_OUTBOUNDLINES outboundline WITH (NOLOCK) ON pickline.ORDERLINE_OID = outboundline.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONORDERS productionorder WITH (NOLOCK) ON pickline.ORDER_OID = productionorder.OID
            LEFT OUTER JOIN DCEREPORT_PRODUCTIONOPERATIONS productionoperation WITH (NOLOCK) ON pickline.ORDERLINE_OID = productionoperation.OID
            LEFT OUTER JOIN DCEREPORT_MTO_ORDERS mto_order WITH (NOLOCK) ON pickline.ORDER_OID = mto_order.OID
            LEFT OUTER JOIN DCEREPORT_MTS_ORDERS mts_order WITH (NOLOCK) ON pickline.ORDER_OID = mts_order.OID
            LEFT OUTER JOIN DCEREPORT_MTO_LINES mto_line WITH (NOLOCK) ON pickline.ORDERLINE_OID = mto_line.OID
            LEFT OUTER JOIN DCEREPORT_MTS_LINES mts_line WITH (NOLOCK) ON pickline.ORDERLINE_OID = mts_line.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES from_container_type WITH (NOLOCK) ON from_container.CONTAINER_TYPE_OID = from_container_type.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES to_container_type WITH (NOLOCK) ON to_container.CONTAINER_TYPE_OID = to_container_type.OID,
     DCEREPORT_PICKORDERS pickorder WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE pick_actual.PICKORDER_OID = pickorder.OID
AND pick_actual.LOT_OID = lot.OID
AND pick_actual.ITEM_OID = item.OID
AND pick_actual.FROM_LOCATION_OID = from_location.OID
AND pick_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL PACKOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_TRANSFER_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_TRANSFER_ACTUALS
GO

CREATE VIEW DCEVIEW_TRANSFER_ACTUALS
AS
SELECT DISTINCT
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionorder.ID
            WHEN (pickline.ORDER_TYPE = 'MTO') THEN mto_order.ID
            WHEN (pickline.ORDER_TYPE = 'MTS') THEN mts_order.ID
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundorder.ID END AS ORDER_ID,
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionorder.DESCRIPTION
            WHEN (pickline.ORDER_TYPE = 'MTO') THEN mto_order.DESCRIPTION
            WHEN (pickline.ORDER_TYPE = 'MTS') THEN mts_order.DESCRIPTION
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundorder.DESCRIPTION END AS ORDER_DESCRIPTION,
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionoperation.NAME
            WHEN (pickline.ORDER_TYPE = 'MTO' OR pickline.ORDER_TYPE = 'MTS') THEN ''
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundline.NAME END AS ORDERLINE_NAME,
       CASE WHEN (pickline.ORDER_TYPE = 'PRODUCTION') THEN productionoperation.DESCRIPTION
            WHEN (pickline.ORDER_TYPE = 'MTO' OR pickline.ORDER_TYPE = 'MTS') THEN ''
       	    WHEN (pickline.ORDER_TYPE = 'ORDER') THEN outboundline.DESCRIPTION END AS ORDERLINE_DESCRIPTION,
       pickline.ORDER_TYPE ORDER_TYPE,
       pickorder.ID PICKORDER_ID,
       pickorder.DESCRIPTION PICKORDER_DESCRIPTION,
       pickline.NAME PICKLINE_NAME,
       pickline.DESCRIPTION PICKLINE_DESCRIPTION,
       transfer_actual.PICK_TYPE PICK_TYPE,
       transfer_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       transfer_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       transfer_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       transfer_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       transfer_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       transfer_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       transfer_actual.QTY QTY,
       transfer_actual.UOM UOM,
       transfer_actual.DTSSTART DTSSTART,
       transfer_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       from_container.LPN FROM_CONTAINER_LPN,
       from_container.SERIAL FROM_CONTAINER_SERIAL,
       from_container_type.NAME FROM_CONTAINER_TYPE_NAME,
       from_container_type.DESCRIPTION FROM_CONTAINER_TYPE_DESCR,
       to_container.LPN TO_CONTAINER_LPN,
       to_container.SERIAL TO_CONTAINER_SERIAL,
       to_container_type.NAME TO_CONTAINER_TYPE_NAME,
       to_container_type.DESCRIPTION TO_CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_TRANSFER_ACTUALS transfer_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_PICKLINES pickline WITH (NOLOCK) ON transfer_actual.PICKLINE_OID = pickline.OID
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON transfer_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON transfer_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS from_container WITH (NOLOCK) ON transfer_actual.FROM_CONTAINER_OID = from_container.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS to_container WITH (NOLOCK) ON transfer_actual.TO_CONTAINER_OID = to_container.OID)
            LEFT OUTER JOIN DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK) ON pickline.ORDER_OID = outboundorder.OID
        	  LEFT OUTER JOIN DCEREPORT_OUTBOUNDLINES outboundline WITH (NOLOCK) ON pickline.ORDERLINE_OID = outboundline.OID
        	  LEFT OUTER JOIN DCEREPORT_PRODUCTIONORDERS productionorder WITH (NOLOCK) ON pickline.ORDER_OID = productionorder.OID
            LEFT OUTER JOIN DCEREPORT_PRODUCTIONOPERATIONS productionoperation WITH (NOLOCK) ON pickline.ORDERLINE_OID = productionoperation.OID
            LEFT OUTER JOIN DCEREPORT_MTO_ORDERS mto_order WITH (NOLOCK) ON pickline.ORDER_OID = mto_order.OID
            LEFT OUTER JOIN DCEREPORT_MTS_ORDERS mts_order WITH (NOLOCK) ON pickline.ORDER_OID = mts_order.OID
            LEFT OUTER JOIN DCEREPORT_MTO_LINES mto_line WITH (NOLOCK) ON pickline.ORDERLINE_OID = mto_line.OID
            LEFT OUTER JOIN DCEREPORT_MTS_LINES mts_line WITH (NOLOCK) ON pickline.ORDERLINE_OID = mts_line.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES from_container_type WITH (NOLOCK) ON from_container.CONTAINER_TYPE_OID = from_container_type.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES to_container_type WITH (NOLOCK) ON to_container.CONTAINER_TYPE_OID = to_container_type.OID,
     DCEREPORT_PICKORDERS pickorder WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE transfer_actual.PICKORDER_OID = pickorder.OID
AND transfer_actual.LOT_OID = lot.OID
AND transfer_actual.ITEM_OID = item.OID
AND transfer_actual.FROM_LOCATION_OID = from_location.OID
AND transfer_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL PACKOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_PACK_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_PACK_ACTUALS
GO

CREATE VIEW DCEVIEW_PACK_ACTUALS
AS
SELECT outboundorder.ID OUTBOUNDORDER_ID,
       outboundorder.DESCRIPTION OUTBOUNDORDER_DESCRIPTION,
       outboundline.NAME OUTBOUNDLINE_NAME,
       outboundline.DESCRIPTION OUTBOUNDLINE_DESCRIPTION,
       packorder.ID PACKORDER_ID,
       packorder.DESCRIPTION PACKORDER_DESCRIPTION,
       packline.NAME PACKLINE_NAME,
       packline.DESCRIPTION PACKLINE_DESCRIPTION,
       pack_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       pack_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       pack_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       pack_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       pack_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       pack_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       pack_actual.QTY QTY,
       pack_actual.UOM UOM,
       pack_actual.DTSSTART DTSSTART,
       pack_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       from_container.LPN FROM_CONTAINER_LPN,
       from_container.SERIAL FROM_CONTAINER_SERIAL,
       from_container_type.NAME FROM_CONTAINER_TYPE_NAME,
       from_container_type.DESCRIPTION FROM_CONTAINER_TYPE_DESCR,
       to_container.LPN TO_CONTAINER_LPN,
       to_container.SERIAL TO_CONTAINER_SERIAL,
       to_container_type.NAME TO_CONTAINER_TYPE_NAME,
       to_container_type.DESCRIPTION TO_CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_PACK_ACTUALS pack_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_PACKLINES packline WITH (NOLOCK) ON pack_actual.PACKLINE_OID = packline.OID
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON pack_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON pack_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS from_container WITH (NOLOCK) ON pack_actual.FROM_CONTAINER_OID = from_container.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS to_container WITH (NOLOCK) ON pack_actual.TO_CONTAINER_OID = to_container.OID)
            LEFT OUTER JOIN DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK) ON packline.OUTBOUNDORDER_OID = outboundorder.OID
        	  LEFT OUTER JOIN DCEREPORT_OUTBOUNDLINES outboundline WITH (NOLOCK) ON packline.OUTBOUNDLINE_OID = outboundline.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES from_container_type WITH (NOLOCK) ON from_container.CONTAINER_TYPE_OID = from_container_type.OID
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES to_container_type WITH (NOLOCK) ON to_container.CONTAINER_TYPE_OID = to_container_type.OID,
     DCEREPORT_PACKORDERS packorder WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE pack_actual.PACKORDER_OID = packorder.OID
AND pack_actual.LOT_OID = lot.OID
AND pack_actual.ITEM_OID = item.OID
AND pack_actual.FROM_LOCATION_OID = from_location.OID
AND pack_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL SHIPOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_SHIP_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_SHIP_ACTUALS
GO

CREATE VIEW DCEVIEW_SHIP_ACTUALS
AS
SELECT outboundorder.ID OUTBOUNDORDER_ID,
       outboundorder.DESCRIPTION OUTBOUNDORDER_DESCRIPTION,
       outboundline.NAME OUTBOUNDLINE_NAME,
       outboundline.DESCRIPTION OUTBOUNDLINE_DESCRIPTION,
       shiporder.ID SHIPORDER_ID,
       shiporder.DESCRIPTION SHIPORDER_DESCRIPTION,
       shipline.NAME SHIPLINE_NAME,
       shipline.DESCRIPTION SHIPLINE_DESCRIPTION,
       ship_actual.CATEGORY CATEGORY,
       ship_actual.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       ship_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       ship_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       ship_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       ship_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       ship_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       ship_actual.QTY QTY,
       ship_actual.UOM UOM,
       ship_actual.DTSSTART DTSSTART,
       ship_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_SHIP_ACTUALS ship_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON ship_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON ship_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON ship_actual.CONTAINER_OID = container.OID)
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK),
     DCEREPORT_OUTBOUNDLINES outboundline WITH (NOLOCK),
     DCEREPORT_SHIPORDERS shiporder WITH (NOLOCK),
     DCEREPORT_SHIPLINES shipline WITH (NOLOCK),
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE ship_actual.OUTBOUNDORDER_OID = outboundorder.OID
AND ship_actual.OUTBOUNDLINE_OID = outboundline.OID
AND ship_actual.SHIPORDER_OID = shiporder.OID
AND ship_actual.SHIPLINE_OID = shipline.OID
AND ship_actual.LOT_OID = lot.OID
AND ship_actual.ITEM_OID = item.OID
AND ship_actual.FROM_LOCATION_OID = from_location.OID
AND ship_actual.TO_LOCATION_OID = to_location.OID
GO

-- ACTUAL REPLENISHOPERATIONS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_REPLENISH_ACTUALS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_REPLENISH_ACTUALS
GO

CREATE VIEW DCEVIEW_REPLENISH_ACTUALS
AS
SELECT item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       replenish_actual.INVENTORY_CODE_1 INVENTORY_CODE_1,
       replenish_actual.INVENTORY_CODE_2 INVENTORY_CODE_2,
       replenish_actual.INVENTORY_CODE_3 INVENTORY_CODE_3,
       replenish_actual.INVENTORY_CODE_4 INVENTORY_CODE_4,
       replenish_actual.INVENTORY_CODE_5 INVENTORY_CODE_5,
       replenish_actual.QTY QTY,
       replenish_actual.UOM UOM,
       replenish_actual.STATUS STATUS,
       replenish_actual.DTSSTART DTSSTART,
       replenish_actual.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_REPLENISH_ACTUALS replenish_actual WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON replenish_actual.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON replenish_actual.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON replenish_actual.TO_CONTAINER_OID = container.OID)
            LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID,
     DCEREPORT_LOTS lot WITH (NOLOCK),
     DCEREPORT_ITEMS item WITH (NOLOCK),
     DCEREPORT_LOCATIONS from_location WITH (NOLOCK),
     DCEREPORT_LOCATIONS to_location WITH (NOLOCK)
WHERE replenish_actual.LOT_OID = lot.OID
AND replenish_actual.ITEM_OID = item.OID
AND replenish_actual.FROM_LOCATION_OID = from_location.OID
AND replenish_actual.TO_LOCATION_OID = to_location.OID
GO

-- TASKS --

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('DCEVIEW_TASKS') AND OBJECTPROPERTY(id, 'IsView') = 1)
DROP VIEW DCEVIEW_TASKS
GO

CREATE VIEW DCEVIEW_TASKS
AS
SELECT DISTINCT
       task.task_type TASK_TYPE,
       task.TYPE TYPE,
       CASE WHEN (task.TASK_TYPE = 'PUT') THEN putorder.ID
            WHEN (task.TASK_TYPE = 'CROSSDOCK') THEN backorder.ID
            WHEN (task.TASK_TYPE = 'PICK' OR task.TASK_TYPE = 'TRANSFER') THEN pickorder.ID
            WHEN (task.TASK_TYPE = 'LOAD' OR task.TASK_TYPE = 'UNLOAD') THEN shiporder.ID
            WHEN (task.TASK_TYPE = 'OUTBOUND') THEN outboundorder.ID END AS ORDER_ID,
       CASE WHEN (task.TASK_TYPE = 'PUT') THEN putorder.DESCRIPTION
            WHEN (task.TASK_TYPE = 'CROSSDOCK') THEN backorder.DESCRIPTION
            WHEN (task.TASK_TYPE = 'PICK' OR task.TASK_TYPE = 'TRANSFER') THEN pickorder.DESCRIPTION
            WHEN (task.TASK_TYPE = 'LOAD' OR task.TASK_TYPE = 'UNLOAD') THEN shiporder.DESCRIPTION
            WHEN (task.TASK_TYPE = 'OUTBOUND') THEN outboundorder.DESCRIPTION END AS ORDER_DESCRIPTION,
       workzone.NAME WORKZONE_NAME,
       workzone.DESCRIPTION WORKZONE_DESCRIPTION,
       task.STATUS STATUS,
       item.NAME ITEM_NAME,
       item.DESCRIPTION ITEM_DESCRIPTION,
       item.EANCODE ITEM_EANCODE,
       lot.LOT_ID LOT,
       lot.SUBLOT_ID SUBLOT,
       lot.SERIAL_ID SERIAL,
       lot.DTSBESTBEFORE DTSBESTBEFORE,
       task.INVENTORY_CODE_1 INVENTORY_CODE_1,
       task.INVENTORY_CODE_2 INVENTORY_CODE_2,
       task.INVENTORY_CODE_3 INVENTORY_CODE_3,
       task.INVENTORY_CODE_4 INVENTORY_CODE_4,
       task.INVENTORY_CODE_5 INVENTORY_CODE_5,
       task.QTY QTY,
       task.UOM UOM,
       task.DTSSTART DTSSTART,
       task.DTSSTOP DTSSTOP,
       from_location.FULLNAME FROM_LOCATION_NAME,
       to_location.FULLNAME TO_LOCATION_NAME,
       container.LPN CONTAINER_LPN,
       container.SERIAL CONTAINER_SERIAL,
       container_type.NAME CONTAINER_TYPE_NAME,
       container_type.DESCRIPTION CONTAINER_TYPE_DESCRIPTION,
       employee.FIRSTNAME EMPLOYEE_FIRSTNAME,
       employee.NAME EMPLOYEE_NAME,
       employee.DESCRIPTION EMPLOYEE_DESCRIPTION,
       device.NAME DEVICE_NAME,
       device.DESCRIPTION DEVICE_DESCRIPTION
FROM (DCEREPORT_TASKS task WITH (NOLOCK)
        LEFT OUTER JOIN DCEREPORT_PUTORDERS putorder WITH (NOLOCK) ON task.ORDER_OID = putorder.OID
        LEFT OUTER JOIN DCEREPORT_BACKORDERS backorder WITH (NOLOCK) ON task.ORDER_OID = backorder.OID
        LEFT OUTER JOIN DCEREPORT_PICKORDERS pickorder WITH (NOLOCK) ON task.ORDER_OID = pickorder.OID
        LEFT OUTER JOIN DCEREPORT_SHIPORDERS shiporder WITH (NOLOCK) ON task.ORDER_OID = shiporder.OID
        LEFT OUTER JOIN DCEREPORT_OUTBOUNDORDERS outboundorder WITH (NOLOCK) ON task.ORDER_OID = outboundorder.OID
        LEFT OUTER JOIN DCEREPORT_WORKZONES workzone WITH (NOLOCK) ON task.WORKZONE_OID = workzone.OID
        LEFT OUTER JOIN DCEREPORT_LOTS lot WITH (NOLOCK) ON task.LOT_OID = lot.OID
        LEFT OUTER JOIN DCEREPORT_ITEMS item WITH (NOLOCK) ON task.ITEM_OID = item.OID
        LEFT OUTER JOIN DCEREPORT_LOCATIONS from_location WITH (NOLOCK) ON task.FROM_LOCATION_OID = from_location.OID
        LEFT OUTER JOIN DCEREPORT_LOCATIONS to_location WITH (NOLOCK) ON task.TO_LOCATION_OID = to_location.OID
        LEFT OUTER JOIN DCEREPORT_EMPLOYEES employee WITH (NOLOCK) ON task.EMPLOYEE_OID = employee.OID
        LEFT OUTER JOIN DCEREPORT_DEVICES device WITH (NOLOCK) ON task.DEVICE_OID = device.OID
        LEFT OUTER JOIN DCEREPORT_CONTAINERS container WITH (NOLOCK) ON task.CONTAINER_OID = container.OID)
        LEFT OUTER JOIN DCEREPORT_CONTAINER_TYPES container_type WITH (NOLOCK) ON container.CONTAINER_TYPE_OID = container_type.OID
GO