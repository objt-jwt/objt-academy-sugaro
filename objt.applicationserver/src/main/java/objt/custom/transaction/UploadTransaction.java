/******************************************************************************
 * Copyright (c) 2020 Objective
 * All rights reserved
 *
 * This software is the confidential and proprietary information of Objective.
 * You shall not disclose this confidential information and shall use it only
 * in accordance with the terms of the license agreement you entered into with
 * Objective.
 *******************************************************************************/
package objt.custom.transaction;

import java.util.List;
import javax.transaction.Transactional;

import dce.bo.transactionmgt.IUploadTransaction;
import dce.pd.transaction.AbstractServerModule;
import dce.pd.transaction.ITransactionListener;
import dce.pd.transaction.util.TransactionEvent;
import dce.util.ObjectFactory;
import dce.util.eventlog.EventLog;

import objt.common.inventorymgt.bo.InventoryTraceOperation;
import objt.common.inventorymgt.transaction.InventoryTraceOperationTransaction;

import objt.custom.bo.inventorymgt.WarehouseLocations;
import objt.wms.bo.inventorymgt.Zone;

import org.w3c.dom.Node;

public class UploadTransaction extends AbstractServerModule implements ITransactionListener
{
  public static final String INVENTORY_MOVE = "INVENTORY.MOVE";

  private static UploadTransaction singleton;
  
  /**
   * Create a new AbstractServerModule
   */
  public UploadTransaction()
  {
    this("CUSTOM_UPLOADTRANSACTION");
  }

  /**
   * Create a new AbstractServerModule using the given modulename
   */
  protected UploadTransaction(String pModuleName)
  {
    super(pModuleName);
  }

  public synchronized static UploadTransaction get() throws InstantiationException
  {
    if (singleton == null) singleton = ObjectFactory.getSingletonInstance(UploadTransaction.class);
    return singleton;
  }

  @Override
  public void init(Node pConfigNode) throws Exception
  {
    super.init(pConfigNode);

    initListeners();
  }

  private void initListeners()
  {
    // actionlisteners
    InventoryTraceOperationTransaction.get().addTransactionListener(this, InventoryTraceOperationTransaction.EVENTCOMMAND_INVENTORYTRACEOPERATION_STATUS_CHANGED);
  }

  @Transactional(Transactional.TxType.MANDATORY)
  @Override
  public void actionPerformed(TransactionEvent pEvent)
  {
    try
    {
      // Get the event parameters
      Object[] parameters = pEvent.getObjectParameters();

      if(InventoryTraceOperationTransaction.EVENTCOMMAND_INVENTORYTRACEOPERATION_STATUS_CHANGED.equals(pEvent.getActionCommand()))
      {
        InventoryTraceOperation inventoryTraceOperation = (InventoryTraceOperation) parameters[0];
        Integer toStatus = (Integer) parameters[1];
        Integer fromStatus = (Integer) parameters[2];

        if (InventoryTraceOperation.STATUS_COMPLETE.equals(toStatus))
        {
          handleInventoryTraceOperationCompleted(inventoryTraceOperation);
        }
      }
    }
    catch (Exception e)
    {
      EventLog.error(UploadTransaction.class.getName(), "actionPerformed", e);
    }
  }

  private void handleInventoryTraceOperationCompleted(InventoryTraceOperation pInventoryTraceOperation) throws Exception
  {  
    Zone fromZone = WarehouseLocations.getERPStorageZone(pInventoryTraceOperation.getFromLocation());
    Zone toZone = WarehouseLocations.getERPStorageZone(pInventoryTraceOperation.getToLocation());

    // Only moves from ERP zone to ERP zone
    if (fromZone == null || toZone == null) return;

    if (!fromZone.equals(toZone))
    {
      List<IUploadTransaction> uploadTransactionList = dce.pd.frame.upload.UploadTransaction.get().createUploadTransactions(INVENTORY_MOVE, pInventoryTraceOperation);
      if (uploadTransactionList != null) dce.pd.frame.upload.UploadTransaction.get().postTransactions(uploadTransactionList, true);
    }
  }
}
