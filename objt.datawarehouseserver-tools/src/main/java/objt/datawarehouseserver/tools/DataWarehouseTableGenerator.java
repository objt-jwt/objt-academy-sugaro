/* *****************************************************************************
 * Copyright (c) 2007 De Clercq Engineering BVBA, Belgium
 * All rights reserved
 *
 * This software is the confidential and proprietary information
 * of De Clercq Engineering BVBA. You shall not disclose this
 * confidential information and shall use it only in accordance
 * with the terms of the license agreement you entered into with
 * De Clercq Engineering BVBA.
 * ****************************************************************************
 */

package objt.datawarehouseserver.tools;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import dce.bo.meta.db.Column;
import dce.bo.meta.db.Database;
import dce.bo.meta.db.Table;
import dce.pd.frame.datawarehouse.AbstractDatabaseConnection;
import dce.util.ApplicationProperties;
import dce.util.Collections;
import dce.util.XmlUtil;
import dce.util.annotation.Nullable;
import dce.util.eventlog.EventLog;
import dce.util.eventlog.EventLogger;
import dce.util.text.StringUtil;

import objt.meta.tools.db.AbstractDatabaseGenerator;
import objt.meta.tools.db.GenDbMySql;
import objt.app.datawarehouseserver.module.DataWarehouseHandler;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Utility class that generates table script for the views indicated in the DataWarehouseHandler's configuration file
 */
public class DataWarehouseTableGenerator
{
  public DataWarehouseTableGenerator(String pPropertiesFilename, String pConfigFile) throws Exception
  {
    // Initialize properties
    propertiesInit(pPropertiesFilename);

    Node dataWarehouseHandlerNode = openXmlConfig(pConfigFile);

    // initialize the datawarehousehandler so that he can provide us with sufficient data
    DataWarehouseHandler dataWarehouseHandler = new DataWarehouseHandler();
    dataWarehouseHandler.setModuleName(XmlUtil.getAttributeByName(dataWarehouseHandlerNode, "name", "DATAWAREHOUSEHANDLER"));
    dataWarehouseHandler.initConfiguration(dataWarehouseHandlerNode);
    dataWarehouseHandler.initDatabaseConnection();

    String datawarehouseDatabaseVendor = System.getProperty("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.VENDOR");
    if (datawarehouseDatabaseVendor == null) throw new Exception("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.VENDOR not specified");

    String outputPath = System.getProperty("DATAWAREHOUSETABLEGENERATOR.OUTPUTPATH");
    if (outputPath == null) throw new Exception("DATAWAREHOUSETABLEGENERATOR.OUTPUTPATH not specified");

    // prepare the vendor specific output path
    outputPath = outputPath + "/" + datawarehouseDatabaseVendor.toLowerCase() + "/create/";
    Files.createDirectories(Paths.get(outputPath));

    // build a map containing the table names with their module name
    Map<String, String> tableModuleMap = getTableModuleMap(dataWarehouseHandlerNode);

    // determine all the source tables/views from the datawarehousehandler
    List<Table> tableList = getSourceTables(dataWarehouseHandler);

    // re-organize the tables by module
    Map<String, List<Table>> moduleTableListMap = (tableList != null) ? Collections.getMappedListFromList(tableList, table -> (tableModuleMap != null) ? tableModuleMap.get(table.getName()) : null) : null;
    if (moduleTableListMap != null)
    {
      // create the generator
      AbstractDatabaseGenerator databaseGenerator = createDatabaseGenerator(datawarehouseDatabaseVendor);

      for (Map.Entry<String, List<Table>> entry : moduleTableListMap.entrySet())
      {
        String module = entry.getKey();
        // generate the table creation script
        String filePath = outputPath + "/user.create_" + ((module != null) ? module + "_" : "") + "datawarehouse_tables.sql";
        generateCreateTablesScript(filePath, entry.getValue(), databaseGenerator);
      }

      // generate the relations as well (if any)
      List<Relation> relationList = getRelationList(dataWarehouseHandlerNode, dataWarehouseHandler.getSiteId() != null);
      if (relationList != null)
      {
        if (databaseGenerator instanceof IRelationGenerator)
        {
          Map<String, List<Relation>> moduleRelationListMap = Collections.getMappedListFromList(relationList, relation -> (tableModuleMap != null) ? tableModuleMap.get(relation.getFromTableName()) : null);

          for (Map.Entry<String, List<Relation>> entry : moduleRelationListMap.entrySet())
          {
            String module = entry.getKey();
            // generate the table creation script
            String filePath = outputPath + "/user.create_" + ((module != null) ? module + "_" : "") + "datawarehouse_relations.sql";
            generateCreateRelationsScript(filePath, entry.getValue(), (IRelationGenerator) databaseGenerator);
          }
        }
        else
        {
          EventLog.warning(DataWarehouseTableGenerator.class.getName(), "DataWarehouseTableGenerator", "Database generator does not support relation creation");
        }
      }
    }
    else
    {
      EventLog.warning(getClass().getName(), "DataWarehouseTableGenerator", "unable to determine any tables");
    }
  }

