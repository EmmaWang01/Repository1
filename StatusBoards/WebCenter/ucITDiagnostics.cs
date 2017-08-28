using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using BizLogix.SQL;

namespace LoanCenter
{
    public partial class ucITDiagnostics : UserControl
    {
        string myquery;
        private string sItConnectionString = @"Data source=10.66.0.192;Initial Catalog=StatusLogix;User Id=sa;Password=Madbkan3;"; // providerName="System.Data.SqlClient";


        private string _mndPath;
        public string MNDFilePath
        {
            get { return _mndPath; }
            set { _mndPath = value; }
        }
        public ucITDiagnostics()
        {
            InitializeComponent();
        }

        private void lblCloseITDiagnotics_Click(object sender, EventArgs e)
        {
            this.Visible = false;
        }

        private void btnStartMND_Click(object sender, EventArgs e)
        {
            if (_mndPath.Length > 0)
            {
                Process mnd = new Process();
                mnd.StartInfo.FileName = _mndPath;
                mnd.Start();
            }
        }



        #region IT Systems Query Defs

        public void RunITDashboard()
        {
            #region Gauges
            myquery = GetITQueryDef("APL_Users_10_66_0_2_Last");
            DataSet ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                string sResult="";
                
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[j][1]).ToString());
                    g_APLU_2.Value = Convert.ToInt16(sResult);
                    g_APLU_2.GaugeLabels[0].Text = sResult + " Users";

                    g_APLU_2.Refresh();

