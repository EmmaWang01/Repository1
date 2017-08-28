using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using BizLogix.SQL;
using VistaMenuControl;
using System.Threading;
using System.Globalization;
using System.Net;
using BrightIdeasSoftware;
using System.IO;
using FullScreenMode;
using StatusBoard.Tools;
using System.Drawing.Imaging;
using System.Diagnostics;

namespace LoanCenter
{
    public partial class frmMain : XCoolForm.XCoolForm 
    {
        #region Private variables
        IniReader ini;

        //private string sConnectionString = @"Data source=172.31.3.65;Initial Catalog=M3_MAIN;User Id=sa;Password=Madbkan3;"; // providerName="System.Data.SqlClient";
       // private string sItConnectionString = @"Data source=172.31.3.65;Initial Catalog=StatusLogix;User Id=sa;Password=Madbkan3;"; // providerName="System.Data.SqlClient";

        private string sConnectionString = @"Data source=172.31.3.68;Initial Catalog=M3_MAIN;User Id=sa;Password=Madbkan3;"; // providerName="System.Data.SqlClient";
        private string sItConnectionString = @"Data source=172.31.3.68;Initial Catalog=StatusLogix;User Id=sa;Password=Madbkan3;"; // providerName="System.Data.SqlClient";

        private string mndPath = Application.StartupPath + @"\Money3NetworkDiagnostics.exe";
        
        private XmlThemeLoader xtl = new XmlThemeLoader();
        
        private int _page = 0;

        private int _interval = 0;
        private int _countDownValue = 0;
        
        //ucITDiagnostics pnlITDiagnostics;

        // Team Targets
        private int iDollarTarget = 100000;
        private int iVolumeTarget = 150;
        private string sTeam = "Unspecified";
        AnimationAdapter controlWithAnimation;
        Animation animation;

        private readonly BackgroundWorker worker;

        private FullScreen _FullScreen;
        private bool IsFullScreen = false;

        private string sImageFilePath;
        #endregion

        public frmMain() : base()
        {
            Trace.Listeners.Clear();
            DefaultTraceListener listener = new DefaultTraceListener();
            Trace.Listeners.Add(listener);
            Debugger.Log(1, "test", "I'm advanced!");


            InitializeComponent();
            worker =  new BackgroundWorker();
            _FullScreen = new FullScreen(this);

            LoadSettings();
            
            Thread.CurrentThread.CurrentCulture = new CultureInfo("en-AU");
            CurrentTD.ItemWidth = this.Width / 6;

            digitalClockCtrl.SetDigitalColor = SriClocks.DigitalColor.GreenColor;

            LoadTheme();

            this.Show();
            Application.DoEvents();
            UpdateDashboard();
           
        }

        private void LoadTheme()
        {
            this.Border.BorderStyle = XCoolForm.X3DBorderPrimitive.XBorderStyle.X3D;
            this.TitleBar.TitleBarType = XCoolForm.XTitleBar.XTitleBarType.Rounded;
            this.TitleBar.TitleBarCaption = this.Text;

            this.TitleBar.TitleBarFill = XCoolForm.XTitleBar.XTitleBarFill.AdvancedRendering;

            
            this.TitleBar.TitleBarButtons[2].ButtonFillMode = XCoolForm.XTitleBarButton.XButtonFillMode.UpperGlow;
            this.TitleBar.TitleBarButtons[1].ButtonFillMode = XCoolForm.XTitleBarButton.XButtonFillMode.UpperGlow;
            this.TitleBar.TitleBarButtons[0].ButtonFillMode = XCoolForm.XTitleBarButton.XButtonFillMode.UpperGlow;
            /*
            this.IconHolder.HolderButtons[3].ButtonImage = XCoolFormTest.Properties.Resources.Quake_48x48.GetThumbnailImage(20, 20, null, IntPtr.Zero);
            this.IconHolder.HolderButtons[2].ButtonImage = XCoolFormTest.Properties.Resources.Quake_III_Arena_48x48.GetThumbnailImage(20, 20, null, IntPtr.Zero);
            this.IconHolder.HolderButtons[1].ButtonImage = XCoolFormTest.Properties.Resources.Quake_IV_48x48.GetThumbnailImage(20, 20, null, IntPtr.Zero);
            this.IconHolder.HolderButtons[0].ButtonImage = XCoolFormTest.Properties.Resources.Quake_II_48x48.GetThumbnailImage(20, 20, null, IntPtr.Zero);

            this.IconHolder.HolderButtons[3].FrameBackImage = XCoolFormTest.Properties.Resources.Quake_48x48;
            this.IconHolder.HolderButtons[2].FrameBackImage = XCoolFormTest.Properties.Resources.Quake_III_Arena_48x48;
            this.IconHolder.HolderButtons[1].FrameBackImage = XCoolFormTest.Properties.Resources.Quake_IV_48x48;
            this.IconHolder.HolderButtons[0].FrameBackImage = XCoolFormTest.Properties.Resources.Quake_II_48x48;
            */
            
            this.MenuIcon = LoanCenter.Properties.Resources._3icon.GetThumbnailImage(30, 25, null, IntPtr.Zero);
            //this.TitleBar.TitleBarBackImage = LoanCenter.Properties.Resources.m3_logo_sml;
            
            /*
            this.StatusBar.BarBackImage = XCoolFormTest.Properties.Resources.Quake_256x256;
            this.StatusBar.BarImageAlign = XCoolForm.XStatusBar.XStatusBarBackImageAlign.Left;
            this.StatusBar.BarItems[1].BarItemText = "Date: 12/12/2045";
             */
            xtl.ApplyTheme(Path.Combine(Environment.CurrentDirectory, @"Themes\DarkSystemTheme.xml"));
        }

        private void LoadSettings()
        {
            ini = new IniReader(Application.StartupPath + @"\dashboard.ini");
            
            _interval = ini.ReadInteger("Timers", "PageChange", 180000);
            _countDownValue = _interval;
            timer1.Interval = _interval;

            sTeam = ini.ReadString("Team", "Name", "Unspecified");

            iDollarTarget = ini.ReadInteger(sTeam + "-TeamTargets", "DollarTarget", 100000);
            iVolumeTarget = ini.ReadInteger(sTeam + "-TeamTargets", "VolumeTarget", 150);

            sImageFilePath = ini.ReadString("Paths", "ScreenshotImagePath", Application.StartupPath + @"\");
            
            
            this.Text = sTeam + " Status Board";
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            _countDownValue = _interval;

            if (sTeam == "Loan Centre")
            {
                if (_page > 0)
                    _page = 0;
                else
                    _page++;
            }
            //UpdateDashboard();
            //dataWorker.RunWorkerAsync();

            UpdateDashboard();
        }

        private string[] sSelectedTeamMember;
        private void LoadList()
        {
            string[] strArray = ini.GetAllKeysInIniFileSection(sTeam + "-TeamMemberTargets", Application.StartupPath + @"\dashboard.ini");

            for (int i = 0; i < strArray.Length; i++)
            {
                sSelectedTeamMember = strArray[i].Split('=');
                //lstTeamMembers.Items.Add(sSelectedTeamMember[0].ToString());
            }


        }

        private void UpdateDashboard()
        {
            LoadSettings();

            circularProgressControl1.Visible = true;
            circularProgressControl1.Start();
            Application.DoEvents();

            //lbListView.Visible = false;

            try
            {
                CurrentTD.Visible = false;
                vmTarget.Visible = false;
                vmCountTarget.Visible = false;
                lbListName.Visible = false;
                //lblMessage.Text = "Refreshing Data";

                if (sTeam.Contains("Systems"))
                {
                    #region IT Systems

                    vmTarget.Items.Clear();

                    // server 2
                    string myquery = GetITQueryDef("APL_Users_10_66_0_2_Last", sTeam);
                    DataSet ds = ExecQuery(myquery, sItConnectionString);
                    string sResult = "";
                    
                    try
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            sResult = string.Format("{0:0}", ds.Tables[0].Rows[0][1].ToString()) ;
                            vmTarget.Items.Add("APL Users 10.66.0.2: ", sResult);
                        }
                    }
                    catch { Debugger.Log(1, "test", "Danger, Danger Will Robinson1"); }

                    // server 3
                    myquery = GetITQueryDef("APL_Users_10_66_0_3_Last", sTeam);
                    ds = ExecQuery(myquery, sItConnectionString);

                    try
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            sResult = string.Format("{0:0}", ds.Tables[0].Rows[0][1].ToString());
                            vmTarget.Items.Add("APL Users 10.66.0.3: ", sResult);
                        }
                    }
                    catch { Debugger.Log(1, "test", "Danger, Danger Will Robinson2" ); }