  /**
   * Initialize application parameters from properties file and event logging
   */
  private void propertiesInit(String pPropertyFile)
  {
    // Initialize Application Settings
    try
    {
      // load the applicationproperties from the initialisation file
      URL url = getClass().getClassLoader().getResource(pPropertyFile);
      if (url == null) throw new Exception("Unknown property file: " + pPropertyFile);
      ApplicationProperties.init(url);
    }
    catch(Exception e)
    {
      System.err.println(this + " propertiesInit() - Error initializing - " + e);
      System.exit(-1);
    }

    // Initialize event logging
    try
    {
      EventLogger logger = new EventLogger(Integer.parseInt(System.getProperty("EVENTLOG.LEVEL", "5")),
                                           System.getProperty("EVENTLOG.FILENAME", "datawarehousetablegenerator%g.log"),
                                           System.getProperty("EVENTLOG.CONSOLE","YES").equals("YES"));
      EventLog.setLogger(logger);
    }
    catch (Exception e)
    {
      System.err.println(this + " propertiesInit() - Error initializing event logging - " + e);
      System.exit(-1);
    }
  }

  /**
   * Open the application server modules xml file
   *
   * @throws Exception
   */
  private Node openXmlConfig(String pDataWarehouseXmlFile) throws Exception
  {
    // locate this file
    URL url = DataWarehouseHandler.class.getClassLoader().getResource(pDataWarehouseXmlFile);
    if (url == null) throw new Exception("Unknown XML file: [" + pDataWarehouseXmlFile + "]");

    // try and parse this document
    Document document = XmlUtil.parseXmlDocument(url);

    // check if the server node is specified
    NodeList moduleList = document.getElementsByTagName("module");
    if (moduleList == null) throw new IllegalArgumentException("no modules defined");

    // for the moment, we'll assume that there is only one module: the DataWarehouseHandler
    return moduleList.item(0);
  }

  /**
   * Get a table representation of the different datasources in the given datawarehousehandler
   * @param pDataWarehouseHandler
   * @return
   * @see dce.bo.meta.db.Table
   */
  @Nullable
  public List<Table> getSourceTables(DataWarehouseHandler pDataWarehouseHandler) throws Exception
  {
    try
    {
      DataWarehouseHandler.DataSet[] dataSets = pDataWarehouseHandler.getDataSets();
      if (dataSets == null) return null;

      List<Table> tableList = new ArrayList<>(dataSets.length);
      for (DataWarehouseHandler.DataSet dataSet : dataSets)
      {
        Table table = getTable(pDataWarehouseHandler.getDatabaseConnection(), dataSet.getSource());
        if (table.getColumn("DTSUPDATE") == null) throw new Exception("view <" + table.getName() + "> doesn't have a DTSUPDATE column.");

        if (pDataWarehouseHandler.getSiteId() != null)
        {
          // Add a site identifier column
          table.addColumn(pDataWarehouseHandler.createSiteIdColumn());
        }

        String[] primaryKeys = dataSet.getDestinationKeys();
        // indicate the correct primary keys on the table columns
        setPrimaryKeys(table, primaryKeys);

        // indicate the foreign keys on the table columns
        setForeignKeys(table);

        // add the table to the tablelist
        tableList.add(table);
      }

      return tableList;
    }
    catch (Exception e)
    {
      EventLog.warning(DataWarehouseTableGenerator.class.getName(), "getSourceTables", e);
      throw e;
    }
  }

  private Table getTable(AbstractDatabaseConnection pConnection, String pSource) throws Exception
  {
    try
    {
      EventLog.debug(DataWarehouseTableGenerator.class.getName(), "getTable", "[pSource=" + pSource + "]");

      // create a new meta table
      Table table = new Table();
      table.setName(pSource);

      // determine the different columns & add them to the table
      Column[] columns = pConnection.getColumns(pSource);
      if (columns == null) throw new Exception("Unable to determine columns for source <"+pSource+">");

      for (Column column : columns)
      {
        // exclude DTSUPDATE_x helper columns
        if (column.getName().toUpperCase().startsWith("DTSUPDATE_"))
        {
          continue;
        }

        table.addColumn(column);
      }

      return table;
    }
    catch (Exception e)
    {
      EventLog.warning(DataWarehouseTableGenerator.class.getName(), "getTable", e);
      throw e;
    }
  }

