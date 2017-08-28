using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using StatusBoard.Tools;

namespace LoanCenter
{
    public partial class frmSettings : Form
    {
        IniReader ini = new IniReader(Application.StartupPath + @"\Dashboard.ini");
        private string[] strDashboards;

        private string sTeam = "Unspecified";
        private string sTeamFile = "Unspecified.ini";

        public frmSettings()
        {
            InitializeComponent();


        }

        private void cmdOK_Click(object sender, EventArgs e)
        {
            ApplyChanges();
            this.Close();

        }

        private void cmdCancel_Click(object sender, EventArgs e)
        {
            this.Close();

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void tabTeamMemberTargets_Click(object sender, EventArgs e)
        {

        }



        private void SaveTeamMember(string teamMember, int individualTarget)
        {
            ini.Write(sTeam + "-TeamMemberTargets", teamMember,individualTarget);
        }

        private void DeleteTeamMember(string teamMember)
        {
            ini.DeleteKey(teamMember);
        }

        private void btnSaveTeamMemberRecord_Click(object sender, EventArgs e)
        {
            if (txtTeamMemberName.Text.Length > 0 || txtIndividualTarget.Text.Length > 0)
            {
                txtTeamMemberName.BorderStyle = BorderStyle.None;
                txtIndividualTarget.BorderStyle = BorderStyle.None;
                SaveTeamMember(txtTeamMemberName.Text, Convert.ToInt16(txtIndividualTarget.Text));
                btnSaveTeamMemberRecord.Visible = false;
                LoadList();
            }
        }

        private void cmdNewTeamMember_Click(object sender, EventArgs e)
        {
            txtTeamMemberName.BorderStyle = BorderStyle.FixedSingle;
            txtIndividualTarget.BorderStyle = BorderStyle.FixedSingle;
            btnSaveTeamMemberRecord.Visible = true;

        }

        private void btnEditTeamMember_Click(object sender, EventArgs e)
        {
            try
            {
                if (lstTeamMembers.SelectedItem.ToString().Length > 0)
                {
                    txtTeamMemberName.Text = lstTeamMembers.SelectedItem.ToString();
                    txtTeamMemberName.BorderStyle = BorderStyle.FixedSingle;
                    txtIndividualTarget.Text = ini.ReadInteger(lstTeamMembers.SelectedItem.ToString()).ToString();
                    txtIndividualTarget.BorderStyle = BorderStyle.FixedSingle;
                    btnSaveTeamMemberRecord.Visible = true;
                }
            }
            catch { }
        }

        private void btnDeleteTeamMember_Click(object sender, EventArgs e)
        {
            if (lstTeamMembers.SelectedIndex > 0)
            {
                DialogResult result = (MessageBox.Show("Really Delete '" +lstTeamMembers.SelectedItem.ToString()+ "'","",MessageBoxButtons.YesNoCancel,MessageBoxIcon.Question));
                if (result == System.Windows.Forms.DialogResult.Yes)
                {
                    DeleteTeamMember(lstTeamMembers.SelectedItem.ToString());
                }
                else if (result == System.Windows.Forms.DialogResult.No)
                {
                
                }
                else
                {
                
                }

            }
            LoadList();

        }

        private string[] sSelectedTeamMember;
        private void LoadList()
        {
            string[] strArray = ini.GetAllKeysInIniFileSection(sTeam + "-TeamMemberTargets", Application.StartupPath + @"\Dashboard.ini");

            lstTeamMembers.Items.Clear();

            
            for (int i = 0; i < strArray.Length; i++)
            {
                sSelectedTeamMember = strArray[i].Split('=');
                lstTeamMembers.Items.Add(sSelectedTeamMember[0].ToString());
            }

            // load the team targets
            txtDollarTarget.Text = ini.ReadInteger(sTeam + "-TeamTargets", "DollarTarget", 100000).ToString();
            txtVolumeTarget.Text = ini.ReadInteger(sTeam + "-TeamTargets", "VolumeTarget", 100000).ToString();



        }

        private void frmSettings_Load(object sender, EventArgs e)
        {
            // load the dashboard list
            string sActiveDashboard = ini.ReadString("ActiveDashboard", "Name", "Unspecified");
            strDashboards = ini.GetAllKeysInIniFileSection("Dashboards", Application.StartupPath + @"\Dashboard.ini");

            cboActiveDashboard.Items.Clear();

            string[] sSelectedDashboard;
            for (int i = 0; i < strDashboards.Length; i++)
            {
                sSelectedDashboard = strDashboards[i].Split('=');
                cboActiveDashboard.Items.Add(sSelectedDashboard[0].ToString());
                //sActiveDashboard = sSelectedDashboard[1].ToString();
            }


            //ini = new IniReader(Application.StartupPath + @"\" + sActiveDashboard);
            sTeam = ini.ReadString("ActiveDashboard", "Name", "Unspecified");
            txtTeamName.Text = sTeam;
            lblImagePath.Text = ini.ReadString("General", "ImagePath", lblImagePath.Text);
            LoadList();
        }

        private void frmSettings_FormClosing(object sender, FormClosingEventArgs e)
        {
            ini = null;
        }

        private void lstTeamMembers_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                txtTeamMemberName.Text = lstTeamMembers.SelectedItem.ToString();
                txtIndividualTarget.Text = ini.ReadInteger("TeamMembers",lstTeamMembers.SelectedItem.ToString(),10).ToString();

                string[] sSelectedDashboard;
                for (int i = 0; i < strDashboards.Length; i++)
                {
                    sSelectedDashboard = strDashboards[i].Split('=');
                    //if (cboActiveDashboard.Text == sSelectedDashboard[0].ToString())
                    //    sActiveDashboard = sSelectedDashboard[1].ToString();
                }
            }
            catch{}
        }

