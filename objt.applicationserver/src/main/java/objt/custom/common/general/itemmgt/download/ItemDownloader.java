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
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import dce.dm.Factory;
import dce.pd.frame.download.wrapper.IntegerField;
import dce.util.annotation.Nullable;

import objt.common.itemmgt.bo.Item;
import objt.common.itemmgt.bo.Packaging;
import objt.wms.transaction.ItemTransaction;

import org.bouncycastle.util.Pack;

public class ItemDownloader extends objt.vertical.common.general.itemmgt.download.ItemDownloader
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
  public Item syncBO(objt.vertical.common.general.itemmgt.download.ItemDownloader.DownloadItem pDownloadItem) throws Exception
  {
    Item item = super.syncBO((objt.vertical.common.general.itemmgt.download.ItemDownloader.DownloadItem) pDownloadItem);

    DownloadItem pItem = (DownloadItem) pDownloadItem;

    if (item.isCreated()) item.setUsrFlg1(Boolean.TRUE);

    if (pItem.getPackaging() == null)
    {
      ItemTransaction.get().addPackaging(item, pItem.getPackaging());
    }

    return item;
  }

  @Override
  public boolean validate(objt.vertical.common.general.itemmgt.download.ItemDownloader.DownloadItem pProcessDownloadItem) throws Exception
  {
    super.validate(pProcessDownloadItem);

    DownloadItem item = (DownloadItem) pProcessDownloadItem;

    IntegerField packconfig = item.getpackConfig();

    if (packconfig == null) return false;

    if (packconfig.getValue() == null) return false;

    Integer packconfigValue = packconfig.getValue();

    item.setPackaging(Factory.get().fetchUsingAttribute(Packaging.class, "name", packconfigValue));

    if (item.getPackaging() != null)
    {
      getDownloadResult().addDownloadWarning(pProcessDownloadItem, "Given packconfig is not a template packconfig"); //ivlm
    }

    return true;
  }

  @XmlType(name = "sugaro.DownloadItem")
  @XmlAccessorType(XmlAccessType.NONE)
  public static class DownloadItem extends objt.vertical.common.general.itemmgt.download.ItemDownloader.DownloadItem
  {

    @XmlElement(name = "packconfig")
    public IntegerField packConfig;

    protected transient Packaging packaging;

    public Packaging getPackaging()
    {
      return packaging;
    }

    public void setPackaging(Packaging pPackaging)
    {
      packaging = pPackaging;
    }

    @Nullable
    public IntegerField getpackConfig()
    {
      return packConfig;
    }

    public void setpackConfig(@Nullable Integer pPackConfig)
    {
      if (packConfig == null) packConfig = new IntegerField(pPackConfig);
      else packConfig.setValue(pPackConfig);
    }
  }
}