  /**
   * @param pTable
   * @param pPrimaryKeys
   */
  private void setPrimaryKeys(Table pTable, String[] pPrimaryKeys)
  {
    if ((pTable == null) || (pPrimaryKeys == null)) return;

    Column column;
    for (String pPrimaryKey : pPrimaryKeys)
    {
      column = pTable.getColumn(pPrimaryKey);
      column.setIsPrimaryKey(Boolean.TRUE);
    }
  }

  /**
   * Indicate the foreign key columns on the given table (by default, all numeric columns ending on 'OID' are considered a foreign key)
   * @param pTable
   */
  protected void setForeignKeys(Table pTable)
  {
    if (pTable == null) return;

    List<Column> columnList = pTable.getColumnList();
    if (columnList != null)
    {
      for (Column column : columnList)
      {
        if (column.getName().endsWith("OID") && Long.class.equals(column.getJavaClass()))
        {
          column.setIsIndex(Boolean.TRUE);
        }
      }
    }
  }

  @Nullable
  protected Map<String, String> getTableModuleMap(Node pDataWarehouseHandlerModuleNode)
  {
    // loop over all defined sets and find their module
    List<Node> setNodeList = XmlUtil.getChildNodeListByName(pDataWarehouseHandlerModuleNode, "set");
    if (setNodeList == null) return null;

    // create a lookup map with the table modules
    Map<String, String> tableModuleMap = new HashMap<>();
    for (Node setNode : setNodeList)
    {
      String tableName = XmlUtil.getAttributeByName(setNode, "destination");
      String module = XmlUtil.getAttributeByName(setNode, "module");
      tableModuleMap.put(tableName, module);
    }

    return tableModuleMap;
  }
  
  @Nullable
  protected List<Relation> getRelationList(Node pDataWarehouseHandlerModuleNode, boolean pAddSiteIdColumn)
  {
    // loop over all defined sets and find their relations
    List<Node> setNodeList = XmlUtil.getChildNodeListByName(pDataWarehouseHandlerModuleNode, "set");
    if (setNodeList == null) return null;

    List<Relation> relationList = null;
    for (Node setNode : setNodeList)
    {
      List<Node> relationNodeList = XmlUtil.getChildNodeListByName(setNode, "relation");
      if (relationNodeList == null) continue;

      String fromTableName = XmlUtil.getAttributeByName(setNode, "destination");

      for (Node relationNode : relationNodeList)
      {
        String fromColumnsString = XmlUtil.getAttributeByName(relationNode, "fromcolumns");
        String toColumnsString = XmlUtil.getAttributeByName(relationNode, "tocolumns");

        if (pAddSiteIdColumn)
        {
          fromColumnsString = DataWarehouseHandler.SITE_ID_COLUMN + "," + fromColumnsString;
          toColumnsString = DataWarehouseHandler.SITE_ID_COLUMN + "," + toColumnsString;
        }

        //noinspection ConstantConditions
        String[] fromColumns = StringUtil.getArrayFromString(fromColumnsString, false);
        //noinspection ConstantConditions
        String[] toColumns = StringUtil.getArrayFromString(toColumnsString, false);

        String toTableName = XmlUtil.getAttributeByName(relationNode, "totable");

        if (toTableName == null)
        {
          EventLog.warning(DataWarehouseTableGenerator.class.getName(), "getRelationList", "totable not set for relation on table " + fromTableName);
          continue;
        }
        if (fromColumns == null)
        {
          EventLog.warning(DataWarehouseTableGenerator.class.getName(), "getRelationList", "fromcolumns not set for relation on table " + fromTableName + " to table " + toTableName);
          continue;
        }
        if (toColumns == null)
        {
          EventLog.warning(DataWarehouseTableGenerator.class.getName(), "getRelationList", "tocolumns not set for relation on table " + fromTableName + " to table " + toTableName);
          continue;
        }

        //noinspection ConstantConditions
        Relation relation = new Relation(fromTableName, fromColumns, toTableName, toColumns);

        if (relationList == null) relationList = new LinkedList<>();
        relationList.add(relation);
      }
    }

    return relationList;
  }