                    // server 5
                    myquery = GetITQueryDef("APL_Users_10_66_0_5_Last", sTeam);
                    ds = ExecQuery(myquery, sItConnectionString);

                    try
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            sResult = string.Format("{0:0}", ds.Tables[0].Rows[0][1].ToString());
                            vmTarget.Items.Add("APL Users 10.66.0.5: ", sResult);
                        }
                    }
                    catch { Debugger.Log(1, "test", "Danger, Danger Will Robinson3"); }

                    // server 7
                    myquery = GetITQueryDef("APL_Users_10_66_0_7_Last", sTeam);
                    ds = ExecQuery(myquery, sItConnectionString);

                    try
                    {
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            sResult = string.Format("{0:0}", ds.Tables[0].Rows[0][1].ToString());
                            vmTarget.Items.Add("APL Users 10.66.0.7: ", sResult);

                        }
                    }
                    catch { Debugger.Log(1, "test", "Danger, Danger Will Robinson4"); }


                    // Customise the vmTarget Panel
                    foreach (VistaMenuControl.VistaMenuItem item in vmTarget.Items)
                    {
                        item.CaptionColor = Color.LightGray;
                        item.ContentColor = Color.White;
                        item.CaptionFont = new Font("Tahoma", 16);
                        item.ContentFont = new Font("Tahoma", 22, FontStyle.Bold);

                        string[] val = item.Description.Split('.');
                        int sval= Convert.ToInt16(val[0]);
                        if ( sval > 40)
                        {
                            lblMessage.Text = "APL High Usage Reached";
                            lblMessage.ForeColor = Color.Red;

                            item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                            item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                            item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                            item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                            item.InnerBorder = Color.FromArgb(254, 254, 254);
                            item.OuterBorder = Color.FromArgb(231, 231, 231);
                            item.CaptionFont = new Font("Tahoma", 16);
                            item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                            item.CaptionColor = Color.LightGray;
                            item.ContentColor = Color.Red;
                        }
                        else
                        {
                            item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                            item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                            item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                            item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                            item.InnerBorder = Color.FromArgb(254, 254, 254);
                            item.OuterBorder = Color.FromArgb(231, 231, 231);
                            item.CaptionFont = new Font("Tahoma", 16);
                            item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                            item.CaptionColor = Color.LightGray;
                            item.ContentColor = Color.LimeGreen;
                        }
                        

                        Application.DoEvents();
                    }

                    // add results
                   // vmTarget.Items.Add("APL Users", sResult);


                    Application.DoEvents();

                    lbListView.Visible = true;

                    circularProgressControl1.Stop();
                    circularProgressControl1.Visible = false;

                    //CurrentTD.Visible = true;
                    vmTarget.Visible = true;
                    //vmCountTarget.Visible = true;
                    //lbListName.Visible = true;
                    //lblMessage.Text = "Dashboard";
                    //lblMessage.ForeColor = Color.DarkGray ;
                    Application.DoEvents();

                    #endregion
                }
                else
                {
                    #region Teams/Branches
                    //CurrentTD.Visible = false;
                    double m_Gap = 0;
                    int m_VGap = 0;
                    int m_volCount = 0;
                    string myquery = GetQueryDef("WTDFEENAF", sTeam);
                    DataSet ds = ExecQuery(myquery,sConnectionString);

                    CurrentTD.Items.Clear();

                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                    {
                        //lblMTDNAF.Text = String.Format("{0:C}", ds.Tables[0].Rows[0][2]);
                        CurrentTD.Items.Add("WTD FEE (" + String.Format("{0:0}", ds.Tables[0].Rows[0][2]) + ")", String.Format("{0:C}", ds.Tables[0].Rows[0][3]));
                        CurrentTD.Items.Add("WTD NAF", String.Format("{0:C}", ds.Tables[0].Rows[0][4]));
                    }
                    Application.DoEvents();
                    myquery = GetQueryDef("MTDFEENAF", sTeam);
                    Debugger.Log(1, "test", "SEQUENCE!_" + myquery);
                    ds = ExecQuery(myquery, sConnectionString);


                    //CurrentTD.Items.Clear();

                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                    {
                        //int iDollarTarget = ini.ReadInteger("TeamTargets", "DollarTarget", 100000);
                        //int iVolumeTarget = ini.ReadInteger("TeamTargets", "VolumeTarget", 150);
                        CurrentTD.Items.Add("MTD FEE (" + String.Format("{0:0}", ds.Tables[0].Rows[0][2]) + ")", String.Format("{0:C}", ds.Tables[0].Rows[0][3]));
                        CurrentTD.Items.Add("MTD NAF", String.Format("{0:C}", ds.Tables[0].Rows[0][4]));
                        m_Gap = iDollarTarget - Convert.ToDouble(ds.Tables[0].Rows[0][3]);
                        m_VGap = iVolumeTarget - Convert.ToInt16(ds.Tables[0].Rows.Count);
                   
                        m_volCount = ds.Tables[0].Rows.Count;
                        Application.DoEvents();
                    }
                    Application.DoEvents();


                    // Target
                    try
                    {

                        vmTarget.Items.Clear();
                        vmTarget.Items.Add(sTeam + " $ Target", String.Format("{0:C}", iDollarTarget));
                        vmTarget.Items.Add("Currently", String.Format("{0:C}", ds.Tables[0].Rows[0][3]));
                        vmTarget.Items.Add("Required to hit Target", String.Format("{0:C}", m_Gap));

                        //vmTarget.Items.Add("Web Centre Volume", "150 Loans");
                        //vmTarget.Items.Add("Currently", ds.Tables[0].Rows.Count.ToString());
                        //vmTarget.Items.Add("Required to hit Target", m_VGap.ToString());

                    }
                    catch (Exception ex)
                    {
                        Debugger.Log(1, "test", "Danger, Danger Will Robinson5" + ex);
                    }
                    //PositionGraphicsPanel();

                    Application.DoEvents();





                    myquery = GetQueryDef("YTDFEENAF", sTeam);
                    ds = ExecQuery(myquery, sConnectionString);

                    for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                    {
                        // lblYTDNAF.Text = String.Format("{0:C}", ds.Tables[0].Rows[0][2]);
                        CurrentTD.Items.Add("YTD FEE (" + String.Format("{0:0}", ds.Tables[0].Rows[0][2]) + ")", String.Format("{0:C}", ds.Tables[0].Rows[0][3]));
                        CurrentTD.Items.Add("YTD NAF", String.Format("{0:C}", ds.Tables[0].Rows[0][4]));
                    }
                    Application.DoEvents();


                    // Customise the vmTarget Panel
                    foreach (VistaMenuControl.VistaMenuItem item in vmTarget.Items)
                    {
                        item.CaptionColor = Color.LightGray;
                        item.ContentColor = Color.White;
                        item.CaptionFont = new Font("Tahoma", 16);
                        item.ContentFont = new Font("Tahoma", 22, FontStyle.Bold);

                        if (item.Text == "Required to hit Target")
                        {
                            if (m_Gap > 0)
                            {
                                item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                item.InnerBorder = Color.FromArgb(254, 254, 254);
                                item.OuterBorder = Color.FromArgb(231, 231, 231);
                                item.CaptionFont = new Font("Tahoma", 16);
                                item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                item.CaptionColor = Color.LightGray;
                                item.ContentColor = Color.Orange;
                            }
                            else
                            {
                                //reached budget
                                lblMessage.Text = "Monthly Budget Reached";
                                lblMessage.ForeColor = Color.LimeGreen;


                                item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                item.InnerBorder = Color.FromArgb(254, 254, 254);
                                item.OuterBorder = Color.FromArgb(231, 231, 231);
                                item.CaptionFont = new Font("Tahoma", 16);
                                item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                item.CaptionColor = Color.LightGray;
                                item.ContentColor = Color.LimeGreen;
                            }
                        }

                        Application.DoEvents();
                    }


                    foreach (VistaMenuControl.VistaMenuItem item in CurrentTD.Items)
                    {
                        /*item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                        item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                        item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                        item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                        item.InnerBorder = Color.FromArgb(254, 254, 254);
                        item.OuterBorder = Color.FromArgb(231, 231, 231);
                        item.CaptionFont = new Font("Tahoma", 14, FontStyle.Bold);
                        item.ContentFont = new Font("Tahoma", 20);
                        item.CaptionColor = Color.LightGray;
                        item.ContentColor = Color.White;
                         */

                        item.CaptionColor = Color.LightGray;
                        item.ContentColor = Color.White;
                        item.CaptionFont = new Font("Tahoma", 16);
                        item.ContentFont = new Font("Tahoma", 20, FontStyle.Bold);

                        if (item.Text == "Required to hit Target")
                        {
                            if (m_Gap > 0)
                            {
                                item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                item.InnerBorder = Color.FromArgb(254, 254, 254);
                                item.OuterBorder = Color.FromArgb(231, 231, 231);
                                item.CaptionFont = new Font("Tahoma", 16);
                                item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                item.CaptionColor = Color.LightGray;
                                item.ContentColor = Color.Orange;
                            }
                            else
                            {
                                //reached budget
                                lblMessage.Text = "Monthly Budget Reached";
                                lblMessage.ForeColor = Color.LimeGreen;


                                item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                item.InnerBorder = Color.FromArgb(254, 254, 254);
                                item.OuterBorder = Color.FromArgb(231, 231, 231);
                                item.CaptionFont = new Font("Tahoma", 16);
                                item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                item.CaptionColor = Color.LightGray;
                                item.ContentColor = Color.LimeGreen;
                            }
                        }
                        Application.DoEvents();
                    }

                    CurrentTD.Left = (Screen.PrimaryScreen.Bounds.Width - CurrentTD.Width) / 2;

                    //CurrentTD.Visible = true;

                    Application.DoEvents();
                    


                    if (_page == 0)
                    {

                        ini = new IniReader(Application.StartupPath + @"\dashboard.ini" );


                        lbListName.Text = sTeam.ToUpper() + " TEAM";

                        lbListView.Columns[0].Text = "Team Member";
                        lbListView.Columns[2].Text = "Fees";

                        lbListView.Font = new System.Drawing.Font("Segoe UI", 36);

                        myquery = GetQueryDef("TEAM", sTeam);
                        
                        ds = ExecQuery(@myquery, sConnectionString);

                        lbListView.Items.Clear();
                        int iLoanCount = 0;

                    
                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            ListViewItem itm = new ListViewItem(ds.Tables[0].Rows[j][0].ToString());
                            itm.UseItemStyleForSubItems = false;

                            int sCountToTarget = ini.ReadInteger(sTeam + "-TeamMemberTargets", ds.Tables[0].Rows[j][0].ToString()) - Convert.ToInt16(ds.Tables[0].Rows[j][1]);

                            itm.SubItems.Add(ds.Tables[0].Rows[j][1].ToString() + " (" + sCountToTarget.ToString().Replace("-","+") + ")");
                            iLoanCount += Convert.ToInt16(ds.Tables[0].Rows[j][1]) ; 
                            itm.SubItems.Add(Convert.ToDouble(ds.Tables[0].Rows[j][2]).ToString("c"));
                            //itm.SubItems.Add(String.Format("${0:C}", ds.Tables[0].Rows[j][2].ToString()));
                            //itm.SubItems.Add(String.Format("${0:c}", ds.Tables[0].Rows[j][3].ToString()));

                            if (sCountToTarget > 0 && sCountToTarget < 3)
                            {
                                itm.BackColor = System.Drawing.Color.FromArgb(34, 34, 34);
                                itm.ForeColor = System.Drawing.Color.Orange;

                                itm.SubItems[0].BackColor = System.Drawing.Color.FromArgb(34, 34, 34);
                                itm.SubItems[1].BackColor = System.Drawing.Color.FromArgb(34, 34, 34);
                                itm.SubItems[2].BackColor = System.Drawing.Color.FromArgb(34, 34, 34);

                                itm.SubItems[0].ForeColor = System.Drawing.Color.Orange;
                                itm.SubItems[1].ForeColor = System.Drawing.Color.Orange;
                                itm.SubItems[2].ForeColor = System.Drawing.Color.Orange;
                            }
                            else if (sCountToTarget >= 3)
                            {
                                itm.BackColor = System.Drawing.Color.Black;
                                itm.ForeColor = System.Drawing.Color.Gainsboro;

                                itm.SubItems[0].BackColor = System.Drawing.Color.FromArgb(34,34,34);
                                itm.SubItems[1].BackColor = System.Drawing.Color.FromArgb(34, 34, 34);
                                itm.SubItems[2].BackColor = System.Drawing.Color.FromArgb(34, 34, 34);

                                itm.SubItems[0].ForeColor = System.Drawing.Color.Gainsboro;
                                itm.SubItems[1].ForeColor = System.Drawing.Color.Gainsboro;
                            }
                            else
                            {
                                itm.BackColor = System.Drawing.Color.Green;
                                itm.ForeColor = System.Drawing.Color.Gainsboro;

                                itm.SubItems[0].BackColor = System.Drawing.Color.Lime;
                                itm.SubItems[1].BackColor = System.Drawing.Color.Lime;
                                itm.SubItems[2].BackColor = System.Drawing.Color.Lime;

                                itm.SubItems[0].ForeColor = System.Drawing.Color.Black;
                                itm.SubItems[1].ForeColor = System.Drawing.Color.Black;
                                itm.SubItems[2].ForeColor = System.Drawing.Color.Black;
                            }

                        
                            lbListView.Items.Add(itm);

                            Application.DoEvents();
                        }
                        m_VGap = iVolumeTarget - iLoanCount;
                        vmCountTarget.Items.Clear();
                        vmCountTarget.Items.Add(sTeam + " Volume", iVolumeTarget.ToString() + " Loans");
                        vmCountTarget.Items.Add("Currently", iLoanCount.ToString());
                        vmCountTarget.Items.Add("Required to hit Target", m_VGap.ToString().Replace("-","+"));
                        vmCountTarget.Top = vmTarget.Top + vmTarget.Height + 10;

                        //For each column
                        for (int m = 0; m <= lbListView.Columns.Count - 1; m++)
                        {
                            int a = 0;
                            int b = 0;
                            lbListView.Columns[m].Width = -1;
                            a = lbListView.Columns[m].Width;
                            lbListView.Columns[m].Width = -2;
                            b = lbListView.Columns[m].Width;

                            if (a > b)
                            {
                                lbListView.Columns[m].Width = -1;
                            }
                            else
                            {
                                lbListView.Columns[m].Width = -2;
                            }

                            if (m > 0)
                            {
                                lbListView.Columns[m].TextAlign = HorizontalAlignment.Right;
                            }

                            Application.DoEvents();
                        }
                        lbListView.EndUpdate();

                        // Customise the vmTarget Panel
                        foreach (VistaMenuControl.VistaMenuItem item in vmTarget.Items)
                        {
                            item.CaptionColor = Color.LightGray;
                            item.ContentColor = Color.White;
                            item.CaptionFont = new Font("Tahoma", 16);
                            item.ContentFont = new Font("Tahoma", 22, FontStyle.Bold);

                            if (item.Text == "Required to hit Target")
                            {
                                if (m_Gap > 0)
                                {
                                    item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                    item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                    item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                    item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                    item.InnerBorder = Color.FromArgb(254, 254, 254);
                                    item.OuterBorder = Color.FromArgb(231, 231, 231);
                                    item.CaptionFont = new Font("Tahoma", 16);
                                    item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                    item.CaptionColor = Color.LightGray;
                                    item.ContentColor = Color.Orange;
                                }
                                else
                                {
                                    //reached budget
                                    lblMessage.Text = "Monthly Budget Reached";
                                    lblMessage.ForeColor = Color.LimeGreen;


                                    item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                    item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                    item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                    item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                    item.InnerBorder = Color.FromArgb(254, 254, 254);
                                    item.OuterBorder = Color.FromArgb(231, 231, 231);
                                    item.CaptionFont = new Font("Tahoma", 16);
                                    item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                    item.CaptionColor = Color.LightGray;
                                    item.ContentColor = Color.LimeGreen;
                                }
                            }

                            Application.DoEvents();
                        }

                        foreach (VistaMenuControl.VistaMenuItem item in CurrentTD.Items)
                        {
                            /*item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                            item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                            item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                            item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                            item.InnerBorder = Color.FromArgb(254, 254, 254);
                            item.OuterBorder = Color.FromArgb(231, 231, 231);
                            item.CaptionFont = new Font("Tahoma", 14, FontStyle.Bold);
                            item.ContentFont = new Font("Tahoma", 20);
                            item.CaptionColor = Color.LightGray;
                            item.ContentColor = Color.White;
                             */

                            item.CaptionColor = Color.LightGray;
                            item.ContentColor = Color.White;
                            item.CaptionFont = new Font("Tahoma", 16);
                            item.ContentFont = new Font("Tahoma", 20, FontStyle.Bold);

                            if (item.Text == "Required to hit Target")
                            {
                                if (m_Gap > 0)
                                {
                                    item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                    item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                    item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                    item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                    item.InnerBorder = Color.FromArgb(254, 254, 254);
                                    item.OuterBorder = Color.FromArgb(231, 231, 231);
                                    item.CaptionFont = new Font("Tahoma", 16);
                                    item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                    item.CaptionColor = Color.LightGray;
                                    item.ContentColor = Color.Orange;
                                }
                                else
                                {
                                    //reached budget
                                    lblMessage.Text = "Monthly Budget Reached";
                                    lblMessage.ForeColor = Color.LimeGreen;


                                    item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                    item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                    item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                    item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                    item.InnerBorder = Color.FromArgb(254, 254, 254);
                                    item.OuterBorder = Color.FromArgb(231, 231, 231);
                                    item.CaptionFont = new Font("Tahoma", 16);
                                    item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                    item.CaptionColor = Color.LightGray;
                                    item.ContentColor = Color.LimeGreen;
                                }
                            }
                            Application.DoEvents();
                        }

                        CurrentTD.Left = (Screen.PrimaryScreen.Bounds.Width - CurrentTD.Width) / 2;

                        // customise the vmCounttarget Panel
                        foreach (VistaMenuControl.VistaMenuItem item in vmCountTarget.Items)
                        {
                            item.CaptionColor = Color.LightGray;
                            item.ContentColor = Color.White;
                            item.CaptionFont = new Font("Tahoma", 16);
                            item.ContentFont = new Font("Tahoma", 20, FontStyle.Bold);

                            if (item.Text == "Required to hit Target")
                            {
                                if (m_VGap > 0)
                                {
                                    item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                    item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                    item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                    item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                    item.InnerBorder = Color.FromArgb(254, 254, 254);
                                    item.OuterBorder = Color.FromArgb(231, 231, 231);
                                    item.CaptionFont = new Font("Tahoma", 16);
                                    item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                    item.CaptionColor = Color.LightGray;
                                    item.ContentColor = Color.Orange;
                                }
                                else
                                {
                                    //reached budget
                                    lblMessage.Text = "Monthly Count Reached";
                                    lblMessage.ForeColor = Color.LimeGreen;


                                    item.SelectionStartColor = Color.FromArgb(152, 193, 233);
                                    item.SelectionEndColor = Color.FromArgb(134, 186, 237);
                                    item.SelectionStartColorStart = Color.FromArgb(104, 169, 234);
                                    item.SelectionEndColorEnd = Color.FromArgb(169, 232, 255);
                                    item.InnerBorder = Color.FromArgb(254, 254, 254);
                                    item.OuterBorder = Color.FromArgb(231, 231, 231);
                                    item.CaptionFont = new Font("Tahoma", 16);
                                    item.ContentFont = new Font("Tahoma", 26, FontStyle.Bold);
                                    item.CaptionColor = Color.LightGray;
                                    item.ContentColor = Color.LimeGreen;
                                }
                            }

                            Application.DoEvents();
                        }

                        Application.DoEvents();
                    }
               
                    else
                    {
                        lbListName.Text = "BROKERS Loans";

                        lbListView.Columns[0].Text = "Broker Name";
                        lbListView.Columns[2].Text = "NAF";

                        lbListView.Font = new System.Drawing.Font("Segoe UI", 32);

                        myquery = GetQueryDef("BROKERS",sTeam);
                        ds = ExecQuery(myquery, sConnectionString);

                        lbListView.Items.Clear();
                        string sBrokerName = "";

                        for (int j = 0; j < ds.Tables[0].Rows.Count; j++)
                        {
                            sBrokerName = ds.Tables[0].Rows[j][0].ToString();

                            ListViewItem itm = new ListViewItem(sBrokerName);

                            itm.SubItems.Add(ds.Tables[0].Rows[j][1].ToString());
                            itm.SubItems.Add(Convert.ToDouble(ds.Tables[0].Rows[j][2]).ToString("c"));

                            lbListView.Items.Add(itm);

                            Application.DoEvents();
                        }

                        //For each column
                        for (int m = 0; m <= lbListView.Columns.Count - 1; m++)
                        {
                            int a = 0;
                            int b = 0;
                            lbListView.Columns[m].Width = -1;
                            a = lbListView.Columns[m].Width;
                            lbListView.Columns[m].Width = -2;
                            b = lbListView.Columns[m].Width;

                            if (a > b)
                            {
                                lbListView.Columns[m].Width = -1;
                            }
                            else
                            {
                                lbListView.Columns[m].Width = -2;
                            }

                            if (m > 0)
                            {
                                lbListView.Columns[m].TextAlign = HorizontalAlignment.Right;
                            }

                            Application.DoEvents();
                        }
                        lbListView.EndUpdate();

                        Application.DoEvents();
                    }
 

                    lbListView.Visible = true;

                    circularProgressControl1.Stop();
                    circularProgressControl1.Visible = false;

                    CurrentTD.Visible = true;
                    vmTarget.Visible = true;
                    vmCountTarget.Visible = true;
                    lbListName.Visible = true;
                    //lblMessage.Text = "Dashboard";
                    //lblMessage.ForeColor = Color.DarkGray ;
                    Application.DoEvents();

                    if (lblMessage.Text.Contains("Reached"))
                    {
                        //lbListView.Visible = false;
                        //userControl11.BringToFront();
                        //RunSpinnerAnimation();
                    }
                
                #endregion
                }
            }
            catch(Exception ex) 
            {
                circularProgressControl1.Stop();
                circularProgressControl1.Visible = false;
                Application.DoEvents();
                lbListName.Text = "";

                //lblMessage.Text = "No Data Connection";
                //lblMessage.ForeColor = Color.Red;

                Debugger.Log(1, "test", "oops i've crashed"+ ex);

                RunNoDataAnimation();
            }
        
            userControl11.Visible = false;

            //TakeScreenShot();
        }

        private static ImageCodecInfo GetEncoderInfo(String mimeType)
        {
            int j;
            ImageCodecInfo[] encoders;
            encoders = ImageCodecInfo.GetImageEncoders();
            for (j = 0; j < encoders.Length; ++j)
            {
                if (encoders[j].MimeType == mimeType)
                    return encoders[j];
            } 
            return null;
        }

        private void TakeScreenShot()
        {
            try
            {
                if (File.Exists(sImageFilePath))
                    File.Delete(sImageFilePath);

                using (Bitmap bmpScreenshot = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height, PixelFormat.Format32bppArgb))
                {
                    // Create a graphics object from the bitmap  
                    using (Graphics gfxScreenshot = Graphics.FromImage(bmpScreenshot))
                    {
                        try
                        {
                            //Log("Capture screen"); 
                            // Take the screenshot from the upper left corner to the right bottom corner  
                            gfxScreenshot.CopyFromScreen(Screen.PrimaryScreen.Bounds.X,
                            Screen.PrimaryScreen.Bounds.Y,
                            0, 0, Screen.PrimaryScreen.Bounds.Size, CopyPixelOperation.SourceCopy);

                        }
                        catch
                        { Debugger.Log(1, "test", "Danger, Danger Will Robinson6"); }
                    }

                    using (FileStream fs = new FileStream(sImageFilePath, FileMode.Create))
                    {
                        EncoderParameters codecParams = new EncoderParameters(1);
                        codecParams.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);
                        ImageCodecInfo[] encoders;

                        encoders = ImageCodecInfo.GetImageEncoders();

                        bmpScreenshot.Save(fs, encoders[1], codecParams);
                        fs.Close();
                    }

                }

                lblErrorMesg.Text = "Screenshot taken as requested.";
                lblErrorMesg.Visible = true;
                timerErrorReset.Enabled = true;

            }
            catch(Exception ex)
            {
                Debugger.Log(1, "test", "oops i've crashed" + ex);
                lblErrorMesg.Text = "Screenshot Error: Can't Access file.";
                lblErrorMesg.Visible = true;
                timerErrorReset.Enabled = true;
            }
        }

        private DataSet ExecQuery(string lsQuery,string sMyConnectionString)
        {
            //int        liParameterCnt = 0;
            string lsConnectionString = sMyConnectionString;
            DataSet loDataSet;
            SQLHelper loSQLHelper = new SQLHelper("tester");

            lsConnectionString = sConnectionString.Trim();

            try
            {
                return loDataSet = loSQLHelper.ExecuteDataSet(lsConnectionString, lsQuery);
            }
            catch (Exception loException)
            {
                Debugger.Log(1, "test", "sql!" + loException);
                //MessageBox.Show(loException.Message, "Application Message");
                DataSet dsEmpty = new DataSet();
                return dsEmpty;
            }

        }

        #region Team/Branch Query Defs
        public static string GetQueryDef(string QueryName, string TeamName)
        {
            string query = "";

            switch (QueryName)
            {
                #region Screen 1
                case "WTDFEENAF":
                    //query = "Use M3_MAIN set dateformat dmy SELECT 'Weekly' as 'Type',BR.Branch, Count(*) as Cnt,(sum(DSS_ApplicationFees) +  sum(DSS_TotalInterest) + SUM(DSS_MonthlyServiceFee)) as Fees,(sum(DSS_CashOut) + sum(DSS_Insurance) + SUM(DSS_Brokerage)) as NAF FROM M3_MAIN.dbo.iO_DataStorage_SalesReport left join (SELECT iO_Product_MasterReference.RMR_SeqNumber, iO_Client_MasterReference.CMR_Name AS Branch FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND (iO_Link_MasterReference.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}')) as BR ON br.RMR_SeqNumber  = DSS_LoanNumber where iO_DataStorage_SalesReport.DSS_SettlementDate between DATEADD(wk, DATEDIFF(wk, 0, '1/1/' + CAST(DATEPART(YY, GETDATE()) AS CHAR(4))) + (DATEPART(WK, GETDATE())-1), 0) and DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + CAST(DATEPART(YY, GETDATE()) AS CHAR(4))) + (DATEPART(WK, GETDATE())-1), 5) and br.Branch='"+ TeamName +"' group by br.Branch";
                    query = ReadSQLFile("WTDFEENAF");
                    query = query.Replace("[TEAMNAME]", TeamName);
                    query = query.Replace(@"\\", @"\");
                    break;

                case "MTDFEENAF":
                    //query = "Use M3_MAIN SELECT 'Monthly' as 'Type', BR.Branch, Count(*) as Cnt, (sum(DSS_ApplicationFees) +  sum(DSS_TotalInterest) + SUM(DSS_MonthlyServiceFee)) as MTDFees, (sum(DSS_CashOut) + sum(DSS_Insurance) + SUM(DSS_Brokerage)) as MTDNAF FROM M3_MAIN.dbo.iO_DataStorage_SalesReport left join(SELECT iO_Product_MasterReference.RMR_SeqNumber, iO_Client_MasterReference.CMR_Name AS Branch FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND (iO_Link_MasterReference.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}')) as BR ON br.RMR_SeqNumber  = DSS_LoanNumber where DATEADD(mm,DATEDIFF(mm,0,DSS_SettlementDate),0)=DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) and br.Branch='" + TeamName + "' group by br.Branch";
                    query = ReadSQLFile("MTDFEENAF");
                    query = query.Replace("[TEAMNAME]", TeamName);
                    query = query.Replace(@"\\", @"\");
                    break;
                case "YTDFEENAF":
                    //query = "Use M3_MAIN set dateformat ymd SELECT 'Yearly' as 'Type',	 BR.Branch, count(*) as Cnt,(sum(DSS_ApplicationFees) +  sum(DSS_TotalInterest) + SUM(DSS_MonthlyServiceFee)) as YTDFees, (sum(DSS_CashOut) + sum(DSS_Insurance) + SUM(DSS_Brokerage)) as YTDNAF FROM M3_MAIN.dbo.iO_DataStorage_SalesReport iO_DataStorage_SalesReport left join (SELECT iO_Product_MasterReference.RMR_SeqNumber, iO_Client_MasterReference.CMR_Name AS Branch FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND (iO_Link_MasterReference.LMR_IDLink_Association='{b55145aa-2697-43b5-9c6a-c4a0960823d8}')) as BR ON br.RMR_SeqNumber  = DSS_LoanNumber where DSS_SettlementDate between cast(cast(year(getdate()) as varchar(4)) +'-' + '07' + '-' + '01' as datetime) and getdate()	and br.Branch='" + TeamName + "' group by br.Branch";
                    query = ReadSQLFile("YTDFEENAF");
                    query = query.Replace("[TEAMNAME]", TeamName);
                    query = query.Replace(@"\\", @"\");
                    break;
                case "TEAM":
                    //query = "Use M3_MAIN set dateformat ymd SELECT CMAssess.cmr_name as AssessorName, COUNT(*) as cnt, sum((DSS_ApplicationFees) +  (DSS_TotalInterest) + (DSS_MonthlyServiceFee)) as 'Fees', sum((DSS_CashOut) +  (DSS_Insurance) + (DSS_Brokerage)) as 'NAF' FROM M3_MAIN.dbo.iO_DataStorage_SalesReport left JOIN iO_Product_MasterReference on DSS_LoanNumber = RMR_SeqNumber left join iO_Link_MasterReference  ON RMR_ID = LMR_IDLink_Code_ID left JOIN iO_Client_MasterReference CM ON CM.CMR_ID = LMR_IDLink_Code_ID left JOIN iO_Control_LinkMaster ON XLK_ID = LMR_IDLink_Association left JOIN iO_Client_MasterReference CMAssess ON CMAssess.CMR_ID = LMR_IDLink_CMR left join (SELECT iO_Product_MasterReference.RMR_SeqNumber, iO_Client_MasterReference.CMR_Name AS Branch FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND (iO_Link_MasterReference.LMR_IDLink_Association='{7e504c4d-821c-4623-a928-28ee65c3b8c8}')) as BR ON br.RMR_SeqNumber  = iO_DataStorage_SalesReport.DSS_LoanNumber where DATEADD(mm,DATEDIFF(mm,0,iO_DataStorage_SalesReport.DSS_SettlementDate),0)=DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0)  and XLK_Detail = 'Loan\\Assessor' and br.Branch = '" + TeamName + "' group by CMAssess.cmr_name ORDER by fees DESC";
                    query = ReadSQLFile("Team");
                    query = query.Replace("[TEAMNAME]", TeamName);
                    query = query.Replace(@"\\", @"\");
                    break;
                case "BROKERS":
                    //query = "set dateformat dmy SELECT case when CMRBroker.cmr_name  in('AUSSIE CAR LOANS (MELBOURNE)') then 'AUSSIE CAR LOANS' when CMRBroker.cmr_name  in('CREDIT CHOICE FINANCE (BRISBANE)', 'CREDIT CHOICE FINANCE (COBURG)', 'CREDIT CHOICE FINANCE (PERTH)', 'CREDIT CHOICE FINANCE (SOUTHPORT)', 'CREDIT CHOICE FINANCE (TOOWOOMBA)', 'CREDIT CHOICE FINANCE (TOWNSVILLE)') then 'CREDIT CHOICE FINANCE' when CMRBroker.cmr_name  in('CREDIT ONE (SOUTHPORT)') then 'CREDIT ONE' when CMRBroker.cmr_name  in('CAPITALCORP FINANCE AND LEASING (BRISBANE)', 'CAPITALCORP FINANCE AND LEASING (CAIRNS)') then 'CAPITALCORP' when CMRBroker.cmr_name  in('I NEED FINANCE NOW (BLACKTOWN)', 'I NEED FINANCE NOW (GOLD COAST)') then 'I NEED FINANCE NOW' when CMRBroker.cmr_name  in('MONEY NOW (BRAYBROOK)', 'MONEY NOW (BRISBANE)', 'MONEY NOW (CAIRNS)', 'MONEY NOW (MACKAY)', 'MONEY NOW (MINCHINBURY)','MONEY NOW (ROCKHAMPTON)', 'MONEY NOW (MT WAVERLEY)', 'MONEY NOW (NEWCASTLE)', 'MONEY NOW (PERTH)', 'REGIONAL CREDIT','MONEY NOW (RINGWOOD)') then 'MONEY NOW' when CMRBroker.cmr_name  in('NATIONAL FINANCE CHOICE (BRAYBROOK)', 'NATIONAL FINANCE CHOICE (MOORABBIN)', 'NATIONAL FINANCE CHOICE (MT WAVERLEY)', 'NATIONAL FINANCE CHOICE (WOODCROFT)') then 'NFC' when CMRBroker.cmr_name  in('STRATTON FINANCE (BAYSIDE BRISBANE)', 'STRATTON FINANCE (MELBOURNE)', 'STRATTON FINANCE (SOUTH EAST METRO AND HILLS)', 'STRATTON FINANCE (SYDNEY)') then 'STRATTON FINANCE' when CMRBroker.cmr_name  in('TANNASTER (CAMPBELLTOWN)', 'TANNASTER (CLAYTON)', 'TANNASTER (CRANBOURNE)', 'TANNASTER (FRANKSTON)', 'TANNASTER (GEELONG)', 'TANNASTER (GLENORCHY)', 'TANNASTER (LEASE CONVERSION)', 'TANNASTER (MELTON)', 'TANNASTER (MORPHETT VALE)', 'TANNASTER (NORTHCOTE)', 'TANNASTER (PFC DEVONPORT)', 'TANNASTER (PFC LAUNCESTON)', 'TANNASTER (PORT ADELAIDE)', 'TANNASTER (PRESTON)', 'TANNASTER (RESERVOIR)', 'TANNASTER (ROSNY PARK)', 'TANNASTER (SALISBURY)', 'TANNASTER (ST ALBANS)', 'TANNASTER (SUNSHINE)', 'TANNASTER (THOMASTOWN)','TANNASTER (DANDENONG)', 'TANNASTER (WEB CENTRE)', 'TANNASTER (WERRIBEE)', 'TANNASTER (WODONGA)', 'STAFF LOAN','TANNASTER (MICRO MOTOR)','TANNASTER (PFC HOBART)') then 'MONEY3' else CMRBroker.CMR_Name end as 'Broker' , COUNT(*) as cnt, sum((DSS_CashOut) +  (DSS_Insurance) + (DSS_Brokerage)) as 'NAF' FROM M3_MAIN.dbo.iO_DataStorage_SalesReport DSSales left join (SELECT iO_Product_MasterReference.RMR_SeqNumber, iO_Client_MasterReference.CMR_Name AS Branch FROM M3_MAIN.dbo.iO_Client_MasterReference iO_Client_MasterReference, M3_MAIN.dbo.iO_Link_MasterReference iO_Link_MasterReference, M3_MAIN.dbo.iO_Product_MasterReference iO_Product_MasterReference WHERE iO_Link_MasterReference.LMR_IDLink_Code_ID = iO_Product_MasterReference.RMR_ID AND iO_Link_MasterReference.LMR_IDLink_CMR = iO_Client_MasterReference.CMR_ID AND (iO_Link_MasterReference.LMR_IDLink_Association='{7e504c4d-821c-4623-a928-28ee65c3b8c8}')) as BR ON br.RMR_SeqNumber  = DSSales.DSS_LoanNumber left join iO_Link_MasterReference as BrokerLink on BrokerLink.lmr_idlink_code_id = DSSales.dss_idlink_rmr and brokerLink.LMR_IDLink_Association = '{69783579-9e83-4e82-bb25-7b3d52b0f99d}' left join io_client_masterreference as CMRBroker on CMRBroker.cmr_id = BrokerLink.LMR_IDLink_CMR where DATEADD(mm,DATEDIFF(mm,0,dssales.DSS_SettlementDate),0)=DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0) and br.Branch = 'Loan Centre' group by (case when CMRBroker.cmr_name  in('AUSSIE CAR LOANS (MELBOURNE)') then 'AUSSIE CAR LOANS' when CMRBroker.cmr_name  in('CREDIT CHOICE FINANCE (BRISBANE)', 'CREDIT CHOICE FINANCE (COBURG)', 'CREDIT CHOICE FINANCE (PERTH)', 'CREDIT CHOICE FINANCE (SOUTHPORT)', 'CREDIT CHOICE FINANCE (TOOWOOMBA)', 'CREDIT CHOICE FINANCE (TOWNSVILLE)') then 'CREDIT CHOICE FINANCE' when CMRBroker.cmr_name  in('CREDIT ONE (SOUTHPORT)') then 'CREDIT ONE' when CMRBroker.cmr_name  in('CAPITALCORP FINANCE AND LEASING (BRISBANE)', 'CAPITALCORP FINANCE AND LEASING (CAIRNS)') then 'CAPITALCORP' when CMRBroker.cmr_name  in('I NEED FINANCE NOW (BLACKTOWN)', 'I NEED FINANCE NOW (GOLD COAST)') then 'I NEED FINANCE NOW' when CMRBroker.cmr_name  in('MONEY NOW (BRAYBROOK)', 'MONEY NOW (BRISBANE)', 'MONEY NOW (CAIRNS)', 'MONEY NOW (MACKAY)', 'MONEY NOW (MINCHINBURY)','MONEY NOW (ROCKHAMPTON)', 'MONEY NOW (MT WAVERLEY)', 'MONEY NOW (NEWCASTLE)', 'MONEY NOW (PERTH)', 'REGIONAL CREDIT','MONEY NOW (RINGWOOD)') then 'MONEY NOW' when CMRBroker.cmr_name  in('NATIONAL FINANCE CHOICE (BRAYBROOK)', 'NATIONAL FINANCE CHOICE (MOORABBIN)', 'NATIONAL FINANCE CHOICE (MT WAVERLEY)', 'NATIONAL FINANCE CHOICE (WOODCROFT)') then 'NFC' when CMRBroker.cmr_name  in('STRATTON FINANCE (BAYSIDE BRISBANE)', 'STRATTON FINANCE (MELBOURNE)', 'STRATTON FINANCE (SOUTH EAST METRO AND HILLS)', 'STRATTON FINANCE (SYDNEY)') then 'STRATTON FINANCE' when CMRBroker.cmr_name  in('TANNASTER (CAMPBELLTOWN)', 'TANNASTER (CLAYTON)', 'TANNASTER (CRANBOURNE)', 'TANNASTER (FRANKSTON)', 'TANNASTER (GEELONG)','TANNASTER (GLENORCHY)', 'TANNASTER (LEASE CONVERSION)', 'TANNASTER (MELTON)', 'TANNASTER (MORPHETT VALE)', 'TANNASTER (NORTHCOTE)','TANNASTER (PFC DEVONPORT)', 'TANNASTER (PFC LAUNCESTON)', 'TANNASTER (PORT ADELAIDE)', 'TANNASTER (PRESTON)', 'TANNASTER (RESERVOIR)','TANNASTER (ROSNY PARK)', 'TANNASTER (SALISBURY)', 'TANNASTER (ST ALBANS)', 'TANNASTER (SUNSHINE)', 'TANNASTER (THOMASTOWN)','TANNASTER (DANDENONG)', 'TANNASTER (WEB CENTRE)', 'TANNASTER (WERRIBEE)', 'TANNASTER (WODONGA)', 'STAFF LOAN','TANNASTER (MICRO MOTOR)','TANNASTER (PFC HOBART)') then 'MONEY3' else CMRBroker.CMR_Name end) order by NAF DESC";
                    query = ReadSQLFile(TeamName.ToString() + " Brokers");
                    query = query.Replace("[TEAMNAME]", TeamName);
                    query = query.Replace(@"\\", @"\");
                    break;
                #endregion
                default:
                    query = "NotFound";
                    break;
            }

            return query;

        }
        #endregion

        #region IT Systems Query Defs

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


        public static string GetITQueryDef(string QueryName, string TeamName)
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
        #endregion

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //if (File.Exists(mndPath))
                //pbITDiagnostics.Visible = true;

            
            digitalClockCtrl.ForeColor = Color.Lime;
            Form1_Resize(null, null);

            //gpListView.Border.Color = Color.LightGray;
            //gpListView.Background.BackColor1 = Color.FromArgb(102, 102, 102);
            //gpListView.Background.BackColor2 = Color.FromArgb(42,42,42);
            //gpListView.Background.FillGradientStyle = System.Drawing.Drawing2D.LinearGradientMode.Vertical;


            CurrentTD.SideBar = true;
            CurrentTD.CheckOnClick = true;
        }

        private void cmdExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Form1_Resize(object sender, EventArgs e)
        {
            //int panelWidth = (this.Width - 36) / 2;
            //gpTeam.Width = panelWidth;
            //gpBroker.Width = panelWidth;
            //gpBroker.Left = gpTeam.Left + panelWidth + 12;


            int panelWidth = (this.Width - 253) ;
            //gpListView.Width = panelWidth;

            //Text = "w:" + this.Width.ToString() + " h:" + this.Height.ToString();
        }

        private void PositionGraphicsPanel()
        {
            //userControl11.Top = vmTarget.Top + vmTarget.Height + 10;
            //userControl11.Height = CurrentTD.Top - userControl11.Top - 10;

            userControl11.BringToFront();
            //userControl11.Top = 200;
            //userControl11.Height = this.Height - 200;
            //userControl11.Left = 0;
            //userControl11.Width = this.Width;

        }

        void animation_Started(object sender, StartAnimationEventArgs e)
        {
            this.UpdateUIState();
        }

        void animation_Stopped(object sender, StopAnimationEventArgs e)
        {
            this.UpdateUIState();

            //lbListView.Visible = true;

        }

        private void UpdateUIState()
        {
            if (this.InvokeRequired)
            {
                this.Invoke((MethodInvoker)delegate { this.UpdateUIState(); });
                return;
            }
            //this.buttonPause.Enabled = this.animation.Running;
            //if (this.animation.Running && this.animation.Paused)
            //    this.buttonPause.Text = "Un&pause";
            //else
            //    this.buttonPause.Text = "&Pause";
        }

        private Animation CreateAnimation()
        {
            if (this.animation != null)
            {
                this.animation.Stop();
                this.animation.Started -= new EventHandler<StartAnimationEventArgs>(animation_Started);
                this.animation.Stopped -= new EventHandler<StopAnimationEventArgs>(animation_Stopped);
            }

            this.controlWithAnimation = new AnimationAdapter(this.userControl11 );

            this.animation = this.controlWithAnimation.Animation;
            this.animation.Started += new EventHandler<StartAnimationEventArgs>(animation_Started);
            this.animation.Stopped += new EventHandler<StopAnimationEventArgs>(animation_Stopped);

            return this.animation;
        }

        private void RunSpinnerAnimation1()
        {
            this.animation = this.CreateAnimation();


            Sprite text = new TextSprite("Well Done", new Font("Tahoma", 20), Color.White, Color.LimeGreen, Color.LimeGreen, 3.0f);
            text.Opacity = 0.0f;
            text.FixedLocation = Locators.SpriteAligned(Corner.MiddleCenter);
            text.Add(900, 600, Effects.Fade(0.0f, 1.0f));
            text.Add(1000, 800, Effects.Rotate(180, 1440));
            text.Add(2000, 500, Effects.Scale(1.0f, 0.5f));
            text.Add(3500, 1000, Effects.Scale(0.5f, 4.0f));
            text.Add(3500, 1000, Effects.Fade(1.0f, 0.0f));
            this.animation.Add(0, text);

            TextSprite text2 = new TextSprite("Ring the Bell!", new Font("Tahoma", 24), Color.AliceBlue);
            text2.BackColor = Color.DarkSlateGray;
            text2.FixedLocation = Locators.SpriteAligned(Corner.TopCenter, new Point(20, 20));
            text2.Add(0, 300, Effects.Fade(0.0f, 1.0f));
            //text2.Add(900, 2700, Effects.TickerBoard("Interesting -- but useless"));
            this.animation.Add(0, text2);

            Sprite image = new ImageSprite(Properties.Resources.goldstar2);
            image.Add(0, 500, Effects.Move(Corner.BottomCenter, Corner.MiddleCenter));
            image.Add(0, 500, Effects.Rotate(0, 180));
            image.Add(500, 1500, Effects.Rotate(180, 720));
            image.Add(1000, 1000, Effects.Scale(1.0f, 4.0f));
            image.Add(1000, 1000, Effects.Goto(Corner.MiddleCenter));
            image.Add(1000, 1000, Effects.Fade(1.0f, 0.0f));
            this.animation.Add(0, image);


            this.animation.Start();
        }


        private void RunNoDataAnimation()
        {
            this.animation = this.CreateAnimation();


            Sprite text = new TextSprite("A Problem has occurred", new Font("Tahoma", 20), Color.White, Color.Red, Color.DarkRed, 3.0f);
            text.Opacity = 0.0f;
            text.FixedLocation = Locators.SpriteAligned(Corner.MiddleCenter);
            text.Add(900, 600, Effects.Fade(0.0f, 1.0f));
            text.Add(1000, 800, Effects.Rotate(180, 1440));
            text.Add(2000, 500, Effects.Scale(1.0f, 0.5f));
            text.Add(3500, 1000, Effects.Scale(0.5f, 4.0f));
            text.Add(3500, 1000, Effects.Fade(1.0f, 0.0f));
            this.animation.Add(0, text);

            TextSprite text2 = new TextSprite("Check Network Connectivity", new Font("Tahoma", 24), Color.AliceBlue);
            text2.BackColor = Color.DarkSlateGray;
            text2.FixedLocation = Locators.SpriteAligned(Corner.TopCenter, new Point(20, 20));
            text2.Add(0, 3000, Effects.Fade(0.0f, 1.0f));
            //text2.Add(900,5000, Effects.TickerBoard("will retry in 5 minutes..."));
            this.animation.Add(0, text2);

            
            Sprite image = new ImageSprite(Properties.Resources.red_monitor);
            image.Add(0, 500, Effects.Move(Corner.BottomCenter, Corner.MiddleCenter));
            image.Add(0, 500, Effects.Rotate(0, 180));
            image.Add(500, 1500, Effects.Rotate(180, 720));
            image.Add(1000, 1000, Effects.Scale(1.0f, 4.0f));
            image.Add(1000, 1000, Effects.Goto(Corner.MiddleCenter));
            image.Add(1000, 1000, Effects.Fade(1.0f, 0.0f));
            this.animation.Add(0, image);
            

            this.animation.Start();
        }

        private void tmrCountDown_Tick(object sender, EventArgs e)
        {
            _countDownValue = _countDownValue - 1000;
            lblCountDown.Text = "Page Refresh in " + (_countDownValue / 1000).ToString() + " seconds.";

        }

        private void lblCountDown_Click(object sender, EventArgs e)
        {
            ShowConfig();
        }

        BackgroundWorker dataWorker = new BackgroundWorker();
        private void bwDataLoader_DoWork(object sender, DoWorkEventArgs e)
        {
            while (!dataWorker.CancellationPending)
            {
                try
                {
                    UpdateDashboard();
                }
                catch (Exception ex)
                {
                    Debugger.Log(1, "test", "oops i've crashed" + ex);
                }
                Thread.Sleep(5 * 1000);
            }
        }

        private void lblMessage_Click(object sender, EventArgs e)
        {
            ShowConfig();
        }


        private void ShowConfig()
        {
            frmSettings settings = new frmSettings();
            settings.ShowDialog();
            settings = null;

            //Ensure we're using the currently selected TeamFile

            UpdateDashboard();
        }

        private void pbFullscreen_Click(object sender, EventArgs e)
        {
            if (IsFullScreen)
            {
                // set back to dialog mode
                _FullScreen.ShowFullScreen();
                pbFullscreen.Image = pbNoDialogScreen.Image; 
            }
            else
            {
                // set to fullscreen mode
                _FullScreen.ShowFullScreen();
                pbFullscreen.Image = pbDialogScreen.Image;
            }
            IsFullScreen = !IsFullScreen;
        }

        private void lbListView_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void timerErrorReset_Tick(object sender, EventArgs e)
        {
            timerErrorReset.Enabled = false;
            lblErrorMesg.Visible = false;
            lblErrorMesg.Text = "Ready";
        }

        private void pbSnapshot_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Do you want to take a snapshot of the screen?", "Please confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                //TakeScreenShot();
            }
        }

        ucITDiagnostics pnlITDiagnostics;
        private void pbITDiagnostics_Click(object sender, EventArgs e)
        {
            if(pnlITDiagnostics == null)
            {
                pnlITDiagnostics = new ucITDiagnostics();
                pnlITDiagnostics.Visible = false;
            
                //pnlITDiagnostics.Parent = this;
                pnlITDiagnostics.BringToFront();
                pnlITDiagnostics.Height = 35;
                pnlITDiagnostics.Top = (this.Height - pnlITDiagnostics.Height) / 2;
                pnlITDiagnostics.Left = this.Width + 30;
                pnlITDiagnostics.MNDFilePath = mndPath;

                this.Controls.Add(pnlITDiagnostics);
                this.Controls[pnlITDiagnostics.Name].BringToFront();
            }

            if (pnlITDiagnostics.Visible)
            {
                pnlITDiagnostics.Visible = false;
            }
            else
            {
                pnlITDiagnostics.Height = 35;
                pnlITDiagnostics.Left = this.Width;
                pnlITDiagnostics.Visible = true;
                timerShowITPanel.Enabled = true;
            }
            RunITDiagnostics();
            
        }

        private void RunITDiagnostics()
        {
            pnlITDiagnostics.RunITDashboard();
        }

        bool ItWidthDone = false;
        int itPanelHeight = 363;
        int itPanelWidth = 871;
        private void timerShowITPanel_Tick(object sender, EventArgs e)
        {
            pnlITDiagnostics.Width = itPanelWidth;

            if (pnlITDiagnostics.Left > (this.Width - pnlITDiagnostics.Width) / 2)
            {
                pnlITDiagnostics.Left -= 20;
            }
            else
            {
                pnlITDiagnostics.Width = itPanelWidth;
                pnlITDiagnostics.Left = (this.Width - pnlITDiagnostics.Width) / 2;
                ItWidthDone = true;
            }
            if (ItWidthDone)
            {
                if (pnlITDiagnostics.Height < itPanelHeight)
                {
                    pnlITDiagnostics.Height += 20;
                    pnlITDiagnostics.Top = (this.Height - pnlITDiagnostics.Height) / 2;
                }
                else
                    pnlITDiagnostics.Height = itPanelHeight;
            }

        }

        private void lblCloseITDiagnotics_Click(object sender, EventArgs e)
        {
            pnlITDiagnostics.Visible = false;
            ItWidthDone = false;
        }

        private void lblMessage_DoubleClick(object sender, EventArgs e)
        {

        }

        private static string ReadSQLFile(string sqlFileName)
        {
            string path = Application.StartupPath + @"\Queries\" + sqlFileName + ".sql";
            string readFileStrings = "";

            // This text is added only once to the file. 
            if (!File.Exists(path))
            {
                // Create a file to write to. 
                readFileStrings = "NODATA";
                return readFileStrings;
            }

            // Open the file to read from. 
            //string[] readText = File.ReadAllLines(path);

            //foreach (string s in readText)
            //{
            //    readFileStrings += s;
            //}

            readFileStrings = ReadAllText(path);

            //return RemoveLineEndings(readFileStrings);
            return readFileStrings;
        }

        public static string ReadAllText(string path)
        {
            if (path == null)
            {
                throw new ArgumentNullException("path");
            }
            if (path.Length == 0)
            {
                throw new ArgumentException("Argument_EmptyPath");
            }
            return InternalReadAllText(path, Encoding.UTF8);
        }

        private static string InternalReadAllText(string path, Encoding encoding)
        {
            string result;
            using (StreamReader streamReader = new StreamReader(path, encoding))
            {
                result = streamReader.ReadToEnd();
            }
            return result;
        }

        private static string RemoveLineEndings(string value)
        {
            if (String.IsNullOrEmpty(value))
            {
                return value;
            }
            string lineSeparator = ((char)0x2028).ToString();
            string paragraphSeparator = ((char)0x2029).ToString();

            return value.Replace("\r\n", " ").Replace("\n", " ").Replace("\r", " ").Replace(lineSeparator, " ").Replace(paragraphSeparator, " ");
        }
         
    }
}

