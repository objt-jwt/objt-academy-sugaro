/******************************************************************************
 * Copyright (c) 2020 Objective
 * All rights reserved
 *
 * This software is the confidential and proprietary information of Objective.
 * You shall not disclose this confidential information and shall use it only
 * in accordance with the terms of the license agreement you entered into with
 * Objective.
 *******************************************************************************/
package objt.custom.common.general.itemmgt.download;

import javax.transaction.Transactional;

import objt.common.itemmgt.bo.Item;

public class ItemDownloader extends objt.common.download.ItemDownloader
{

  public ItemDownloader()
  {
    this(DownloadItem.class);
  }

  protected ItemDownloader(Class<DownloadItem> pClass)
  {
    super(pClass);
  }

  @Transactional(Transactional.TxType.MANDATORY)
  @Override
  public Item syncBO(objt.common.download.ItemDownloader.DownloadItem pDownloadItem) throws Exception
  {
    Item item = super.syncBO(pDownloadItem);

    if (item.isCreated()) item.setUsrFlg1(Boolean.TRUE);

    return item;
  }
}
