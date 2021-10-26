/******************************************************************************
 * Copyright (c) 2020 Objective
 * All rights reserved
 *
 * This software is the confidential and proprietary information of Objective.
 * You shall not disclose this confidential information and shall use it only
 * in accordance with the terms of the license agreement you entered into with
 * Objective.
 *******************************************************************************/
package objt.custom.bo.inventorymgt;

import java.util.List;

import dce.bo.meta.ui.Validator;
import dce.dm.Factory;

import objt.common.inventorymgt.bo.WarehouseLocation;
import objt.wms.bo.inventorymgt.Zone;

public class WarehouseLocations extends objt.wms.bo.inventorymgt.WarehouseLocations
{
  public static final String CATEGORY_ERP = "ERP";

  public static Zone getERPStorageZone(WarehouseLocation pWarehouseLocation)
  {
    List<Zone> zoneList = WarehouseLocations.getFullParentStorageZoneList(pWarehouseLocation, zone -> CATEGORY_ERP.equals(zone.getCategory()));
    if ((zoneList == null) || (zoneList.isEmpty())) return null;
    return zoneList.get(0);
  }
}
