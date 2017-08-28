namespace LoanCenter
{
    partial class frmSettings
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
            this.cmdCancel = new System.Windows.Forms.Button();
            this.cmdApply = new System.Windows.Forms.Button();
            this.cmdOK = new System.Windows.Forms.Button();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabTeamTargets = new System.Windows.Forms.TabPage();
            this.txtTeamName = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.btnSetImagePath = new System.Windows.Forms.Button();
            this.lblImagePath = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.txtVolumeTarget = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtDollarTarget = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.tabTeamMemberTargets = new System.Windows.Forms.TabPage();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.lstTeamMembers = new System.Windows.Forms.ListBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnSaveTeamMemberRecord = new System.Windows.Forms.Button();
            this.txtTeamMemberName = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.txtIndividualTarget = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.btnDeleteTeamMember = new System.Windows.Forms.Button();
            this.btnEditTeamMember = new System.Windows.Forms.Button();
            this.cmdNewTeamMember = new System.Windows.Forms.Button();
            this.tabDashboard = new System.Windows.Forms.TabPage();
            this.btnSaveActiveDashboard = new System.Windows.Forms.Button();
            this.cboActiveDashboard = new System.Windows.Forms.ComboBox();
            this.label9 = new System.Windows.Forms.Label();
            this.tabControl1.SuspendLayout();
            this.tabTeamTargets.SuspendLayout();
            this.tabTeamMemberTargets.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.tabDashboard.SuspendLayout();
            this.SuspendLayout();
            // 
            // cmdCancel
            // 
            this.cmdCancel.Location = new System.Drawing.Point(174, 339);
            this.cmdCancel.Name = "cmdCancel";
            this.cmdCancel.Size = new System.Drawing.Size(75, 23);
            this.cmdCancel.TabIndex = 1;
            this.cmdCancel.Text = "&Cancel";
            this.cmdCancel.UseVisualStyleBackColor = true;
            this.cmdCancel.Click += new System.EventHandler(this.cmdCancel_Click);
            // 
            // cmdApply
            // 
            this.cmdApply.Location = new System.Drawing.Point(255, 339);
            this.cmdApply.Name = "cmdApply";
            this.cmdApply.Size = new System.Drawing.Size(75, 23);
            this.cmdApply.TabIndex = 2;
            this.cmdApply.Text = "&Apply";
            this.cmdApply.UseVisualStyleBackColor = true;
            this.cmdApply.Click += new System.EventHandler(this.cmdApply_Click);
            // 
            // cmdOK
            // 
            this.cmdOK.Location = new System.Drawing.Point(336, 339);
            this.cmdOK.Name = "cmdOK";
            this.cmdOK.Size = new System.Drawing.Size(75, 23);
            this.cmdOK.TabIndex = 3;
            this.cmdOK.Text = "&OK";
            this.cmdOK.UseVisualStyleBackColor = true;
            this.cmdOK.Click += new System.EventHandler(this.cmdOK_Click);
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabTeamTargets);
            this.tabControl1.Controls.Add(this.tabTeamMemberTargets);
            this.tabControl1.Controls.Add(this.tabDashboard);
            this.tabControl1.Location = new System.Drawing.Point(12, 12);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(401, 319);
            this.tabControl1.TabIndex = 4;
            // 
            // tabTeamTargets
            // 
            this.tabTeamTargets.Controls.Add(this.txtTeamName);
            this.tabTeamTargets.Controls.Add(this.label8);
            this.tabTeamTargets.Controls.Add(this.btnSetImagePath);
            this.tabTeamTargets.Controls.Add(this.lblImagePath);
            this.tabTeamTargets.Controls.Add(this.label5);
            this.tabTeamTargets.Controls.Add(this.label4);
            this.tabTeamTargets.Controls.Add(this.label3);
            this.tabTeamTargets.Controls.Add(this.txtVolumeTarget);
            this.tabTeamTargets.Controls.Add(this.label2);
            this.tabTeamTargets.Controls.Add(this.txtDollarTarget);
            this.tabTeamTargets.Controls.Add(this.label1);
            this.tabTeamTargets.Location = new System.Drawing.Point(4, 22);
            this.tabTeamTargets.Name = "tabTeamTargets";
            this.tabTeamTargets.Padding = new System.Windows.Forms.Padding(3);
            this.tabTeamTargets.Size = new System.Drawing.Size(393, 293);
            this.tabTeamTargets.TabIndex = 1;
            this.tabTeamTargets.Text = "General";
            this.tabTeamTargets.UseVisualStyleBackColor = true;
            // 
            // txtTeamName
            // 
            this.txtTeamName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtTeamName.Location = new System.Drawing.Point(118, 70);
            this.txtTeamName.Name = "txtTeamName";
            this.txtTeamName.Size = new System.Drawing.Size(252, 20);
            this.txtTeamName.TabIndex = 10;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(8, 73);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(68, 13);
            this.label8.TabIndex = 9;
            this.label8.Text = "Team Name:";
            // 
            // btnSetImagePath
            // 
            this.btnSetImagePath.Location = new System.Drawing.Point(118, 185);
            this.btnSetImagePath.Name = "btnSetImagePath";
            this.btnSetImagePath.Size = new System.Drawing.Size(26, 23);
            this.btnSetImagePath.TabIndex = 8;
            this.btnSetImagePath.Text = "...";
            this.btnSetImagePath.UseVisualStyleBackColor = true;
            this.btnSetImagePath.Click += new System.EventHandler(this.btnSetImagePath_Click);
            // 
            // lblImagePath
            // 
            this.lblImagePath.Location = new System.Drawing.Point(150, 190);
            this.lblImagePath.Name = "lblImagePath";
            this.lblImagePath.Size = new System.Drawing.Size(238, 51);
            this.lblImagePath.TabIndex = 7;
            this.lblImagePath.Text = "c:\\";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(8, 190);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(109, 13);
            this.label5.TabIndex = 6;
            this.label5.Text = "Save Screenshots to:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(102, 121);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(13, 13);
            this.label4.TabIndex = 5;
            this.label4.Text = "$";
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(7, 18);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(363, 31);
            this.label3.TabIndex = 4;
            this.label3.Text = "Set the Team Targets for the Dashboard to be able to display progress and complet" +
    "ion of Targeted Goals.";
            // 
            // txtVolumeTarget
            // 
            this.txtVolumeTarget.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtVolumeTarget.Location = new System.Drawing.Point(118, 144);
            this.txtVolumeTarget.Name = "txtVolumeTarget";
            this.txtVolumeTarget.Size = new System.Drawing.Size(43, 20);
            this.txtVolumeTarget.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(8, 147);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(79, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Volume Target:";
            // 
            // txtDollarTarget
            // 
            this.txtDollarTarget.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtDollarTarget.Location = new System.Drawing.Point(118, 118);
            this.txtDollarTarget.Name = "txtDollarTarget";
            this.txtDollarTarget.Size = new System.Drawing.Size(100, 20);
            this.txtDollarTarget.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(8, 121);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(71, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Dollar Target:";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // tabTeamMemberTargets
            // 
            this.tabTeamMemberTargets.Controls.Add(this.groupBox2);
            this.tabTeamMemberTargets.Controls.Add(this.btnDeleteTeamMember);
            this.tabTeamMemberTargets.Controls.Add(this.btnEditTeamMember);
            this.tabTeamMemberTargets.Controls.Add(this.cmdNewTeamMember);
            this.tabTeamMemberTargets.Location = new System.Drawing.Point(4, 22);
            this.tabTeamMemberTargets.Name = "tabTeamMemberTargets";
            this.tabTeamMemberTargets.Padding = new System.Windows.Forms.Padding(3);
            this.tabTeamMemberTargets.Size = new System.Drawing.Size(393, 293);
            this.tabTeamMemberTargets.TabIndex = 0;
            this.tabTeamMemberTargets.Text = "Team Member Targets";
            this.tabTeamMemberTargets.UseVisualStyleBackColor = true;
            this.tabTeamMemberTargets.Click += new System.EventHandler(this.tabTeamMemberTargets_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.lstTeamMembers);
            this.groupBox2.Controls.Add(this.groupBox1);
            this.groupBox2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox2.Location = new System.Drawing.Point(6, 6);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(297, 281);
            this.groupBox2.TabIndex = 12;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Team Members";
            // 
            // lstTeamMembers
            // 
            this.lstTeamMembers.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.lstTeamMembers.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lstTeamMembers.FormattingEnabled = true;
            this.lstTeamMembers.Location = new System.Drawing.Point(10, 19);
            this.lstTeamMembers.Name = "lstTeamMembers";
            this.lstTeamMembers.Size = new System.Drawing.Size(281, 156);
            this.lstTeamMembers.TabIndex = 0;
            this.lstTeamMembers.SelectedIndexChanged += new System.EventHandler(this.lstTeamMembers_SelectedIndexChanged);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnSaveTeamMemberRecord);
            this.groupBox1.Controls.Add(this.txtTeamMemberName);
            this.groupBox1.Controls.Add(this.label6);
            this.groupBox1.Controls.Add(this.txtIndividualTarget);
            this.groupBox1.Controls.Add(this.label7);
            this.groupBox1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.groupBox1.Location = new System.Drawing.Point(0, 180);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(297, 100);
            this.groupBox1.TabIndex = 11;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Team Member Details";
            // 
            // btnSaveTeamMemberRecord
            // 
            this.btnSaveTeamMemberRecord.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSaveTeamMemberRecord.Location = new System.Drawing.Point(211, 66);
            this.btnSaveTeamMemberRecord.Name = "btnSaveTeamMemberRecord";
            this.btnSaveTeamMemberRecord.Size = new System.Drawing.Size(75, 23);
            this.btnSaveTeamMemberRecord.TabIndex = 8;
            this.btnSaveTeamMemberRecord.Text = "&Save";
            this.btnSaveTeamMemberRecord.UseVisualStyleBackColor = true;
            this.btnSaveTeamMemberRecord.Visible = false;
            this.btnSaveTeamMemberRecord.Click += new System.EventHandler(this.btnSaveTeamMemberRecord_Click);
            // 
            // txtTeamMemberName
            // 
            this.txtTeamMemberName.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtTeamMemberName.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtTeamMemberName.Location = new System.Drawing.Point(22, 39);
            this.txtTeamMemberName.Name = "txtTeamMemberName";
            this.txtTeamMemberName.Size = new System.Drawing.Size(269, 13);
            this.txtTeamMemberName.TabIndex = 5;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(19, 23);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(78, 13);
            this.label6.TabIndex = 4;
            this.label6.Text = "Team Member:";
            // 
            // txtIndividualTarget
            // 
            this.txtIndividualTarget.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.txtIndividualTarget.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtIndividualTarget.Location = new System.Drawing.Point(152, 71);
            this.txtIndividualTarget.Name = "txtIndividualTarget";
            this.txtIndividualTarget.Size = new System.Drawing.Size(42, 13);
            this.txtIndividualTarget.TabIndex = 7;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(19, 71);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(127, 13);
            this.label7.TabIndex = 6;
            this.label7.Text = "Individual Monthy Target:";
            // 
            // btnDeleteTeamMember
            // 
            this.btnDeleteTeamMember.Location = new System.Drawing.Point(310, 70);
            this.btnDeleteTeamMember.Name = "btnDeleteTeamMember";
            this.btnDeleteTeamMember.Size = new System.Drawing.Size(75, 23);
            this.btnDeleteTeamMember.TabIndex = 10;
            this.btnDeleteTeamMember.Text = "Delete";
            this.btnDeleteTeamMember.UseVisualStyleBackColor = true;
            this.btnDeleteTeamMember.Click += new System.EventHandler(this.btnDeleteTeamMember_Click);
            // 
            // btnEditTeamMember
            // 
            this.btnEditTeamMember.Location = new System.Drawing.Point(310, 41);
            this.btnEditTeamMember.Name = "btnEditTeamMember";
            this.btnEditTeamMember.Size = new System.Drawing.Size(75, 23);
            this.btnEditTeamMember.TabIndex = 9;
            this.btnEditTeamMember.Text = "Edit";
            this.btnEditTeamMember.UseVisualStyleBackColor = true;
            this.btnEditTeamMember.Click += new System.EventHandler(this.btnEditTeamMember_Click);
            // 
            // cmdNewTeamMember
            // 
            this.cmdNewTeamMember.Location = new System.Drawing.Point(310, 12);
            this.cmdNewTeamMember.Name = "cmdNewTeamMember";
            this.cmdNewTeamMember.Size = new System.Drawing.Size(75, 23);
            this.cmdNewTeamMember.TabIndex = 8;
            this.cmdNewTeamMember.Text = "&New";
            this.cmdNewTeamMember.UseVisualStyleBackColor = true;
            this.cmdNewTeamMember.Click += new System.EventHandler(this.cmdNewTeamMember_Click);
            // 
            // tabDashboard
            // 
            this.tabDashboard.Controls.Add(this.btnSaveActiveDashboard);
            this.tabDashboard.Controls.Add(this.cboActiveDashboard);
            this.tabDashboard.Controls.Add(this.label9);
            this.tabDashboard.Location = new System.Drawing.Point(4, 22);
            this.tabDashboard.Name = "tabDashboard";
            this.tabDashboard.Size = new System.Drawing.Size(393, 293);
            this.tabDashboard.TabIndex = 2;
            this.tabDashboard.Text = "Dashboards";
            this.tabDashboard.UseVisualStyleBackColor = true;
            // 
            // btnSaveActiveDashboard
            // 
            this.btnSaveActiveDashboard.Location = new System.Drawing.Point(305, 31);
            this.btnSaveActiveDashboard.Name = "btnSaveActiveDashboard";
            this.btnSaveActiveDashboard.Size = new System.Drawing.Size(75, 23);
            this.btnSaveActiveDashboard.TabIndex = 2;
            this.btnSaveActiveDashboard.Text = "Save";
            this.btnSaveActiveDashboard.UseVisualStyleBackColor = true;
            this.btnSaveActiveDashboard.Click += new System.EventHandler(this.btnSaveActiveDashboard_Click);
            // 
            // cboActiveDashboard
            // 
            this.cboActiveDashboard.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboActiveDashboard.FormattingEnabled = true;
            this.cboActiveDashboard.Location = new System.Drawing.Point(14, 31);
            this.cboActiveDashboard.Name = "cboActiveDashboard";
            this.cboActiveDashboard.Size = new System.Drawing.Size(285, 21);
            this.cboActiveDashboard.TabIndex = 1;
            this.cboActiveDashboard.SelectedIndexChanged += new System.EventHandler(this.cboActiveDashboard_SelectedIndexChanged);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(11, 15);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(192, 13);
            this.label9.TabIndex = 0;
            this.label9.Text = "Select the active Dashboard to display:";
            // 
            // frmSettings
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(423, 372);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.cmdCancel);
            this.Controls.Add(this.cmdApply);
            this.Controls.Add(this.cmdOK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmSettings";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Settings";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.frmSettings_FormClosing);
            this.Load += new System.EventHandler(this.frmSettings_Load);
            this.tabControl1.ResumeLayout(false);
            this.tabTeamTargets.ResumeLayout(false);
            this.tabTeamTargets.PerformLayout();
            this.tabTeamMemberTargets.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.tabDashboard.ResumeLayout(false);
            this.tabDashboard.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button cmdCancel;
        private System.Windows.Forms.Button cmdApply;
        private System.Windows.Forms.Button cmdOK;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabTeamTargets;
        private System.Windows.Forms.TabPage tabTeamMemberTargets;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtVolumeTarget;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtDollarTarget;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ListBox lstTeamMembers;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox txtTeamMemberName;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtIndividualTarget;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button btnDeleteTeamMember;
        private System.Windows.Forms.Button btnEditTeamMember;
        private System.Windows.Forms.Button cmdNewTeamMember;
        private System.Windows.Forms.Button btnSaveTeamMemberRecord;
        private System.Windows.Forms.Button btnSetImagePath;
        private System.Windows.Forms.Label lblImagePath;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtTeamName;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TabPage tabDashboard;
        private System.Windows.Forms.Button btnSaveActiveDashboard;
        private System.Windows.Forms.ComboBox cboActiveDashboard;
        private System.Windows.Forms.Label label9;
    }
}