                    pAPLU_2.AddValue(Convert.ToDecimal(g_APLU_2.Value));
                }
            }
            catch {
                g_APLU_2.Value = 0;
                g_APLU_2.GaugeLabels[0].Text = "Error";

                g_APLU_2.Refresh();
            }


            myquery = GetITQueryDef("APL_Users_10_66_0_3_Last");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                string sResult = "";

                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[j][1]).ToString());
                    g_APLU_3.Value = Convert.ToInt16(sResult);
                    g_APLU_3.GaugeLabels[0].Text = sResult + " Users";

                    g_APLU_3.Refresh();
                }
            }
            catch
            {
                g_APLU_3.Value = 0;
                g_APLU_3.GaugeLabels[0].Text = "Error";

                g_APLU_3.Refresh();
            }

            myquery = GetITQueryDef("APL_Users_10_66_0_5_Last");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                string sResult = "";

                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[j][1]).ToString());
                    g_APLU_5.Value = Convert.ToInt16(sResult);
                    g_APLU_5.GaugeLabels[0].Text = sResult + " Users";

                    g_APLU_5.Refresh();
                }
            }
            catch
            {
                g_APLU_5.Value = 0;
                g_APLU_5.GaugeLabels[0].Text = "Error";

                g_APLU_5.Refresh();
            }


            myquery = GetITQueryDef("APL_Users_10_66_0_7_Last");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                string sResult = "";
                g_APLU_7.GaugeLabels[0].Text = "0 Users";

                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[j][1]).ToString());
                    g_APLU_7.Value = Convert.ToInt16(sResult);
                    g_APLU_7.GaugeLabels[0].Text = sResult + " Users";

                    g_APLU_7.Refresh();
                }
            }
            catch
            {
                g_APLU_7.Value = 0;
                g_APLU_7.GaugeLabels[0].Text = "Error";

                g_APLU_7.Refresh();
            }
            #endregion

            #region Performance Charts
            myquery = GetITQueryDef("APL_Users_10_66_0_2_Top50");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                string sResult = "";
                pAPLU_2.Clear();
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    //sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[0][1]).ToString());
                    //pAPLU_2.AddValue(Convert.ToInt16(sResult));
                    pAPLU_2.AddValue(Convert.ToInt16(ds.Tables[0].Rows[j][1]));
                }
            }
            catch
            {

            }
            #endregion
            pAPLU_2.Refresh();


            myquery = GetITQueryDef("APL_Users_10_66_0_3_Top50");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                string sResult = "";
                
                pAPLU_3.Clear();
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    //sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[0][1]).ToString());
                    //pAPLU_3.AddValue(Convert.ToInt16(sResult));
                    pAPLU_3.AddValue(Convert.ToInt16(ds.Tables[0].Rows[j][1]));
                }
            }
            catch
            {

            }
            pAPLU_3.Refresh();

            myquery = GetITQueryDef("APL_Users_10_66_0_5_Top50");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                pAPLU_5.Clear();
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    //sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[0][1]).ToString());
                    //pAPLU_3.AddValue(Convert.ToInt16(sResult));
                    pAPLU_5.AddValue(Convert.ToInt16(ds.Tables[0].Rows[j][1]));
                }
            }
            catch
            {

            }
            pAPLU_5.Refresh();

            myquery = GetITQueryDef("APL_Users_10_66_0_7_Top50");
            ds = ExecQuery(myquery, sItConnectionString);
            try
            {
                pAPLU_7.Clear();
                for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                {
                    //sResult = string.Format("{0:0}", Convert.ToInt16(ds.Tables[0].Rows[0][1]).ToString());
                    //pAPLU_3.AddValue(Convert.ToInt16(sResult));
                    pAPLU_7.AddValue(Convert.ToInt16(ds.Tables[0].Rows[j][1]));
                }
            }
            catch
            {

            }
            pAPLU_7.Refresh();


            #endregion
            


        }

        public enum IT_QueryDefs
        {
            APL_Users_10_66_0_2_Top50,
            APL_Users_10_66_0_2_Last,
            APL_Users_10_66_0_3_Top50,
            APL_Users_10_66_0_3_Last,
            APL_Users_10_66_0_5_Top50,
            APL_Users_10_66_0_5_Last,
            APL_Users_10_66_0_7_Top50,
            APL_Users_10_66_0_7_Last
        }


        public static string GetITQueryDef(string QueryName)
        {
            string query = "";

            switch (QueryName)
            {
                case "APL_Users_10_66_0_2_Top50":
                    query = "SELECT top 50 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.2' order by GeneratedOnUtc desc ";
                    break;
                case "APL_Users_10_66_0_2_Last":
                    query = "SELECT top 1 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.2' order by GeneratedOnUtc desc ";
                    break;

                case "APL_Users_10_66_0_3_Top50":
                    query = "SELECT top 50 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.3' order by GeneratedOnUtc desc ";
                    break;
                case "APL_Users_10_66_0_3_Last":
                    query = "SELECT top 1 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.3' order by GeneratedOnUtc desc ";
                    break;

                case "APL_Users_10_66_0_5_Top50":
                    query = "SELECT top 50 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.5' order by GeneratedOnUtc desc ";
                    break;
                case "APL_Users_10_66_0_5_Last":
                    query = "SELECT top 1 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.5' order by GeneratedOnUtc desc ";
                    break;

                case "APL_Users_10_66_0_7_Top50":
                    query = "SELECT top 50 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.7' order by GeneratedOnUtc desc ";
                    break;
                case "APL_Users_10_66_0_7_Last":
                    query = "SELECT top 1 [CheckId],[ResultCount],[generatedonutc] FROM [StatusLogix].[dbo].[AgentData] WHERE ResultCount > 0 and CheckId like 'isaplrunningon10.66.0.7' order by GeneratedOnUtc desc ";
                    break;

                default:
                    query = "NotFound";
                    break;
            }

            return query;

        }

        private DataSet ExecQuery(string lsQuery, string sMyConnectionString)
        {
            //int        liParameterCnt = 0;
            string lsConnectionString = sMyConnectionString;
            DataSet loDataSet;
            SQLHelper loSQLHelper = new SQLHelper("tester");

            lsConnectionString = sItConnectionString.Trim();

            try
            {
                return loDataSet = loSQLHelper.ExecuteDataSet(lsConnectionString, lsQuery);
            }
            catch (Exception loException)
            {
                //MessageBox.Show(loException.Message, "Application Message");
                DataSet dsEmpty = new DataSet();
                return dsEmpty;
            }

        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            RunITDashboard();
        }

        private void chkAutoRefresh_CheckedChanged(object sender, EventArgs e)
        {
            timer1.Enabled = chkAutoRefresh.Checked;
        }

        int countDown = 30;
        private void timer1_Tick(object sender, EventArgs e)
        {
            if (countDown > 0)
            {
                countDown -= 1;
                lblCountDown.Text = "(" + countDown.ToString() + " secs)";
            }
            else
            {
                countDown = 30;
                RunITDashboard();
                lblCountDown.Text = "(" + countDown.ToString() + " secs)";
            }
        }

        private void panel2_Paint(object sender, PaintEventArgs e)
        {

        }

    }
}
