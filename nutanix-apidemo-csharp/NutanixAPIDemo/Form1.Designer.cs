namespace NutanixAPIDemo
{
    partial class Form1
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
            this.txtRequestUri = new System.Windows.Forms.TextBox();
            this.txtResponse = new System.Windows.Forms.TextBox();
            this.ButtonSendRequest = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label8 = new System.Windows.Forms.Label();
            this.chkClearEach = new System.Windows.Forms.CheckBox();
            this.label5 = new System.Windows.Forms.Label();
            this.chkIgnoreSSLErrors = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtUserName = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtPassword = new System.Windows.Forms.TextBox();
            this.ButtonExit = new System.Windows.Forms.Button();
            this.label6 = new System.Windows.Forms.Label();
            this.txtVerb = new System.Windows.Forms.ComboBox();
            this.label7 = new System.Windows.Forms.Label();
            this.txtRequestBody = new System.Windows.Forms.TextBox();
            this.ButtonClear = new System.Windows.Forms.Button();
            this.LabelUriStatus = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // txtRequestUri
            // 
            this.txtRequestUri.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtRequestUri.Location = new System.Drawing.Point(95, 12);
            this.txtRequestUri.Name = "txtRequestUri";
            this.txtRequestUri.Size = new System.Drawing.Size(424, 23);
            this.txtRequestUri.TabIndex = 0;
            this.txtRequestUri.TextChanged += new System.EventHandler(this.txtRequestUri_TextChanged);
            // 
            // txtResponse
            // 
            this.txtResponse.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtResponse.Location = new System.Drawing.Point(95, 249);
            this.txtResponse.Multiline = true;
            this.txtResponse.Name = "txtResponse";
            this.txtResponse.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtResponse.Size = new System.Drawing.Size(739, 255);
            this.txtResponse.TabIndex = 8;
            // 
            // ButtonSendRequest
            // 
            this.ButtonSendRequest.Enabled = false;
            this.ButtonSendRequest.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ButtonSendRequest.Location = new System.Drawing.Point(613, 11);
            this.ButtonSendRequest.Name = "ButtonSendRequest";
            this.ButtonSendRequest.Size = new System.Drawing.Size(75, 23);
            this.ButtonSendRequest.TabIndex = 9;
            this.ButtonSendRequest.Text = "Send &Request";
            this.ButtonSendRequest.UseVisualStyleBackColor = true;
            this.ButtonSendRequest.Click += new System.EventHandler(this.CmdGo_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(12, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(75, 15);
            this.label1.TabIndex = 3;
            this.label1.Text = "Request URI:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(12, 252);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(62, 15);
            this.label2.TabIndex = 4;
            this.label2.Text = "Response:";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label8);
            this.groupBox1.Controls.Add(this.chkClearEach);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.chkIgnoreSSLErrors);
            this.groupBox1.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.Location = new System.Drawing.Point(95, 166);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(738, 75);
            this.groupBox1.TabIndex = 5;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Options";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(120, 48);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(395, 15);
            this.label8.TabIndex = 10;
            this.label8.Text = "[ After each request, clear any existing responses still being displayed ]";
            // 
            // chkClearEach
            // 
            this.chkClearEach.AutoSize = true;
            this.chkClearEach.Checked = true;
            this.chkClearEach.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkClearEach.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.chkClearEach.Location = new System.Drawing.Point(6, 47);
            this.chkClearEach.Name = "chkClearEach";
            this.chkClearEach.Size = new System.Drawing.Size(116, 19);
            this.chkClearEach.TabIndex = 11;
            this.chkClearEach.Text = "Clear Responses";
            this.chkClearEach.UseVisualStyleBackColor = true;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(120, 24);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(413, 15);
            this.label5.TabIndex = 8;
            this.label5.Text = "[ Please be aware of the security implications of doing that in production ]";
            // 
            // chkIgnoreSSLErrors
            // 
            this.chkIgnoreSSLErrors.AutoSize = true;
            this.chkIgnoreSSLErrors.Checked = true;
            this.chkIgnoreSSLErrors.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkIgnoreSSLErrors.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.chkIgnoreSSLErrors.Location = new System.Drawing.Point(6, 23);
            this.chkIgnoreSSLErrors.Name = "chkIgnoreSSLErrors";
            this.chkIgnoreSSLErrors.Size = new System.Drawing.Size(118, 19);
            this.chkIgnoreSSLErrors.TabIndex = 9;
            this.chkIgnoreSSLErrors.Text = "Ignore SSL errors";
            this.chkIgnoreSSLErrors.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(12, 46);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(65, 15);
            this.label3.TabIndex = 8;
            this.label3.Text = "Username:";
            // 
            // txtUserName
            // 
            this.txtUserName.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtUserName.Location = new System.Drawing.Point(95, 43);
            this.txtUserName.Name = "txtUserName";
            this.txtUserName.Size = new System.Drawing.Size(172, 23);
            this.txtUserName.TabIndex = 1;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(281, 46);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(64, 15);
            this.label4.TabIndex = 10;
            this.label4.Text = "Password:";
            // 
            // txtPassword
            // 
            this.txtPassword.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPassword.Location = new System.Drawing.Point(347, 43);
            this.txtPassword.Name = "txtPassword";
            this.txtPassword.PasswordChar = '*';
            this.txtPassword.Size = new System.Drawing.Size(172, 23);
            this.txtPassword.TabIndex = 2;
            // 
            // ButtonExit
            // 
            this.ButtonExit.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ButtonExit.Location = new System.Drawing.Point(710, 11);
            this.ButtonExit.Name = "ButtonExit";
            this.ButtonExit.Size = new System.Drawing.Size(75, 23);
            this.ButtonExit.TabIndex = 11;
            this.ButtonExit.Text = "E&xit";
            this.ButtonExit.UseVisualStyleBackColor = true;
            this.ButtonExit.Click += new System.EventHandler(this.CmdExit_Click);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(535, 48);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(52, 15);
            this.label6.TabIndex = 12;
            this.label6.Text = "Method:";
            // 
            // txtVerb
            // 
            this.txtVerb.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtVerb.FormattingEnabled = true;
            this.txtVerb.Items.AddRange(new object[] {
            "GET",
            "POST",
            "PUT",
            "DELETE"});
            this.txtVerb.Location = new System.Drawing.Point(613, 44);
            this.txtVerb.Name = "txtVerb";
            this.txtVerb.Size = new System.Drawing.Size(172, 23);
            this.txtVerb.TabIndex = 13;
            this.txtVerb.Text = "GET";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(12, 74);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(68, 15);
            this.label7.TabIndex = 14;
            this.label7.Text = "POST Body:";
            // 
            // txtRequestBody
            // 
            this.txtRequestBody.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtRequestBody.Location = new System.Drawing.Point(95, 74);
            this.txtRequestBody.Multiline = true;
            this.txtRequestBody.Name = "txtRequestBody";
            this.txtRequestBody.Size = new System.Drawing.Size(690, 86);
            this.txtRequestBody.TabIndex = 15;
            // 
            // ButtonClear
            // 
            this.ButtonClear.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ButtonClear.Location = new System.Drawing.Point(95, 510);
            this.ButtonClear.Name = "ButtonClear";
            this.ButtonClear.Size = new System.Drawing.Size(75, 23);
            this.ButtonClear.TabIndex = 16;
            this.ButtonClear.Text = "&Clear";
            this.ButtonClear.UseVisualStyleBackColor = true;
            this.ButtonClear.Click += new System.EventHandler(this.CmdClear_Click);
            // 
            // LabelUriStatus
            // 
            this.LabelUriStatus.AutoSize = true;
            this.LabelUriStatus.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.LabelUriStatus.ForeColor = System.Drawing.Color.Red;
            this.LabelUriStatus.Location = new System.Drawing.Point(526, 17);
            this.LabelUriStatus.Name = "LabelUriStatus";
            this.LabelUriStatus.Size = new System.Drawing.Size(0, 15);
            this.LabelUriStatus.TabIndex = 17;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(848, 539);
            this.Controls.Add(this.LabelUriStatus);
            this.Controls.Add(this.ButtonClear);
            this.Controls.Add(this.txtRequestBody);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.txtVerb);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.ButtonExit);
            this.Controls.Add(this.txtPassword);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtUserName);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.ButtonSendRequest);
            this.Controls.Add(this.txtResponse);
            this.Controls.Add(this.txtRequestUri);
            this.Name = "Form1";
            this.Text = "Nutanix API Demo";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtRequestUri;
        private System.Windows.Forms.TextBox txtResponse;
        private System.Windows.Forms.Button ButtonSendRequest;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtUserName;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtPassword;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.CheckBox chkIgnoreSSLErrors;
        private System.Windows.Forms.Button ButtonExit;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.ComboBox txtVerb;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtRequestBody;
        private System.Windows.Forms.Button ButtonClear;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.CheckBox chkClearEach;
        private System.Windows.Forms.Label LabelUriStatus;
    }
}