        private void cmdApply_Click(object sender, EventArgs e)
        {
            ApplyChanges();
        }

        private void ApplyChanges()
        {
            ini.Write("TeamTargets", "DollarTarget", txtDollarTarget.Text);
            ini.Write("TeamTargets", "VolumeTarget", txtVolumeTarget.Text);
            //ini.Write("General", "ImagePath", lblImagePath.Text + @"\" + sTeam + ".jpg");
            ini.Write("Team", "Name", txtTeamName.Text);
        }

        private void folderBrowserDialog1_HelpRequest(object sender, EventArgs e)
        {

        }

        private void btnSetImagePath_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderDlg = new FolderBrowserDialog();

            folderDlg.ShowNewFolderButton = true;

            // Show the FolderBrowserDialog.

            DialogResult result = folderDlg.ShowDialog();

            if (result == DialogResult.OK)
            {

                lblImagePath.Text = folderDlg.SelectedPath + @"\" + sTeam + ".jpg";
                ini.Write("General", "ImagePath", lblImagePath.Text );
                Environment.SpecialFolder root = folderDlg.RootFolder;

            } 
        }

        private void btnSaveActiveDashboard_Click(object sender, EventArgs e)
        {
            
            ini.Write("ActiveDashboard", "Name", cboActiveDashboard.Text);
            btnSaveActiveDashboard.Enabled = false;
            sTeam = cboActiveDashboard.Text;

            string[] sSelectedDashboard;
            for (int i = 0; i < strDashboards.Length; i++)
            {
                sSelectedDashboard = strDashboards[i].Split('=');
                if (cboActiveDashboard.Text == sSelectedDashboard[0].ToString())
                    sTeamFile = sSelectedDashboard[1].ToString();
            }
            txtTeamName.Text = sTeam;
        }

        private void cboActiveDashboard_SelectedIndexChanged(object sender, EventArgs e)
        {
            btnSaveActiveDashboard.Enabled = true;

        }
    }
}
