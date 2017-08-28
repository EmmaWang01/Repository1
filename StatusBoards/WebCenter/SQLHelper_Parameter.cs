using System.Data;
using System.Collections;
using Microsoft.VisualBasic;
using System.Diagnostics;
using System;
using System.Data.SqlClient;



namespace BizLogix.SQL
{
	public class SQLHelper_Parameter
	{
		
		#region Private Class Declarations
		
		  private string                          ssActionProcess;
		  private string                          ssParmeterName;
		  private System.Data.SqlDbType           soParmeterSqlDBType;
		  private System.Data.ParameterDirection  soParmeterDirection;
		  private int                             siParmeterSize;
		  private object                          soParmeterValue;
		
		#endregion
		
		#region Constructor
		
		  public SQLHelper_Parameter()
		  {
  			
		  }
		
		#endregion
		
		#region Public Class Properties
		
		  public string ACTION_PROCESS
		  {
			  get
			  {
				  return (ssActionProcess);
			  }
  			
			  set
			  {
				  ssActionProcess = value;
			  }
		  }
  		
		  public string PARAMETER_NAME
		  {
			  get
			  {
				  return (ssParmeterName);
			  }
  			
			  set
			  {
				  ssParmeterName = value;
			  }
		  }
  		
		  public System.Data.SqlDbType PARAMETER_DBTYPE
		  {
			  get
			  {
				  return (soParmeterSqlDBType);
			  }
  			
			  set
			  {
				  soParmeterSqlDBType = value;
			  }
		  }
  		
		  public System.Data.ParameterDirection PARAMETER_DIRECTION
		  {
			  get
			  {
				  return (soParmeterDirection);
			  }
  			
			  set
			  {
				  soParmeterDirection = value;
			  }
		  }
  		
		  public int PARAMETER_SIZE
		  {
			  get
			  {
				  return (siParmeterSize);
			  }
  			
			  set
			  {
				  siParmeterSize = value;
			  }
		  }
  		
		  public object PARAMETER_VALUE
		  {
			  get
			  {
					return (soParmeterValue);
			  }
  			
			  set
			  {
					soParmeterValue = value;
			  }
		  }
		
		#endregion
		
	}
}
