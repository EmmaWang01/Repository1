//using System.Data;
using System.Collections;
using Microsoft.VisualBasic;
//using System.Diagnostics;
//using System;
//using System.Data.SqlClient;


using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
//using FullScreenMode;
using System.Runtime.InteropServices;
using System.Security;
using System.Threading;
using System.Diagnostics;
//using Growl.Connector;







namespace BizLogix.SQL
{
	public class SQLHelper
	{
		
		
		#region Private Class Level Variables
		
	    private string          csUserID = "";
	    private int             ciTimeOut = 60;
  		
	    //private SqlTransaction  coSqlTransaction;
		
		#endregion
		
		#region Constructor(s)
		
		  // ---
		  // SQLHelper  (standard constructor)
		  // ---
		  public SQLHelper()
		  {
			  this.ciTimeOut = 60;
		  }
  		
		  // ---
		  // SQLHelper
		  //
		  // parameters
		  //   param name="piTimeOut"  command timeout
		  // ---
		  public SQLHelper(int piTimeOut)
		  {
			  this.ciTimeOut = piTimeOut;
		  }
  		
		  // ---
		  // SQLHelper
		  //
		  // parameters
		  //   param name="psUserID"   user-id of a person accessing this class
		  // ---
		  public SQLHelper(string psUserID)
		  {
			  this.csUserID = psUserID;
			  this.ciTimeOut = 60;
		  }
  		
		  // ---
		  // SQLHelper
		  //
		  // parameters
		  //   param name="psUserID"   user-id of a person accessing this class
		  //   param name="piTimeOut"  command timeout
		  // ---
		  public SQLHelper(string psUserID, int piTimeOut)
		  {
			  this.csUserID = psUserID;
			  this.ciTimeOut = piTimeOut;
		  }
		  
		#endregion
		
		#region ExecuteDataReader
		
		  // ---
		  // ExecuteDataReader
		  //   provides the ability to query a SQL-Server database using "inline" sql code or a stored procedure without parameters
		  //
		  // parameters
		  //   param name="psConnectionString"  connection string (type=input)
		  //   param name="psQuery"             inline sql code or stored-procedure-name w/o input parameters (type=input)
		  //
		  // return
		  //   datareader from the query
		  // ---
		  public SqlDataReader ExecuteDataReader(string psConnectionString, string psQuery)
		  {
			  SqlDataReader  loSqlDataReader = null;
			  SqlConnection  loSqlConnection = null;
			  SqlCommand     loSqlCommand = null;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandType = CommandType.Text;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  loSqlDataReader = loSqlCommand.ExecuteReader(CommandBehavior.CloseConnection);
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
			  }
  			
			  return (loSqlDataReader);
		  }
  		
