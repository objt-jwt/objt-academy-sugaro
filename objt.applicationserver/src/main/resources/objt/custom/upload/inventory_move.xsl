<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" />
  <xsl:template match="/">
    <StockTransfer>
      <ItemId><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield1"/></ItemId>
      <Lot><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield2"/></Lot>
      <Quantity><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield3"/></Quantity>
      <Uom><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield4"/></Uom>
      <FromWarehouse><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield5"/></FromWarehouse>
      <FromLocation><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield6"/></FromLocation>
      <ToWarehouse><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield7"/></ToWarehouse>
      <ToLocation><xsl:value-of select="upload/uploadtransaction[@transtype='9001']/transfield8"/></ToLocation>
    </StockTransfer>
  </xsl:template>
</xsl:stylesheet>