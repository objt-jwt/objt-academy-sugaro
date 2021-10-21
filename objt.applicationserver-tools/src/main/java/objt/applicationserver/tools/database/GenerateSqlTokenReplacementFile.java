/* *****************************************************************************
 * Copyright (c) 2017 Objective
 * All rights reserved
 *
 * This software is the confidential and proprietary information of Objective.
 * You shall not disclose this confidential information and shall use it only
 * in accordance with the terms of the license agreement you entered into with
 * Objective.
 * ****************************************************************************
 */

package objt.applicationserver.tools.database;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.net.URL;
import java.util.List;

import dce.bo.meta.MetaClass;
import dce.bo.meta.MetaFile;
import dce.bo.meta.Model;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class GenerateSqlTokenReplacementFile extends Task
{
  protected String classModelFile;
  protected String outputFile;

  public void setClassModelFile(String pClassModelFile)
  {
    classModelFile = pClassModelFile;
  }

  public void setOutputFile(String pOutputFile)
  {
    outputFile = pOutputFile;
  }

  @Override
  public void execute() throws BuildException
  {
    try
    {
      // Read serialized model
      String fileName = classModelFile;
      if (! fileName.startsWith("/"))
      {
        fileName = "/" + fileName;
      }

      // read the application from the given filename
      URL metaFileURL = getClass().getResource(fileName);
      if (metaFileURL == null) throw new Exception("Unable to open ClassModelFileName <" + classModelFile + ">");

      Model model = MetaFile.read(metaFileURL);

      // build a file containing all replaced model classes
      List<MetaClass> metaClassList = model.getClassifierList(MetaClass.class);
      if (metaClassList == null) return;

      BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));

      for (MetaClass metaClass : metaClassList)
      {
        writer.write("CLASSNAME(" + metaClass.getFullName() + ")='" + metaClass.getInstantiationMetaClass().getFullName() + "'\n");
        writer.write("CLASSOID(" + metaClass.getFullName() + ")=" + metaClass.getInstantiationMetaClass().getOID() + "\n");
      }

      writer.close();
    }
    catch (BuildException be)
    {
      throw be;
    }
    catch (Throwable t)
    {
      System.err.println(this + " execute() - " + t);
      throw new BuildException(t);
    }
  }
}
