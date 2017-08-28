namespace LoanCenter
{
    partial class frmMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.lblMessage = new System.Windows.Forms.Label();
            this.lbListView = new System.Windows.Forms.ListView();
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader5 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader7 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lbListName = new System.Windows.Forms.Label();
            this.pbNoConnection = new System.Windows.Forms.PictureBox();
            this.tmrCountDown = new System.Windows.Forms.Timer(this.components);
            this.lblCountDown = new System.Windows.Forms.Label();
            this.bwDataLoader = new System.ComponentModel.BackgroundWorker();
            this.pbFullscreen = new System.Windows.Forms.PictureBox();
            this.pbNoDialogScreen = new System.Windows.Forms.PictureBox();
            this.pbDialogScreen = new System.Windows.Forms.PictureBox();
            this.lblErrorMesg = new System.Windows.Forms.Label();
            this.timerErrorReset = new System.Windows.Forms.Timer(this.components);
            this.pbSnapshot = new System.Windows.Forms.PictureBox();
            this.pbITDiagnostics = new System.Windows.Forms.PictureBox();
            this.timerShowITPanel = new System.Windows.Forms.Timer(this.components);
            this.vmCountTarget = new VistaMenuControl.VistaMenuControl();
            this.vmTarget = new VistaMenuControl.VistaMenuControl();
            this.CurrentTD = new VistaMenuControl.VistaMenuControl();
            this.digitalClockCtrl = new SriClocks.DigitalClockCtrl();
            this.circularProgressControl1 = new ProgressControl.CircularProgressControl();
            this.userControl11 = new LoanCenter.UserControl1();
            ((System.ComponentModel.ISupportInitialize)(this.pbNoConnection)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbFullscreen)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbNoDialogScreen)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbDialogScreen)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbSnapshot)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbITDiagnostics)).BeginInit();
            this.SuspendLayout();
            // 
            // timer1
            // 
            this.timer1.Enabled = true;
            this.timer1.Interval = 180000;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // lblMessage
            // 
            this.lblMessage.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblMessage.BackColor = System.Drawing.Color.Transparent;
            this.lblMessage.Font = new System.Drawing.Font("Arial", 30F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))));
            this.lblMessage.ForeColor = System.Drawing.Color.DimGray;
            this.lblMessage.Location = new System.Drawing.Point(661, 34);
            this.lblMessage.Name = "lblMessage";
            this.lblMessage.Size = new System.Drawing.Size(519, 55);
            this.lblMessage.TabIndex = 1;
            this.lblMessage.Text = "STATUS BOARD";
            this.lblMessage.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lblMessage.Click += new System.EventHandler(this.lblMessage_Click);
            this.lblMessage.DoubleClick += new System.EventHandler(this.lblMessage_DoubleClick);
            // 
            // lbListView
            // 
            this.lbListView.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lbListView.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.lbListView.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.lbListView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader4,
            this.columnHeader5,
            this.columnHeader7});
            this.lbListView.Font = new System.Drawing.Font("Segoe UI", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbListView.ForeColor = System.Drawing.SystemColors.Menu;
            this.lbListView.FullRowSelect = true;
            this.lbListView.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.None;
            this.lbListView.Location = new System.Drawing.Point(268, 96);
            this.lbListView.Name = "lbListView";
            this.lbListView.Size = new System.Drawing.Size(894, 547);
            this.lbListView.TabIndex = 2;
            this.lbListView.UseCompatibleStateImageBehavior = false;
            this.lbListView.View = System.Windows.Forms.View.Details;
            this.lbListView.SelectedIndexChanged += new System.EventHandler(this.lbListView_SelectedIndexChanged);
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "Broker";
            this.columnHeader4.Width = 542;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "#";
            this.columnHeader5.Width = 132;
            // 
            // columnHeader7
            // 
            this.columnHeader7.Text = "Fees";
            this.columnHeader7.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader7.Width = 207;
            // 
            // lbListName
            // 
            this.lbListName.AutoSize = true;
            this.lbListName.BackColor = System.Drawing.Color.Transparent;
            this.lbListName.Font = new System.Drawing.Font("Segoe UI", 32.25F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbListName.ForeColor = System.Drawing.Color.White;
            this.lbListName.Location = new System.Drawing.Point(268, 34);
            this.lbListName.Name = "lbListName";
            this.lbListName.Size = new System.Drawing.Size(345, 59);
            this.lbListName.TabIndex = 1;
            this.lbListName.Text = "BROKERS Loans";
            // 
            // pbNoConnection
            // 
            this.pbNoConnection.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.pbNoConnection.Image = ((System.Drawing.Image)(resources.GetObject("pbNoConnection.Image")));
            this.pbNoConnection.Location = new System.Drawing.Point(454, 253);
            this.pbNoConnection.Name = "pbNoConnection";
            this.pbNoConnection.Size = new System.Drawing.Size(254, 260);
            this.pbNoConnection.TabIndex = 19;
            this.pbNoConnection.TabStop = false;
            this.pbNoConnection.Visible = false;
            // 
            // tmrCountDown
            // 
            this.tmrCountDown.Enabled = true;
            this.tmrCountDown.Interval = 1000;
            this.tmrCountDown.Tick += new System.EventHandler(this.tmrCountDown_Tick);
            // 
            // lblCountDown
            // 
            this.lblCountDown.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.lblCountDown.BackColor = System.Drawing.Color.Transparent;
            this.lblCountDown.Font = new System.Drawing.Font("Arial", 12F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCountDown.ForeColor = System.Drawing.Color.DimGray;
            this.lblCountDown.Location = new System.Drawing.Point(837, 712);
            this.lblCountDown.Name = "lblCountDown";
            this.lblCountDown.Size = new System.Drawing.Size(287, 25);
            this.lblCountDown.TabIndex = 20;
            this.lblCountDown.Text = "Page refresh in 0 seconds.";
            this.lblCountDown.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lblCountDown.Click += new System.EventHandler(this.lblCountDown_Click);
            // 
            // bwDataLoader
            // 
            this.bwDataLoader.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwDataLoader_DoWork);
            // 
            // pbFullscreen
            // 
            this.pbFullscreen.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.pbFullscreen.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.pbFullscreen.Image = ((System.Drawing.Image)(resources.GetObject("pbFullscreen.Image")));
            this.pbFullscreen.Location = new System.Drawing.Point(1096, 679);
            this.pbFullscreen.Name = "pbFullscreen";
            this.pbFullscreen.Size = new System.Drawing.Size(18, 21);
            this.pbFullscreen.TabIndex = 22;
            this.pbFullscreen.TabStop = false;
            this.pbFullscreen.Visible = false;
            this.pbFullscreen.Click += new System.EventHandler(this.pbFullscreen_Click);
            // 
            // pbNoDialogScreen
            // 
            this.pbNoDialogScreen.Image = ((System.Drawing.Image)(resources.GetObject("pbNoDialogScreen.Image")));
            this.pbNoDialogScreen.Location = new System.Drawing.Point(1144, 679);
            this.pbNoDialogScreen.Name = "pbNoDialogScreen";
            this.pbNoDialogScreen.Size = new System.Drawing.Size(18, 21);
            this.pbNoDialogScreen.TabIndex = 23;
            this.pbNoDialogScreen.TabStop = false;
            this.pbNoDialogScreen.Visible = false;
            // 
            // pbDialogScreen
            // 
            this.pbDialogScreen.Image = ((System.Drawing.Image)(resources.GetObject("pbDialogScreen.Image")));
            this.pbDialogScreen.Location = new System.Drawing.Point(1120, 679);
            this.pbDialogScreen.Name = "pbDialogScreen";
            this.pbDialogScreen.Size = new System.Drawing.Size(18, 21);
            this.pbDialogScreen.TabIndex = 24;
            this.pbDialogScreen.TabStop = false;
            this.pbDialogScreen.Visible = false;
            // 
            // lblErrorMesg
            // 
            this.lblErrorMesg.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.lblErrorMesg.BackColor = System.Drawing.Color.Transparent;
            this.lblErrorMesg.Font = new System.Drawing.Font("Arial Narrow", 12F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblErrorMesg.ForeColor = System.Drawing.Color.White;
            this.lblErrorMesg.Location = new System.Drawing.Point(665, 712);
            this.lblErrorMesg.Name = "lblErrorMesg";
            this.lblErrorMesg.Size = new System.Drawing.Size(214, 25);
            this.lblErrorMesg.TabIndex = 26;
            this.lblErrorMesg.Text = "Page refresh in 0 seconds.";
            this.lblErrorMesg.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.lblErrorMesg.Visible = false;
            // 
            // timerErrorReset
            // 
            this.timerErrorReset.Interval = 10000;
            this.timerErrorReset.Tick += new System.EventHandler(this.timerErrorReset_Tick);
            // 
            // pbSnapshot
            // 
            this.pbSnapshot.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.pbSnapshot.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.pbSnapshot.Image = ((System.Drawing.Image)(resources.GetObject("pbSnapshot.Image")));
            this.pbSnapshot.Location = new System.Drawing.Point(1132, 718);
            this.pbSnapshot.Name = "pbSnapshot";
            this.pbSnapshot.Size = new System.Drawing.Size(16, 16);
            this.pbSnapshot.TabIndex = 27;
            this.pbSnapshot.TabStop = false;
            this.pbSnapshot.Visible = false;
            this.pbSnapshot.Click += new System.EventHandler(this.pbSnapshot_Click);
            // 
            // pbITDiagnostics
            // 
            this.pbITDiagnostics.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.pbITDiagnostics.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.pbITDiagnostics.Image = ((System.Drawing.Image)(resources.GetObject("pbITDiagnostics.Image")));
            this.pbITDiagnostics.Location = new System.Drawing.Point(1154, 718);
            this.pbITDiagnostics.Name = "pbITDiagnostics";
            this.pbITDiagnostics.Size = new System.Drawing.Size(16, 16);
            this.pbITDiagnostics.TabIndex = 28;
            this.pbITDiagnostics.TabStop = false;
            this.pbITDiagnostics.Visible = false;
            this.pbITDiagnostics.Click += new System.EventHandler(this.pbITDiagnostics_Click);
            // 
            // timerShowITPanel
            // 
            this.timerShowITPanel.Interval = 16;
            this.timerShowITPanel.Tick += new System.EventHandler(this.timerShowITPanel_Tick);
            // 
            // vmCountTarget
            // 
            this.vmCountTarget.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.vmCountTarget.BackImageAlign = System.Drawing.ContentAlignment.TopRight;
            this.vmCountTarget.BackMenuImage = null;
            this.vmCountTarget.CheckOnClick = false;
            this.vmCountTarget.FlatSeparators = false;
            this.vmCountTarget.FlatSeparatorsColor = System.Drawing.Color.Silver;
            this.vmCountTarget.ItemHeight = 100;
            this.vmCountTarget.ItemWidth = 150;
            this.vmCountTarget.Location = new System.Drawing.Point(6, 185);
            this.vmCountTarget.MaximumSize = new System.Drawing.Size(300, 400);
            this.vmCountTarget.MenuEndColor = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.vmCountTarget.MenuInnerBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(158)))), ((int)(((byte)(158)))), ((int)(((byte)(158)))));
            this.vmCountTarget.MenuOrientation = VistaMenuControl.VistaMenuControl.VistaMenuOrientation.Vertical;
            this.vmCountTarget.MenuOuterBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(29)))), ((int)(((byte)(29)))), ((int)(((byte)(29)))));
            this.vmCountTarget.MenuStartColor = System.Drawing.Color.FromArgb(((int)(((byte)(102)))), ((int)(((byte)(102)))), ((int)(((byte)(102)))));
            this.vmCountTarget.MinimumSize = new System.Drawing.Size(100, 46);
            this.vmCountTarget.Name = "vmCountTarget";
            this.vmCountTarget.RenderSeparators = true;
            this.vmCountTarget.SelectedItem = -1;
            this.vmCountTarget.SideBar = false;
            this.vmCountTarget.SideBarBitmap = null;
            this.vmCountTarget.SideBarCaption = "Current Position";
            this.vmCountTarget.SideBarEndGradient = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.vmCountTarget.SideBarFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vmCountTarget.SideBarFontColor = System.Drawing.Color.White;
            this.vmCountTarget.SideBarStartGradient = System.Drawing.Color.FromArgb(((int)(((byte)(142)))), ((int)(((byte)(142)))), ((int)(((byte)(142)))));
            this.vmCountTarget.Size = new System.Drawing.Size(256, 92);
            this.vmCountTarget.TabIndex = 21;
            this.vmCountTarget.Visible = false;
            // 
            // vmTarget
            // 
            this.vmTarget.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.vmTarget.BackImageAlign = System.Drawing.ContentAlignment.TopRight;
            this.vmTarget.BackMenuImage = null;
            this.vmTarget.CheckOnClick = false;
            this.vmTarget.FlatSeparators = false;
            this.vmTarget.FlatSeparatorsColor = System.Drawing.Color.Silver;
            this.vmTarget.ItemHeight = 100;
            this.vmTarget.ItemWidth = 150;
            this.vmTarget.Location = new System.Drawing.Point(6, 34);
            this.vmTarget.MaximumSize = new System.Drawing.Size(300, 400);
            this.vmTarget.MenuEndColor = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.vmTarget.MenuInnerBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(158)))), ((int)(((byte)(158)))), ((int)(((byte)(158)))));
            this.vmTarget.MenuOrientation = VistaMenuControl.VistaMenuControl.VistaMenuOrientation.Vertical;
            this.vmTarget.MenuOuterBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(29)))), ((int)(((byte)(29)))), ((int)(((byte)(29)))));
            this.vmTarget.MenuStartColor = System.Drawing.Color.FromArgb(((int)(((byte)(102)))), ((int)(((byte)(102)))), ((int)(((byte)(102)))));
            this.vmTarget.MinimumSize = new System.Drawing.Size(100, 46);
            this.vmTarget.Name = "vmTarget";
            this.vmTarget.RenderSeparators = true;
            this.vmTarget.SelectedItem = -1;
            this.vmTarget.SideBar = false;
            this.vmTarget.SideBarBitmap = null;
            this.vmTarget.SideBarCaption = "Current Position";
            this.vmTarget.SideBarEndGradient = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.vmTarget.SideBarFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.vmTarget.SideBarFontColor = System.Drawing.Color.White;
            this.vmTarget.SideBarStartGradient = System.Drawing.Color.FromArgb(((int)(((byte)(142)))), ((int)(((byte)(142)))), ((int)(((byte)(142)))));
            this.vmTarget.Size = new System.Drawing.Size(256, 145);
            this.vmTarget.TabIndex = 15;
            this.vmTarget.Visible = false;
            // 
            // CurrentTD
            // 
            this.CurrentTD.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.CurrentTD.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(34)))), ((int)(((byte)(34)))), ((int)(((byte)(34)))));
            this.CurrentTD.BackImageAlign = System.Drawing.ContentAlignment.TopRight;
            this.CurrentTD.BackMenuImage = null;
            this.CurrentTD.CheckOnClick = false;
            this.CurrentTD.FlatSeparators = false;
            this.CurrentTD.FlatSeparatorsColor = System.Drawing.Color.Silver;
            this.CurrentTD.ItemHeight = 60;
            this.CurrentTD.ItemWidth = 300;
            this.CurrentTD.Location = new System.Drawing.Point(287, 646);
            this.CurrentTD.MaximumSize = new System.Drawing.Size(300, 400);
            this.CurrentTD.MenuEndColor = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.CurrentTD.MenuInnerBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(158)))), ((int)(((byte)(158)))), ((int)(((byte)(158)))));
            this.CurrentTD.MenuOrientation = VistaMenuControl.VistaMenuControl.VistaMenuOrientation.Horizontal;
            this.CurrentTD.MenuOuterBorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(29)))), ((int)(((byte)(29)))), ((int)(((byte)(29)))));
            this.CurrentTD.MenuStartColor = System.Drawing.Color.FromArgb(((int)(((byte)(102)))), ((int)(((byte)(102)))), ((int)(((byte)(102)))));
            this.CurrentTD.MinimumSize = new System.Drawing.Size(100, 46);
            this.CurrentTD.Name = "CurrentTD";
            this.CurrentTD.RenderSeparators = true;
            this.CurrentTD.SelectedItem = -1;
            this.CurrentTD.SideBar = false;
            this.CurrentTD.SideBarBitmap = null;
            this.CurrentTD.SideBarCaption = "Current Position";
            this.CurrentTD.SideBarEndGradient = System.Drawing.Color.FromArgb(((int)(((byte)(42)))), ((int)(((byte)(42)))), ((int)(((byte)(42)))));
            this.CurrentTD.SideBarFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.CurrentTD.SideBarFontColor = System.Drawing.Color.White;
            this.CurrentTD.SideBarStartGradient = System.Drawing.Color.FromArgb(((int)(((byte)(142)))), ((int)(((byte)(142)))), ((int)(((byte)(142)))));
            this.CurrentTD.Size = new System.Drawing.Size(300, 66);
            this.CurrentTD.TabIndex = 11;
            this.CurrentTD.Visible = false;
            // 
            // digitalClockCtrl
            // 
            this.digitalClockCtrl.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.digitalClockCtrl.BackColor = System.Drawing.Color.Black;
            this.digitalClockCtrl.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.digitalClockCtrl.CountDownTime = 10000;
            this.digitalClockCtrl.Location = new System.Drawing.Point(7, 646);
            this.digitalClockCtrl.Name = "digitalClockCtrl";
            this.digitalClockCtrl.SetClockType = SriClocks.ClockType.DigitalClock;
            this.digitalClockCtrl.Size = new System.Drawing.Size(256, 66);
            this.digitalClockCtrl.TabIndex = 25;
            // 
            // circularProgressControl1
            // 
            this.circularProgressControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.circularProgressControl1.BackColor = System.Drawing.Color.Transparent;
            this.circularProgressControl1.Interval = 120;
            this.circularProgressControl1.Location = new System.Drawing.Point(353, 149);
            this.circularProgressControl1.MinimumSize = new System.Drawing.Size(28, 28);
            this.circularProgressControl1.Name = "circularProgressControl1";
            this.circularProgressControl1.Rotation = ProgressControl.CircularProgressControl.Direction.CLOCKWISE;
            this.circularProgressControl1.Size = new System.Drawing.Size(459, 459);
            this.circularProgressControl1.StartAngle = 270;
            this.circularProgressControl1.TabIndex = 17;
            this.circularProgressControl1.TickColor = System.Drawing.Color.LawnGreen;
            this.circularProgressControl1.UseWaitCursor = true;
            this.circularProgressControl1.Visible = false;
            // 
            // userControl11
            // 
            this.userControl11.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.userControl11.BackColor = System.Drawing.Color.Transparent;
            this.userControl11.Location = new System.Drawing.Point(278, 90);
            this.userControl11.Name = "userControl11";
            this.userControl11.Size = new System.Drawing.Size(786, 553);
            this.userControl11.TabIndex = 18;
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1181, 742);
            this.Controls.Add(this.lblErrorMesg);
            this.Controls.Add(this.pbITDiagnostics);
            this.Controls.Add(this.pbSnapshot);
            this.Controls.Add(this.pbDialogScreen);
            this.Controls.Add(this.pbNoDialogScreen);
            this.Controls.Add(this.pbFullscreen);
            this.Controls.Add(this.vmCountTarget);
            this.Controls.Add(this.pbNoConnection);
            this.Controls.Add(this.lbListName);
            this.Controls.Add(this.vmTarget);
            this.Controls.Add(this.CurrentTD);
            this.Controls.Add(this.digitalClockCtrl);
            this.Controls.Add(this.lblCountDown);
            this.Controls.Add(this.lblMessage);
            this.Controls.Add(this.circularProgressControl1);
            this.Controls.Add(this.lbListView);
            this.Controls.Add(this.userControl11);
            this.Cursor = System.Windows.Forms.Cursors.Default;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(1181, 726);
            this.Name = "frmMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Web Center Status Board";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.Form1_Load);
            this.Resize += new System.EventHandler(this.Form1_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.pbNoConnection)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbFullscreen)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbNoDialogScreen)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbDialogScreen)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbSnapshot)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbITDiagnostics)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Label lblMessage;
        private VistaMenuControl.VistaMenuControl CurrentTD;
        private System.Windows.Forms.ListView lbListView;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.ColumnHeader columnHeader7;
        private VistaMenuControl.VistaMenuControl vmTarget;
        private ProgressControl.CircularProgressControl circularProgressControl1;
        private System.Windows.Forms.Label lbListName;
        private UserControl1 userControl11;
        private System.Windows.Forms.PictureBox pbNoConnection;
        private System.Windows.Forms.Timer tmrCountDown;
        private System.Windows.Forms.Label lblCountDown;
        private VistaMenuControl.VistaMenuControl vmCountTarget;
        private System.ComponentModel.BackgroundWorker bwDataLoader;
        private System.Windows.Forms.PictureBox pbFullscreen;
        private System.Windows.Forms.PictureBox pbNoDialogScreen;
        private System.Windows.Forms.PictureBox pbDialogScreen;
        private SriClocks.DigitalClockCtrl digitalClockCtrl;
        private System.Windows.Forms.Label lblErrorMesg;
        private System.Windows.Forms.Timer timerErrorReset;
        private System.Windows.Forms.PictureBox pbSnapshot;
        private System.Windows.Forms.PictureBox pbITDiagnostics;
        private System.Windows.Forms.Timer timerShowITPanel;
    }
}

