using System.Data;
using System.Collections;
using Microsoft.VisualBasic;
using System.Diagnostics;
using System;
using System.IO;
using System.Xml;
using System.Reflection;
using System.Data.SqlClient;



namespace BizLogix.SQL
{
	internal class SQLHelper_Connection
	{
		
		#region Class Level Variables & Constructor
		
		  private string  csConnectionString = "";
		
		  // ---
		  // SQLHelper_Connection
		  //
		  // paramaters
		  //   param name="psConnectionString"  connection information
		  //   param name="piTimeOut"           denotes the timeout for a connection
		  // ---
		  internal SQLHelper_Connection(string psConnectionString, int piTimeOut)
		  {
			  csConnectionString = psConnectionString.Trim();

			  if (csConnectionString.ToUpper().IndexOf("CONNECT TIMEOUT") == -1)
			  {
				  if (piTimeOut == 0)
				  {
					  if (csConnectionString.Substring((psConnectionString.Length - 1), 1) != ";")
					  {
						  csConnectionString = csConnectionString + "; Connect Timeout=60";
					  }
					  else
					  {
						  csConnectionString = csConnectionString + " Connect Timeout=60";
					  }
				  }
				  else if (csConnectionString.Substring((psConnectionString.Length - 1), 1) != ";")
				  {
					  csConnectionString = csConnectionString + "; Connect Timeout=" + piTimeOut.ToString().Trim();
				  }
				  else
				  {
					  csConnectionString = csConnectionString + " Connect Timeout=" + piTimeOut.ToString().Trim();
				  }
			  }
		  }
		
		#endregion
		
		#region ExecuteOpenConnection
		
		  // ---
		  // ExecuteOpenConnection
		  //
		  // parameters
		  //   param name="poSqlConnection"  an unitialized sql connection object (output)
		  // ---
		  internal void ExecuteOpenConnection(ref SqlConnection poSqlConnection)
		  {
			  try
			  {
				  poSqlConnection = new SqlConnection(this.csConnectionString);
				  poSqlConnection.Open();
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
