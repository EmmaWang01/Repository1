using System.Data;
using System.Collections;
using Microsoft.VisualBasic;
using System.Diagnostics;
using System;

namespace BizLogix.SQL
{
	public class SQLHelper_Action
	{
		
		
		#region Private Class Declarations
		
		  private int        ciSqlActionId = 0;
		  private int        ciRecordsAffected = 0;
		  private bool       cboolToBeEdited = false;
		  private string     csSqlAction;
		  private ArrayList  coSqlParameters;
		
		#endregion
		
		#region Constructor
		
		  public SQLHelper_Action()
		  {
  			
		  }
		
		#endregion
		
		#region Public Class Properties
		
		  public int SQL_ACTION_ID
		  {
			  get
			  {
				  return (ciSqlActionId);
			  }
  			
			  set
			  {
				  ciSqlActionId = value;
			  }
		  }
  		
		  public bool TO_BE_EDITED
		  {
			  get
			  {
				  return (cboolToBeEdited);
			  }
  			
			  set
			  {
				  cboolToBeEdited = value;
			  }
		  }
  		
		  public string SQL_ACTION
		  {
			  get
			  {
				  return (csSqlAction);
			  }
  			
			  set
			  {
				  csSqlAction = value;
			  }
		  }
  		
		  public ArrayList SQL_PARAMETERS
		  {
			  get
			  {
				  return (coSqlParameters);
			  }
  			
			  set
			  {
				  coSqlParameters = value;
			  }
		  }
  		
		  public int RECORDS_AFFECTED
		  {
			  get
			  {
				  return (ciRecordsAffected);
			  }
  			
			  set
			  {
				  ciRecordsAffected = value;
			  }
		  }
		
		#endregion
		
	}
}