  /**
   * Generate creation script for the given tables and the database specified by the given connection
   */
  private void generateCreateTablesScript(String pFilePath, List<Table> pTableList, AbstractDatabaseGenerator pDatabaseGenerator)
  {
    PrintStream printStream = null;
    try
    {
      // create an outputstream for the creation script
      File file = new File(pFilePath);
      EventLog.debug(DataWarehouseTableGenerator.class.getName(), "generateCreateTablesScript", "generating table script '" + file.getCanonicalPath() + "'");
      printStream = new PrintStream(new FileOutputStream(file));

      // start generating the scripts for the individual tables.
      for (Table table : pTableList)
      {
        pDatabaseGenerator.generateTable(table, printStream, true);
        pDatabaseGenerator.generateIndexes(table, printStream, false);
      }
    }
    catch (Exception e)
    {
      EventLog.error(DataWarehouseTableGenerator.class.getName(), "generateCreateTablesScript", e);
    }
    finally
    {
      if (printStream != null)
      {
        try {printStream.close();}
        catch (Exception e) {}
      }
    }
  }

  /**
   * Generate creation scripts for the given relations and the database specified by the given connection
   */
  private void generateCreateRelationsScript(String pFilePath, List<Relation> pRelationList, IRelationGenerator pDatabaseGenerator)
  {
    PrintStream printStream = null;
    try
    {
      // create an outputstream for the creation script
      File file = new File(pFilePath);
      printStream = new PrintStream(new FileOutputStream(file));

      // start generating the scripts for the individual tables.
      for (Relation relation : pRelationList)
      {
        pDatabaseGenerator.generateForeignKey(relation, true, true, true, printStream);
      }
    }
    catch (Exception e)
    {
      EventLog.error(DataWarehouseTableGenerator.class.getName(), "generateCreateRelationsScript", e);
    }
    finally
    {
      if (printStream != null)
      {
        try {printStream.close();}
        catch (Exception e) {}
      }
    }
  }

  public AbstractDatabaseGenerator createDatabaseGenerator(String pDatabaseVendor) throws Exception
  {
    AbstractDatabaseGenerator databaseGenerator;

    if (Database.VENDOR_MYSQL.equals(pDatabaseVendor))
    {
      databaseGenerator = new GenDbMySql();

      String databaseName = System.getProperty("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.DATABASENAME");
      if (databaseName == null) throw new Exception("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.DATABASENAME not specified");

      databaseGenerator.putValue(GenDbMySql.DATABASE, databaseName);
    }
    else if (Database.VENDOR_ORACLE.equals(pDatabaseVendor))
    {
      databaseGenerator = new GenDbOracle();

      String dataTableSpace = System.getProperty("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.DATATABLESPACE");
      if (dataTableSpace == null) throw new Exception("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.DATATABLESPACE not specified");

      String indexTableSpace = System.getProperty("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.INDEXTABLESPACE");
      if (indexTableSpace == null) throw new Exception("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.INDEXTABLESPACE not specified");

      databaseGenerator.putValue(GenDbOracle.DATATABLESPACE, dataTableSpace);
      databaseGenerator.putValue(GenDbOracle.INDEXTABLESPACE, indexTableSpace);
    }
    else if (Database.VENDOR_SQLSERVER.equals(pDatabaseVendor))
    {
      databaseGenerator = new GenDbSqlServer();

      String databaseName = System.getProperty("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.DATABASENAME");
      if (databaseName == null) throw new Exception("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.DATABASENAME not specified");

      databaseGenerator.putValue(GenDbSqlServer.DATABASE, databaseName);
    }
    else throw new Exception("Unsupported vendor <"+pDatabaseVendor+">");

    String batchSeparator = System.getProperty("DATAWAREHOUSEHANDLER.DATAWAREHOUSE.BATCHSEPARATOR");
    if (batchSeparator != null) databaseGenerator.putValue(AbstractDatabaseGenerator.BATCHSEPARATOR, batchSeparator);

    // initialize the generator
    databaseGenerator.init();

    return databaseGenerator;
  }

  public static void main(String[] pArgs)
  {
    try
    {
      if (pArgs.length < 1)
      {
        System.err.println("Usage: DataWarehouseTableGenerator <properties file> <datawarehouse xml-file>");
        System.exit(-1);
      }

      String datawarehouseXmlFile;
      if (pArgs.length > 1)
      {
        datawarehouseXmlFile = pArgs[1];
      }
      else
      {
        datawarehouseXmlFile = "objt/app/datawarehouseserver/datawarehouse.xml";
      }


      new DataWarehouseTableGenerator(pArgs[0], datawarehouseXmlFile);
    }
    catch (Exception e)
    {
      System.err.println(e.toString());
    }
    finally
    {
      System.exit(0);
    }
  }