		  //---
		  // ExecuteDataReader
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //
		  // parameters
		  //   param name="psConnectionString"        connection string (type=input)
		  //   param name="psQuery"                   stored-procedure-name w/o input parameters (type=input)
		  //   param name="poParameterStructures"   an ArrayList of parameter structures (SQLHelper_Parameter)
		  //
		  // return
		  //   datareader from the query
		  // ---
		  public SqlDataReader ExecuteDataReader(string psConnectionString, string psQuery, ref ArrayList poParameterStructures)
		  {
			  //DataSet              loDataSet = null;
			  SqlDataReader        loSqlDataReader = null;
			  SqlConnection        loSqlConnection = null;
			  SqlParameter         loSqlParameter;
			  SqlCommand           loSqlCommand = null;
			  SQLHelper_Parameter  loSQLHelperParameter;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  // ---
				  // check for parameterized inline SQL or stored-procedure
				  // ---
				  if ((psQuery.IndexOf("@") > - 1) || (psQuery.ToUpper().IndexOf("SELECT ") > - 1))
					  {
					  loSqlCommand.CommandType = CommandType.Text;
				  }
				  else
				  {
					  loSqlCommand.CommandType = CommandType.StoredProcedure;
				  }
  				
				  // ---
				  // create parameters for stored-procedure
				  // ---
				  if (poParameterStructures != null)
				  {
					  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
					  {
						  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
						  loSqlParameter = new SqlParameter(loSQLHelperParameter.PARAMETER_NAME, loSQLHelperParameter.PARAMETER_DBTYPE);
  						
						  loSqlParameter.Direction = loSQLHelperParameter.PARAMETER_DIRECTION;
  						
						  switch (loSqlParameter.Direction)
						  {
							  case System.Data.ParameterDirection.Input:
							  case ParameterDirection.InputOutput:
								  loSqlParameter.Value = loSQLHelperParameter.PARAMETER_VALUE;
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
  								
							  case System.Data.ParameterDirection.Output:
							  case ParameterDirection.ReturnValue:
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
						  }
  						
						  loSqlCommand.Parameters.Add(loSqlParameter);
					  }
				  }
  				
				  // ---
				  // execute query
				  // ---
				  loSqlDataReader = loSqlCommand.ExecuteReader(CommandBehavior.CloseConnection);
  				
				  //---
				  //update any parameter structure values from output parameters
				  //---
				  foreach (SqlParameter tempLoopVar_loSqlParameter in loSqlCommand.Parameters)
				  {
					  loSqlParameter = tempLoopVar_loSqlParameter;
					  if ((loSqlParameter.Direction == System.Data.ParameterDirection.InputOutput) || (loSqlParameter.Direction == System.Data.ParameterDirection.Output) || (loSqlParameter.Direction == System.Data.ParameterDirection.ReturnValue))
						  {
						  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
						  {
							  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
							  if (loSQLHelperParameter.PARAMETER_NAME.Trim() == loSqlParameter.ParameterName.Trim())
							  {
								  loSQLHelperParameter.PARAMETER_VALUE = loSqlParameter.Value.ToString().Trim();
							  }
						  }
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
			  }
  			
			  return (loSqlDataReader);
		  }
		
		#endregion
		
		#region ExecuteDataSet
		
		  // ---
		  // ExecuteDataSet
		  //   provides the ability to query a SQL-Server database using "inline" sql code or a stored procedure without parameters
		  //
		  // parameters
		  //   param name="psConnectionString"  connection string (type=input)
		  //   param name="psQuery"             inline sql code or stored-procedure-name w/o input parameters (type=input)
		  //
		  // return
		  //   dataset from the query
		  // ---
		  public DataSet ExecuteDataSet(string psConnectionString, string psQuery)
		  {
			  DataSet         loDataSet = null;
			  SqlConnection   loSqlConnection = null;
			  SqlCommand      loSqlCommand = null;
			  SqlDataAdapter  loSqlDataAdapter = null;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandType = CommandType.Text;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  loSqlDataAdapter = new SqlDataAdapter();
				  loSqlDataAdapter.SelectCommand = loSqlCommand;
				  loDataSet = new DataSet();
  				
				  loSqlDataAdapter.Fill(loDataSet, "DATA");
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  // ---
			  // return the dataset
			  // ---
			  return (loDataSet);
		  }
  		
		  //---
		  // ExecuteDataSet
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //---
		  // ExecuteDataSet
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //
		  // parameters
		  //   param name="psConnectionString"        connection string (type=input)
		  //   param name="psQuery"                   stored-procedure-name w/o input parameters (type=input)
		  //   param name="poParameterStructures"  a ArrayList of parameter structures (SQLHelper_Parameter)
		  //
		  // return
		  //   dataset from the query
		  // ---
		  public DataSet ExecuteDataSet(string psConnectionString, string psQuery, ref ArrayList poParameterStructures)
		  {
			  DataSet              loDataSet = null;
			  SqlConnection        loSqlConnection = null;
			  SqlParameter         loSqlParameter;
			  SqlCommand           loSqlCommand = null;
			  SqlDataAdapter       loSqlDataAdapter = null;
			  SQLHelper_Parameter  loSQLHelperParameter;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  // ---
				  // check for parameterized inline SQL or stored-procedure
				  // ---
				  if ((psQuery.IndexOf("@") > - 1) || (psQuery.ToUpper().IndexOf("SELECT ") > - 1))
					  {
					  loSqlCommand.CommandType = CommandType.Text;
				  }
				  else
				  {
					  loSqlCommand.CommandType = CommandType.StoredProcedure;
				  }
  				
				  // ---
				  // create parameters for stored-procedure
				  // ---
				  if (poParameterStructures != null)
				  {
					  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
					  {
						  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
						  loSqlParameter = new SqlParameter(loSQLHelperParameter.PARAMETER_NAME, loSQLHelperParameter.PARAMETER_DBTYPE);
  						
						  loSqlParameter.Direction = loSQLHelperParameter.PARAMETER_DIRECTION;
  						
						  switch (loSqlParameter.Direction)
						  {
							  case System.Data.ParameterDirection.Input:
							  case ParameterDirection.InputOutput:
								  loSqlParameter.Value = loSQLHelperParameter.PARAMETER_VALUE;
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
  								
							  case System.Data.ParameterDirection.Output:
							  case ParameterDirection.ReturnValue:
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
						  }
  						
						  loSqlCommand.Parameters.Add(loSqlParameter);
					  }
				  }
  				
				  // ---
				  // execute query
				  // ---
				  loSqlDataAdapter = new SqlDataAdapter();
				  loSqlDataAdapter.SelectCommand = loSqlCommand;
				  loDataSet = new DataSet();
				  loSqlDataAdapter.Fill(loDataSet, "DATA");
  				
				  //---
				  //update any parameter structure values from output parameters
				  //---
				  foreach (SqlParameter tempLoopVar_loSqlParameter in loSqlCommand.Parameters)
				  {
					  loSqlParameter = tempLoopVar_loSqlParameter;
					  if ((loSqlParameter.Direction == System.Data.ParameterDirection.InputOutput) || (loSqlParameter.Direction == System.Data.ParameterDirection.Output) || (loSqlParameter.Direction == System.Data.ParameterDirection.ReturnValue))
						  {
						  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
						  {
							  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
							  if (loSQLHelperParameter.PARAMETER_NAME.Trim() == loSqlParameter.ParameterName.Trim())
							  {
								  loSQLHelperParameter.PARAMETER_VALUE = loSqlParameter.Value.ToString().Trim();
							  }
						  }
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  return (loDataSet);
		  }
		
		#endregion
		
		#region ExecuteXml
		
		  // ---
		  // ExecuteXML
		  //   provides the ability to query a SQL-Server database using "inline" sql code or a stored procedure without parameters
		  //---
		  // parameters
		  //   param name="psConnectionString"  connection string (type=input)
		  //   param name="psQuery"             inline sql code or stored-procedure-name w/ or w/o input parameters (type=input)
		  //
		  // return
		  //   xml object
		  // ---
		  public object ExecuteXml(string psConnectionString, string psQuery)
		  {
			  object          loXMLObject = "";
			  DataSet         loDataSet = null;
			  SqlConnection   loSqlConnection = null;
			  SqlCommand      loSqlCommand = null;
			  SqlDataAdapter  loSqlDataAdapter = null;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandType = CommandType.Text;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  loSqlDataAdapter = new SqlDataAdapter();
				  loSqlDataAdapter.SelectCommand = loSqlCommand;
				  loDataSet = new DataSet();
  				
				  loSqlDataAdapter.Fill(loDataSet, "DATA");
				  loXMLObject = loDataSet.GetXml();
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  // ---
			  // return the xml object
			  // ---
			  return (loXMLObject);
		  }
  		
		  //---
		  // ExecuteXml
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //---
		  // ExecuteDataSet
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //
		  // parameters
		  //   param name="psConnectionString"        connection string (type=input)
		  //   param name="psQuery"                   stored-procedure-name w/o input parameters (type=input)
		  //   param name="poParameterStructures"  a ArrayList of parameter structures (SQLHelper_Parameter)
		  //
		  // return
		  //   xml object from the query
		  // ---
		  public object ExecuteXml(string psConnectionString, string psQuery, ref ArrayList poParameterStructures)
		  {
			  object               loXMLObject = "";
			  DataSet              loDataSet = null;
			  SqlConnection        loSqlConnection = null;
			  SqlParameter         loSqlParameter;
			  SqlCommand           loSqlCommand = null;
			  SqlDataAdapter       loSqlDataAdapter = null;
			  SQLHelper_Parameter  loSQLHelperParameter;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  // ---
				  // check for parameterized inline SQL or stored-procedure
				  // ---
				  if ((psQuery.IndexOf("@") > - 1) || (psQuery.ToUpper().IndexOf("SELECT ") > - 1))
					  {
					  loSqlCommand.CommandType = CommandType.Text;
				  }
				  else
				  {
					  loSqlCommand.CommandType = CommandType.StoredProcedure;
				  }
  				
				  // ---
				  // create parameters for stored-procedure
				  // ---
				  if (poParameterStructures != null)
				  {
					  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
					  {
						  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
						  loSqlParameter = new SqlParameter(loSQLHelperParameter.PARAMETER_NAME, loSQLHelperParameter.PARAMETER_DBTYPE);
  						
						  loSqlParameter.Direction = loSQLHelperParameter.PARAMETER_DIRECTION;
  						
						  switch (loSqlParameter.Direction)
						  {
							  case System.Data.ParameterDirection.Input:
							  case ParameterDirection.InputOutput:
								  loSqlParameter.Value = loSQLHelperParameter.PARAMETER_VALUE;
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
  								
							  case System.Data.ParameterDirection.Output:
							  case ParameterDirection.ReturnValue:
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
						  }
  						
						  loSqlCommand.Parameters.Add(loSqlParameter);
					  }
				  }
  				
				  // ---
				  // execute query
				  // ---
				  loSqlDataAdapter = new SqlDataAdapter();
				  loSqlDataAdapter.SelectCommand = loSqlCommand;
				  loDataSet = new DataSet();
				  loSqlDataAdapter.Fill(loDataSet, "DATA");
  				
				  loXMLObject = loDataSet.GetXml();
  				
				  //---
				  //update any parameter structure values from output parameters
				  //---
				  foreach (SqlParameter tempLoopVar_loSqlParameter in loSqlCommand.Parameters)
				  {
					  loSqlParameter = tempLoopVar_loSqlParameter;
					  if ((loSqlParameter.Direction == ParameterDirection.InputOutput) || (loSqlParameter.Direction == System.Data.ParameterDirection.Output) || (loSqlParameter.Direction == System.Data.ParameterDirection.ReturnValue))
						  {
						  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
						  {
							  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
							  if (loSQLHelperParameter.PARAMETER_NAME.Trim() == loSqlParameter.ParameterName.Trim())
							  {
								  loSQLHelperParameter.PARAMETER_VALUE = loSqlParameter.Value.ToString().Trim();
							  }
						  }
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  return (loXMLObject);
		  }
		
		#endregion
		
		#region ExecuteScalar
		
		  // ---
		  // ExecuteScalar
		  //   provides the ability to query a SQL-Server database using "inline" sql code or a stored procedure without parameters
		  //---
		  // parameters
		  //   param name="psConnectionString"  connection string (type=input)
		  //   param name="psQuery"             inline sql code or stored-procedure-name w/ or w/o input parameters (type=input)
		  //
		  // return
		  //   scalar object
		  // ---
		  public object ExecuteScalar(string psConnectionString, string psQuery)
		  {
			  object         loScalarObject = "";
			  SqlConnection  loSqlConnection = null;
			  SqlCommand     loSqlCommand = null;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandType = CommandType.Text;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  loScalarObject = loSqlCommand.ExecuteScalar();
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  // ---
			  // return the xml object
			  // ---
			  return (loScalarObject);
		  }
  		
		  //---
		  // ExecuteScalar
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //---
		  // ExecuteDataSet
		  //   provides the ability to query a SQL-Server database using a stored procedure with parameters
		  //
		  // parameters
		  //   param name="psConnectionString"        connection string (type=input)
		  //   param name="psQuery"                   stored-procedure-name w/o input parameters (type=input)
		  //   param name="poParameterStructures"  a ArrayList of parameter structures (SQLHelper_Parameter)
		  //
		  // return
		  //   scalar object
		  // ---
		  public object ExecuteScalar(string psConnectionString, string psQuery, ref ArrayList poParameterStructures)
		  {
			  object               loScalarObject = "";
			  //DataSet              loDataSet = null;
			  SqlConnection        loSqlConnection = null;
			  SqlParameter         loSqlParameter;
			  SqlCommand           loSqlCommand = null;
			  //SqlDataAdapter       loSqlDataAdapter = null;
			  SQLHelper_Parameter  loSQLHelperParameter;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psQuery, loSqlConnection);
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  // ---
				  // check for parameterized inline SQL or stored-procedure
				  // ---
				  if ((psQuery.IndexOf("@") > - 1) || (psQuery.ToUpper().IndexOf("SELECT ") > - 1))
					  {
					  loSqlCommand.CommandType = CommandType.Text;
				  }
				  else
				  {
					  loSqlCommand.CommandType = CommandType.StoredProcedure;
				  }
  				
  				
				  // ---
				  // create parameters for stored-procedure
				  // ---
				  if (poParameterStructures != null)
				  {
					  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
					  {
						  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
						  loSqlParameter = new SqlParameter(loSQLHelperParameter.PARAMETER_NAME, loSQLHelperParameter.PARAMETER_DBTYPE);
  						
						  loSqlParameter.Direction = loSQLHelperParameter.PARAMETER_DIRECTION;
  						
						  switch (loSqlParameter.Direction)
						  {
							  case System.Data.ParameterDirection.Input:
							  case ParameterDirection.InputOutput:
								  loSqlParameter.Value = loSQLHelperParameter.PARAMETER_VALUE;
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
  								
							  case System.Data.ParameterDirection.Output:
							  case ParameterDirection.ReturnValue:
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
						  }
  						
						  loSqlCommand.Parameters.Add(loSqlParameter);
					  }
				  }
  				
				  // ---
				  // execute query
				  // ---
				  loScalarObject = loSqlCommand.ExecuteScalar();
  				
				  //---
				  //update any parameter structure values from output parameters
				  //---
				  foreach (SqlParameter tempLoopVar_loSqlParameter in loSqlCommand.Parameters)
				  {
					  loSqlParameter = tempLoopVar_loSqlParameter;
					  if ((loSqlParameter.Direction == System.Data.ParameterDirection.InputOutput) || (loSqlParameter.Direction == System.Data.ParameterDirection.Output) || (loSqlParameter.Direction == System.Data.ParameterDirection.ReturnValue))
						  {
						  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
						  {
							  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
							  if (loSQLHelperParameter.PARAMETER_NAME.Trim() == loSqlParameter.ParameterName.Trim())
							  {
								  loSQLHelperParameter.PARAMETER_VALUE = loSqlParameter.Value.ToString().Trim();
							  }
						  }
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  return (loScalarObject);
		  }
		
		#endregion
		
		#region ExecuteNonQuery
		
		  // ---
		  // ExecuteNonQuery
		  //   provides the ability to update a SQL-Server database using "inline" sql code or a stored procedure without parameters
		  // ---
		  // parameters
		  //   param name="psConnectionString"  connection string (type=input)
		  //   param name="psQuery"             inline sql code or stored-procedure-name w/ or w/o input parameters (type=input)
		  //
		  // return
		  //   records affected
		  // ---
		  public int ExecuteNonQuery(string psConnectionString, string psAction)
		  {
			  int            liRecordsAffected = 0;
			  SqlConnection  loSqlConnection = null;
			  SqlCommand     loSqlCommand = null;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psAction, loSqlConnection);
				  loSqlCommand.CommandType = CommandType.Text;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  liRecordsAffected = loSqlCommand.ExecuteNonQuery();
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  // ---
			  // return number of records affected
			  // ---
			  return (liRecordsAffected);
		  }
  		
		  //---
		  // ExecuteNonQuery
		  //   provides the ability to update a SQL-Server database using a stored procedure with parameters
		  //---
		  // parameters
		  //   param name="psConnectionString"         connection string (type=input)
		  //   param name="psAction"                   stored-procedure-name w/o input parameters (type=input)
		  //   param name="poParameterStructures"    a ArrayList of parameter structures (SQLHelper_Parameter)
		  //
		  // return
		  //   records affected
		  // ---
		  public int ExecuteNonQuery(string psConnectionString, string psAction, ref ArrayList poParameterStructures)
		  {
			  int                  liRecordsAffected = 0;
			  SqlConnection        loSqlConnection = null;
			  SqlCommand           loSqlCommand = null;
			  SqlParameter         loSqlParameter;
			  SQLHelper_Parameter  loSQLHelperParameter;
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlCommand = new SqlCommand(psAction, loSqlConnection);
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  // ---
				  // check for parameterized inline SQL or stored-procedure
				  // ---
				  if ((psAction.IndexOf("@") > - 1) || (psAction.ToUpper().IndexOf("INSERT ") > - 1) || (psAction.ToUpper().IndexOf("UPDATE ") > - 1) || (psAction.ToUpper().IndexOf("DELETE ") > - 1))
					  {
					  loSqlCommand.CommandType = CommandType.Text;
				  }
				  else
				  {
					  loSqlCommand.CommandType = CommandType.StoredProcedure;
				  }
  				
  				
				  // ---
				  // create parameters for stored-procedure
				  // ---
				  if (poParameterStructures != null)
				  {
					  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
					  {
						  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
						  loSqlParameter = new SqlParameter(loSQLHelperParameter.PARAMETER_NAME, loSQLHelperParameter.PARAMETER_DBTYPE);
  						
						  loSqlParameter.Direction = loSQLHelperParameter.PARAMETER_DIRECTION;
  						
						  switch (loSqlParameter.Direction)
						  {
							  case System.Data.ParameterDirection.Input:
							  case ParameterDirection.InputOutput:
								  loSqlParameter.Value = loSQLHelperParameter.PARAMETER_VALUE;
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
  								
							  case System.Data.ParameterDirection.Output:
							  case ParameterDirection.ReturnValue:
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
						  }
  						
						  loSqlCommand.Parameters.Add(loSqlParameter);
					  }
				  }
  				
				  // ---
				  // execute action
				  // ---
				  liRecordsAffected = loSqlCommand.ExecuteNonQuery();
  				
				  //---
				  //update any parameter structure values from output parameters
				  //---
				  foreach (SqlParameter tempLoopVar_loSqlParameter in loSqlCommand.Parameters)
				  {
					  loSqlParameter = tempLoopVar_loSqlParameter;
					  if ((loSqlParameter.Direction == System.Data.ParameterDirection.InputOutput) || (loSqlParameter.Direction == System.Data.ParameterDirection.Output) || (loSqlParameter.Direction == System.Data.ParameterDirection.ReturnValue))
						  {
						  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
						  {
							  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
							  if (loSQLHelperParameter.PARAMETER_NAME.Trim() == loSqlParameter.ParameterName.Trim())
							  {
								  loSQLHelperParameter.PARAMETER_VALUE = loSqlParameter.Value.ToString().Trim();
							  }
						  }
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
  			
			  // ---
			  // return number of records affected
			  // ---
			  return (liRecordsAffected);
		  }
  		
		  // ---
		  // ExecuteNonQuery
		  //   provides the ability to update a SQL-Server database using "inline" sql code or a stored procedure within a transaction
		  //   but w/o parameters  (single point)
		  // ---
		  // parameters
		  //   param name="poSqlConnection"     sql connection object passed from multi-action update process
		  //   param name="poSqlTransaction"    the transaction for which this call is part of
		  //   param name="psAction"            inline sql code or stored-procedure-name w/ or w/o input parameters (type=input)
		  //
		  // return
		  //   records affected
		  // ---
		  public int ExecuteNonQuery(SqlConnection poSqlConnection, SqlTransaction poSqlTransaction, string psAction)
		  {
			  int         liRecordsAffected = 0;
			  SqlCommand  loSqlCommand = null;
  			
  			
			  try
			  {
				  loSqlCommand = new SqlCommand(psAction, poSqlConnection);
				  loSqlCommand.Transaction = poSqlTransaction;
				  loSqlCommand.CommandType = CommandType.Text;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  liRecordsAffected = loSqlCommand.ExecuteNonQuery();
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
			  }
  			
			  // ---
			  // return number of records affected
			  // ---
			  return (liRecordsAffected);
		  }
  		
		  //---
		  // ExecuteNonQuery
		  //   provides the ability to update a SQL-Server database using "inline" sql code or a stored procedure within a transaction
		  //   but w/ parameters (single point)
		  //---
		  // parameters
		  //   param name="poSqlConnection"          sql connection object passed from multi-action update process
		  //   param name="poSqlTransaction"         the transaction for which this call is part of
		  //   param name="psAction"                 stored-procedure-name w/o input parameters (type=input)
		  //   param name="poParameterStructures"  a ArrayList of parameter structures (SQLHelper_Parameter)
		  //
		  // return
		  //   records affected
		  // ---
		  public int ExecuteNonQuery(SqlConnection poSqlConnection, SqlTransaction poSqlTransaction, string psAction, ref ArrayList poParameterStructures)
		  {
			  int                  liRecordsAffected = 0;
			  SqlCommand           loSqlCommand = null;
			  SqlParameter         loSqlParameter;
			  SQLHelper_Parameter  loSQLHelperParameter;
  			
  			
			  try
			  {
				  loSqlCommand = new SqlCommand(psAction, poSqlConnection);
				  loSqlCommand.Transaction = poSqlTransaction;
				  loSqlCommand.CommandTimeout = ciTimeOut;
  				
				  // ---
				  // check for parameterized inline SQL or stored-procedure
				  // ---
				  if ((psAction.IndexOf("@") > - 1) || (psAction.ToUpper().IndexOf("INSERT ") > - 1) || (psAction.ToUpper().IndexOf("UPDATE ") > - 1) || (psAction.ToUpper().IndexOf("DELETE ") > - 1))
					  {
					  loSqlCommand.CommandType = CommandType.Text;
				  }
				  else
				  {
					  loSqlCommand.CommandType = CommandType.StoredProcedure;
				  }
  				
				  // ---
				  // create parameters for stored-procedure
				  // ---
				  if (poParameterStructures != null)
				  {
					  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
					  {
						  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
						  loSqlParameter = new SqlParameter(loSQLHelperParameter.PARAMETER_NAME, loSQLHelperParameter.PARAMETER_DBTYPE);
  						
						  loSqlParameter.Direction = loSQLHelperParameter.PARAMETER_DIRECTION;
  						
						  switch (loSqlParameter.Direction)
						  {
							  case System.Data.ParameterDirection.Input:
							  case ParameterDirection.InputOutput:
								  loSqlParameter.Value = loSQLHelperParameter.PARAMETER_VALUE;
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
  								
							  case ParameterDirection.Output:
							  case ParameterDirection.ReturnValue:
								  loSqlParameter.Size = loSQLHelperParameter.PARAMETER_SIZE;
								  break;
						  }
  						
						  loSqlCommand.Parameters.Add(loSqlParameter);
					  }
				  }
  				
				  // ---
				  // execute action
				  // ---
				  liRecordsAffected = loSqlCommand.ExecuteNonQuery();
  				
				  //---
				  //update any parameter structure values from output parameters
				  //---
				  foreach (SqlParameter tempLoopVar_loSqlParameter in loSqlCommand.Parameters)
				  {
					  loSqlParameter = tempLoopVar_loSqlParameter;
					  if ((loSqlParameter.Direction == System.Data.ParameterDirection.InputOutput) || (loSqlParameter.Direction == System.Data.ParameterDirection.Output) || (loSqlParameter.Direction == System.Data.ParameterDirection.ReturnValue))
						  {
						  foreach (SQLHelper_Parameter tempLoopVar_loSQLHelperParameter in poParameterStructures)
						  {
							  loSQLHelperParameter = tempLoopVar_loSQLHelperParameter;
							  if (loSQLHelperParameter.PARAMETER_NAME.Trim() == loSqlParameter.ParameterName.Trim())
							  {
								  loSQLHelperParameter.PARAMETER_VALUE = loSqlParameter.Value.ToString().Trim();
							  }
						  }
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
			  finally
			  {
				  loSqlCommand.Dispose();
			  }
  			
			  // ---
			  // return number of records affected
			  // ---
			  return (liRecordsAffected);
		  }
		
		#endregion
		
		#region ExecuteMultiActionUpdate
		
		  //---
		  // ExecuteMultiActionUpdate
		  //   provides the ability to update a SQL-Server database using multiple inline sql statements and\or stored procedures with parameters
		  //   with an "internal" transaction to cover all submitted actions
		  //---
		  // parameters
		  //   param name="psConnectionString"        connection string (type=input)
		  //   param name="poSQLActions"              contains multiple inline sql statements and\or stored procedures with parameters
		  //
		  // return
		  //   records affected
		  // ---
		  public void ExecuteMultiActionUpdate(string psConnectionString, ref ArrayList poSQLActions)
		  {
			  int             liRecordsAffected = 0;
			  bool            lboolTransactionError = false;
			  ArrayList       loSqlParameters = new ArrayList();
			  SqlConnection   loSqlConnection = null;
			  SqlTransaction  loSqlTransaction = null;
  			
  			
  			
			  try
			  {
				  GetDBConnection(psConnectionString, ref loSqlConnection);
  				
				  loSqlTransaction = loSqlConnection.BeginTransaction();
  				
				  foreach (SQLHelper_Action loSQLHelper_Action in poSQLActions)
				  {
					  if ((loSQLHelper_Action.SQL_ACTION.IndexOf("@") > - 1) || (loSQLHelper_Action.SQL_ACTION.ToUpper().IndexOf("INSERT ") > - 1) || (loSQLHelper_Action.SQL_ACTION.ToUpper().IndexOf("UPDATE ") > - 1) || (loSQLHelper_Action.SQL_ACTION.ToUpper().IndexOf("DELETE ") > - 1))
						  {
						  if (loSQLHelper_Action.SQL_PARAMETERS.Count == 0)
						  {
							  liRecordsAffected = ExecuteNonQuery(loSqlConnection, loSqlTransaction, loSQLHelper_Action.SQL_ACTION);
							  loSQLHelper_Action.RECORDS_AFFECTED = liRecordsAffected;
						  }
						  else
						  {
                loSqlParameters = loSQLHelper_Action.SQL_PARAMETERS;
							  liRecordsAffected = ExecuteNonQuery(loSqlConnection, loSqlTransaction, loSQLHelper_Action.SQL_ACTION, ref loSqlParameters);
  							
                loSQLHelper_Action.SQL_PARAMETERS = loSqlParameters;
							  loSQLHelper_Action.RECORDS_AFFECTED = liRecordsAffected;
						  }
					  }
					  else
					  {
              loSqlParameters = loSQLHelper_Action.SQL_PARAMETERS;
              liRecordsAffected = ExecuteNonQuery(loSqlConnection, loSqlTransaction, loSQLHelper_Action.SQL_ACTION, ref loSqlParameters);

              loSQLHelper_Action.SQL_PARAMETERS = loSqlParameters;
						  loSQLHelper_Action.RECORDS_AFFECTED = liRecordsAffected;
					  }
				  }
			  }
			  catch (SqlException loSqlException)
			  {
				  lboolTransactionError = true;
				  loSqlTransaction.Rollback();
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  lboolTransactionError = true;
				  loSqlTransaction.Rollback();
				  throw (loException);
			  }
			  finally
			  {
				  if (! lboolTransactionError)
				  {
					  loSqlTransaction.Commit();
				  }
				  loSqlConnection.Close();
				  loSqlConnection.Dispose();
			  }
		  }
		
		#endregion
		
		#region Public Single-Point Transaction Support Methods
		
		  public SqlConnection GetSqlConnectionObject(string psConnectionString)
		  {
			  SqlConnection  loSqlConnection = null;

              Debugger.Log(1, "test", "GetSqlConnectionObject");
			  GetDBConnection(psConnectionString, ref loSqlConnection);
              Debug.WriteLine("komatsu");
			  return (loSqlConnection);
		  }
  		
		  public SqlTransaction GetSqlTransactionObject(SqlConnection poSqlConnection)
		  {
			  SqlTransaction  loSqlTransaction;
  			
  			
			  loSqlTransaction = poSqlConnection.BeginTransaction();
  			
			  return (loSqlTransaction);
		  }
  		
		  public void CommitSqlTransaction(SqlTransaction poSqlTransaction)
		  {
              Debugger.Log(1, "test", "CommitSqlTransaction");
			  try
			  {
				  poSqlTransaction.Commit();
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
		  }
  		
		  public void RollbackSqlTransaction(SqlTransaction poSqlTransaction)
		  {
			  try
			  {
				  poSqlTransaction.Rollback();
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
		  }
		
		#endregion
		
		#region Public Support Methods
		
		  // ---
		  // SQL_ReplaceQuotesWithDoubleQuotes
		  //
		  // replaces single-quote with double-quotes
		  //
		  // parameters
		  //   param name="psData"   the data on which this process is to be performed
		  // ---
		  public string SQL_ReplaceQuotesWithDoubleQuotes(string psData)
		  {
  		  return (psData.Replace(Strings.Chr(39), Strings.Chr(34)));
		  }
  		
		  // ---
		  // SQL_ReplaceDoubleQuotesWithQuotes
		  //
		  // replaces double-quotes with a single-quote
		  //
		  // parameters
		  //   param name="psData"   the data on which this process is to be performed
		  // ---
		  public string SQL_ReplaceDoubleQuotesWithQuotes(string psData)
		  {
			  return (psData.Replace(Strings.Chr(34), Strings.Chr(39)));
		  }
		
		#endregion
		
		#region Private Support Methods
		
		  // ---
		  // GetDBConnection
		  //
		  // retrieves a connection to the database as provided by the "SQLHelper_Connection" class
		  //
		  // parameters
		  //   param name="poSqlConnection"  a variable of type "SqlConnection" (type=output)
		  // ---
		  private void GetDBConnection(string psConnectionString, ref SqlConnection poSqlConnection)
		  {
			  SQLHelper_Connection  loSQLHelper_Connection = new SQLHelper_Connection(psConnectionString, ciTimeOut);
  			
  			
			  try
			  {
				  loSQLHelper_Connection.ExecuteOpenConnection(ref poSqlConnection);
			  }
			  catch (SqlException loSqlException)
			  {
				  throw (loSqlException);
			  }
			  catch (Exception loException)
			  {
				  throw (loException);
			  }
		  }
		
		#endregion
		
	}
	
}