  protected static class Relation
  {
    protected String fromTableName;
    protected String[] fromColumns;
    protected String toTableName;
    protected String[] toColumns;

    public Relation(String pFromTableName, String[] pFromColumns, String pToTableName, String[] pToColumns)
    {
      fromTableName = pFromTableName;
      fromColumns = pFromColumns;
      toTableName = pToTableName;
      toColumns = pToColumns;
    }

    public String getFromTableName()
    {
      return fromTableName;
    }

    public String[] getFromColumns()
    {
      return fromColumns;
    }

    public String getToTableName()
    {
      return toTableName;
    }

    public String[] getToColumns()
    {
      return toColumns;
    }
  }

  protected interface IRelationGenerator
  {
    void generateForeignKey(Relation pRelation, boolean pGenerateDrop, boolean pGenerateNoValidate, boolean pGenerateDisable, PrintStream pOut);
  }

  protected static class GenDbOracle extends objt.meta.tools.db.GenDbOracle implements IRelationGenerator
  {
    @Override
    public void generateForeignKey(Relation pRelation, boolean pGenerateDrop, boolean pGenerateNoValidate, boolean pGenerateDisable, PrintStream pOut)
    {
      String foreignKeyName = "FK_" + pRelation.getFromTableName() + "_" + StringUtil.toString(pRelation.getFromColumns(), "_", false);
      foreignKeyName = generateIndexName(foreignKeyName);

      String sqlStatement;

      if (pGenerateDrop)
      {
        // add a statement to drop the key if it already exists
        sqlStatement = "BEGIN EXECUTE IMMEDIATE 'ALTER TABLE " + pRelation.getFromTableName() + " DROP CONSTRAINT " + foreignKeyName + "'; EXCEPTION WHEN OTHERS THEN NULL; END;";

        pOut.println(sqlStatement);
        pOut.println(batchSeparator);
        pOut.println();
      }

      // add a statement to create the foreign key (not checking the data which is currently in the table)
      sqlStatement = "ALTER TABLE " + pRelation.getFromTableName() + " ADD CONSTRAINT " + foreignKeyName +
                     " FOREIGN KEY (" + StringUtil.toString(pRelation.getFromColumns(), ", ", false) + ")" +
                     " REFERENCES " + pRelation.getToTableName() + "(" + StringUtil.toString(pRelation.getToColumns(), ", ", false) + ")" +
                     (pGenerateDisable ? " DISABLE" : "") + (pGenerateNoValidate ? " NOVALIDATE" : "");

      pOut.println(sqlStatement);
      pOut.println(batchSeparator);
      pOut.println();
    }
  }

  protected static class GenDbSqlServer extends objt.meta.tools.db.GenDbSqlServer implements IRelationGenerator
  {
    @Override
    public void generateForeignKey(Relation pRelation, boolean pGenerateDrop, boolean pGenerateNoValidate, boolean pGenerateDisable, PrintStream pOut)
    {
      String foreignKeyName = "FK_" + pRelation.getFromTableName() + "_" + StringUtil.toString(pRelation.getFromColumns(), "_", false);
      foreignKeyName = generateIndexName(foreignKeyName);

      String sqlStatement;

      if (pGenerateDrop)
      {
        // add a statement to drop the key if it already exists
        sqlStatement = "IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID('" + foreignKeyName + "') AND parent_object_id = OBJECT_ID(N'" + pRelation.getFromTableName() + "'))" +
                       "  ALTER TABLE " + pRelation.getFromTableName() + " DROP CONSTRAINT " + foreignKeyName;
        pOut.println(sqlStatement);
      }

      // add a statement to create the foreign key (not checking the data which is currently in the table)
      sqlStatement = "ALTER TABLE " + pRelation.getFromTableName() + (pGenerateNoValidate ? " WITH NOCHECK" : "") +
                     "  ADD CONSTRAINT " + foreignKeyName +
                     "  FOREIGN KEY(" + StringUtil.toString(pRelation.getFromColumns(), ", ", false) + ")" +
                     "  REFERENCES " + pRelation.getToTableName() + "(" + StringUtil.toString(pRelation.getToColumns(), ", ", false) + ")";
      pOut.println(sqlStatement);

      if (pGenerateDisable)
      {
        // add a statement to disable the forein key
        sqlStatement = "ALTER TABLE " + pRelation.getFromTableName() + " NOCHECK CONSTRAINT " + foreignKeyName;
        pOut.println(sqlStatement);
      }

      pOut.println();
    }
  }
}