namespace TinyPicBootloader
{
    partial class Form1
    {
        /// <summary>
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur Windows Form

        /// <summary>
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.listHexFiles = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.doBrowse = new System.Windows.Forms.Button();
            this.openHexFile = new System.Windows.Forms.OpenFileDialog();
            this.serialPort = new System.IO.Ports.SerialPort(this.components);
            this.groupComm = new System.Windows.Forms.GroupBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.listDetectedCOM = new System.Windows.Forms.ListBox();
            this.selectedCOM = new System.Windows.Forms.TextBox();
            this.buttonSearch = new System.Windows.Forms.Button();
            this.comboBaudSelect = new System.Windows.Forms.ComboBox();
            this.checkFile = new System.Windows.Forms.CheckBox();
            this.openPiccodesFile = new System.Windows.Forms.OpenFileDialog();
            this.checkWriteEEPROM = new System.Windows.Forms.CheckBox();
            this.buttonWrite = new System.Windows.Forms.Button();
            this.buttonCheck = new System.Windows.Forms.Button();
            this.buttonAutoDetect = new System.Windows.Forms.Button();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.buttonAbort = new System.Windows.Forms.Button();
            this.label25 = new System.Windows.Forms.Label();
            this.checkWriteFlashProg = new System.Windows.Forms.CheckBox();
            this.linkOnlineSupport = new System.Windows.Forms.LinkLabel();
            this.checkWriteConfig = new System.Windows.Forms.CheckBox();
            this.checkEraseEEPROM = new System.Windows.Forms.CheckBox();
            this.tabAbout = new System.Windows.Forms.TabPage();
            this.label26 = new System.Windows.Forms.Label();
            this.linkSourceForge = new System.Windows.Forms.LinkLabel();
            this.label20 = new System.Windows.Forms.Label();
            this.label19 = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.linkCChiculita = new System.Windows.Forms.LinkLabel();
            this.label13 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.tabDebug = new System.Windows.Forms.TabPage();
            this.groupBox10 = new System.Windows.Forms.GroupBox();
            this.checkShowTransfert = new System.Windows.Forms.CheckBox();
            this.checkShowAutoDetect = new System.Windows.Forms.CheckBox();
            this.checkShowCheckFile = new System.Windows.Forms.CheckBox();
            this.checkShowAnswer = new System.Windows.Forms.CheckBox();
            this.label39 = new System.Windows.Forms.Label();
            this.checkShowFile = new System.Windows.Forms.CheckBox();
            this.groupBox7 = new System.Windows.Forms.GroupBox();
            this.textRawTransfert = new System.Windows.Forms.TextBox();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.label24 = new System.Windows.Forms.Label();
            this.textVirtualPICFam = new System.Windows.Forms.TextBox();
            this.label21 = new System.Windows.Forms.Label();
            this.textVirtualPIC = new System.Windows.Forms.TextBox();
            this.checkVirtualPIC = new System.Windows.Forms.CheckBox();
            this.tabMessages = new System.Windows.Forms.TabPage();
            this.textMessages = new System.Windows.Forms.TextBox();
            this.tabControl = new System.Windows.Forms.TabControl();
            this.tabConfig = new System.Windows.Forms.TabPage();
            this.groupReset = new System.Windows.Forms.GroupBox();
            this.radioResetDTR = new System.Windows.Forms.RadioButton();
            this.radioResetRemoteSignal = new System.Windows.Forms.RadioButton();
            this.radioResetRTS = new System.Windows.Forms.RadioButton();
            this.radioResetManual = new System.Windows.Forms.RadioButton();
            this.groupBoxRemoteSignal = new System.Windows.Forms.GroupBox();
            this.textRemoteWait = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.textRemoteMessage = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.groupBox8 = new System.Windows.Forms.GroupBox();
            this.label31 = new System.Windows.Forms.Label();
            this.label32 = new System.Windows.Forms.Label();
            this.label33 = new System.Windows.Forms.Label();
            this.label34 = new System.Windows.Forms.Label();
            this.textBaudFinal = new System.Windows.Forms.TextBox();
            this.textClockFinal = new System.Windows.Forms.TextBox();
            this.textClockInit = new System.Windows.Forms.TextBox();
            this.textBaudInit = new System.Windows.Forms.TextBox();
            this.checkUseSpecialBaudRate = new System.Windows.Forms.CheckBox();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.checkPowerRTS = new System.Windows.Forms.CheckBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.doChoosePiccodes = new System.Windows.Forms.Button();
            this.textPiccodesPath = new System.Windows.Forms.TextBox();
            this.checkForcePiccodes = new System.Windows.Forms.CheckBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.label36 = new System.Windows.Forms.Label();
            this.textNbChecks = new System.Windows.Forms.TextBox();
            this.label37 = new System.Windows.Forms.Label();
            this.textDelayCheck = new System.Windows.Forms.TextBox();
            this.label38 = new System.Windows.Forms.Label();
            this.textReadTimeOut = new System.Windows.Forms.TextBox();
            this.groupBoxRTSreset = new System.Windows.Forms.GroupBox();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.label40 = new System.Windows.Forms.Label();
            this.textRTSFalse = new System.Windows.Forms.TextBox();
            this.textRTSTrue = new System.Windows.Forms.TextBox();
            this.label41 = new System.Windows.Forms.Label();
            this.tabFirmware = new System.Windows.Forms.TabPage();
            this.textDefaultBaudRate = new System.Windows.Forms.TextBox();
            this.textFirmwareFileName = new System.Windows.Forms.TextBox();
            this.label30 = new System.Windows.Forms.Label();
            this.tb_Test = new System.Windows.Forms.TextBox();
            this.label44 = new System.Windows.Forms.Label();
            this.comboFirmwareFlavour = new System.Windows.Forms.ComboBox();
            this.b_flashDevice = new System.Windows.Forms.Button();
            this.label35 = new System.Windows.Forms.Label();
            this.textFreq = new System.Windows.Forms.TextBox();
            this.label42 = new System.Windows.Forms.Label();
            this.textDefaultTXpin = new System.Windows.Forms.TextBox();
            this.textDefaultRXpin = new System.Windows.Forms.TextBox();
            this.textClockType = new System.Windows.Forms.TextBox();
            this.label29 = new System.Windows.Forms.Label();
            this.label28 = new System.Windows.Forms.Label();
            this.label27 = new System.Windows.Forms.Label();
            this.label23 = new System.Windows.Forms.Label();
            this.label22 = new System.Windows.Forms.Label();
            this.comboFirmwareDevice = new System.Windows.Forms.ComboBox();
            this.comboFirmwareBrand = new System.Windows.Forms.ComboBox();
            this.doChooseFirmwaresFolder = new System.Windows.Forms.Button();
            this.textBoxFirmwareFolder = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.checkProgrammerVDD = new System.Windows.Forms.CheckBox();
            this.doChooseIPEfolder = new System.Windows.Forms.Button();
            this.textBoxIPEfolderPath = new System.Windows.Forms.TextBox();
            this.label43 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.comboPicProgrammer = new System.Windows.Forms.ComboBox();
            this.label9 = new System.Windows.Forms.Label();
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.panel1 = new System.Windows.Forms.Panel();
            this.checkShowToolTip = new System.Windows.Forms.CheckBox();
            this.linkDoc = new System.Windows.Forms.LinkLabel();
            this.label7 = new System.Windows.Forms.Label();
            this.link8051List = new System.Windows.Forms.LinkLabel();
            this.linkAtmelList = new System.Windows.Forms.LinkLabel();
            this.linkMicrochipList = new System.Windows.Forms.LinkLabel();
            this.linkNxpList = new System.Windows.Forms.LinkLabel();
            this.linkTiList = new System.Windows.Forms.LinkLabel();
            this.fb_Firmwares = new System.Windows.Forms.FolderBrowserDialog();
            this.openIPEcmdFile = new System.Windows.Forms.OpenFileDialog();
            this.buttonDonate = new System.Windows.Forms.Button();
            this.groupComm.SuspendLayout();
            this.tabAbout.SuspendLayout();
            this.tabDebug.SuspendLayout();
            this.groupBox10.SuspendLayout();
            this.groupBox7.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.tabMessages.SuspendLayout();
            this.tabControl.SuspendLayout();
            this.tabConfig.SuspendLayout();
            this.groupReset.SuspendLayout();
            this.groupBoxRemoteSignal.SuspendLayout();
            this.groupBox8.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBoxRTSreset.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.tabFirmware.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // listHexFiles
            // 
            this.listHexFiles.FormattingEnabled = true;
            this.listHexFiles.Location = new System.Drawing.Point(83, 12);
            this.listHexFiles.Name = "listHexFiles";
            this.listHexFiles.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.listHexFiles.Size = new System.Drawing.Size(400, 21);
            this.listHexFiles.TabIndex = 0;
            this.toolTip.SetToolTip(this.listHexFiles, "It\'s the file that will be written in the device. This list keep trace of the pre" +
        "vious written files.");
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(71, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Selected File:";
            this.toolTip.SetToolTip(this.label1, "It\'s the file that will be written in the device. This list keep trace of the pre" +
        "vious written files.");
            // 
            // doBrowse
            // 
            this.doBrowse.Location = new System.Drawing.Point(489, 10);
            this.doBrowse.Name = "doBrowse";
            this.doBrowse.Size = new System.Drawing.Size(75, 23);
            this.doBrowse.TabIndex = 2;
            this.doBrowse.Text = "Browse";
            this.toolTip.SetToolTip(this.doBrowse, "Find in you computer the \".hex\" or \".eep\" you want to write. Instead of using [Br" +
        "owse] you can Drag & Drop your file(s).");
            this.doBrowse.UseVisualStyleBackColor = true;
            this.doBrowse.Click += new System.EventHandler(this.doBrowse_Click);
            // 
            // openHexFile
            // 
            this.openHexFile.Filter = "Writable files (*.hex ; *.eep)|*.hex;*.eep";
            this.openHexFile.Title = "Select valid Hex file";
            this.openHexFile.FileOk += new System.ComponentModel.CancelEventHandler(this.openHexFile_FileOk);
            // 
            // serialPort
            // 
            this.serialPort.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(this.serialPort_DataReceived);
            // 
            // groupComm
            // 
            this.groupComm.Controls.Add(this.label6);
            this.groupComm.Controls.Add(this.label5);
            this.groupComm.Controls.Add(this.label4);
            this.groupComm.Controls.Add(this.listDetectedCOM);
            this.groupComm.Controls.Add(this.selectedCOM);
            this.groupComm.Controls.Add(this.buttonSearch);
            this.groupComm.Controls.Add(this.comboBaudSelect);
            this.groupComm.Location = new System.Drawing.Point(2, 155);
            this.groupComm.Name = "groupComm";
            this.groupComm.Size = new System.Drawing.Size(104, 211);
            this.groupComm.TabIndex = 4;
            this.groupComm.TabStop = false;
            this.groupComm.Text = "Comm";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(6, 13);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(61, 13);
            this.label6.TabIndex = 13;
            this.label6.Text = "Baud Rate:";
            this.toolTip.SetToolTip(this.label6, "Displays the selected transmission\'s Baud Rate. Change Baud Rate.");
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(6, 109);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(81, 13);
            this.label5.TabIndex = 12;
            this.label5.Text = "Detected COM:";
            this.toolTip.SetToolTip(this.label5, "List of the detected computer\'s serial ports. Select in it the port you want to u" +
        "se. This list is refreshed at program startup and when [Search COM] is used.");
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(6, 49);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(79, 13);
            this.label4.TabIndex = 11;
            this.label4.Text = "Selected COM:";
            this.toolTip.SetToolTip(this.label4, "Displays the selected computer\'s serial port. Change serial port.");
            // 
            // listDetectedCOM
            // 
            this.listDetectedCOM.FormattingEnabled = true;
            this.listDetectedCOM.Location = new System.Drawing.Point(8, 123);
            this.listDetectedCOM.Name = "listDetectedCOM";
            this.listDetectedCOM.Size = new System.Drawing.Size(91, 82);
            this.listDetectedCOM.TabIndex = 8;
            this.toolTip.SetToolTip(this.listDetectedCOM, "List of the detected computer\'s serial ports. Select in it the port you want to u" +
        "se. This list is refreshed at program startup and when [Search COM] is used.");
            this.listDetectedCOM.SelectedIndexChanged += new System.EventHandler(this.listDetectedCOM_SelectedIndexChanged);
            // 
            // selectedCOM
            // 
            this.selectedCOM.Location = new System.Drawing.Point(6, 63);
            this.selectedCOM.Name = "selectedCOM";
            this.selectedCOM.Size = new System.Drawing.Size(93, 20);
            this.selectedCOM.TabIndex = 7;
            this.toolTip.SetToolTip(this.selectedCOM, "Displays the selected computer\'s serial port. Change serial port.");
            // 
            // buttonSearch
            // 
            this.buttonSearch.Location = new System.Drawing.Point(6, 86);
            this.buttonSearch.Name = "buttonSearch";
            this.buttonSearch.Size = new System.Drawing.Size(91, 23);
            this.buttonSearch.TabIndex = 6;
            this.buttonSearch.Text = "Search COM";
            this.toolTip.SetToolTip(this.buttonSearch, "Launch a search of all computer\'s serial ports.\\r\\nResult is displayed in \"Detect" +
        "ed COM\"");
            this.buttonSearch.UseVisualStyleBackColor = true;
            this.buttonSearch.Click += new System.EventHandler(this.buttonSearch_Click);
            // 
            // comboBaudSelect
            // 
            this.comboBaudSelect.FormattingEnabled = true;
            this.comboBaudSelect.Items.AddRange(new object[] {
            "115200",
            "57600",
            "38400",
            "19200",
            "9600"});
            this.comboBaudSelect.Location = new System.Drawing.Point(6, 27);
            this.comboBaudSelect.Name = "comboBaudSelect";
            this.comboBaudSelect.Size = new System.Drawing.Size(93, 21);
            this.comboBaudSelect.TabIndex = 5;
            this.toolTip.SetToolTip(this.comboBaudSelect, "Displays the selected transmission\'s Baud Rate. Change Baud Rate.");
            // 
            // checkFile
            // 
            this.checkFile.AutoSize = true;
            this.checkFile.Location = new System.Drawing.Point(92, 3);
            this.checkFile.Name = "checkFile";
            this.checkFile.Size = new System.Drawing.Size(109, 17);
            this.checkFile.TabIndex = 10;
            this.checkFile.Text = "Check Hex File   |";
            this.toolTip.SetToolTip(this.checkFile, "HEX code verification to avoid to send a program from a different device family i" +
        "n your PIC (for example: prevent to program a PIC16\'s \".hex\" in a PIC18 device)." +
        " Warning: Not used for AVR devices.");
            this.checkFile.UseVisualStyleBackColor = true;
            // 
            // openPiccodesFile
            // 
            this.openPiccodesFile.Filter = "piccodes.ini |piccodes.ini|ini files|*.ini";
            this.openPiccodesFile.FileOk += new System.ComponentModel.CancelEventHandler(this.openPiccodesFile_FileOk);
            // 
            // checkWriteEEPROM
            // 
            this.checkWriteEEPROM.AutoSize = true;
            this.checkWriteEEPROM.Location = new System.Drawing.Point(333, 4);
            this.checkWriteEEPROM.Name = "checkWriteEEPROM";
            this.checkWriteEEPROM.Size = new System.Drawing.Size(111, 17);
            this.checkWriteEEPROM.TabIndex = 11;
            this.checkWriteEEPROM.Text = "Write EEPROM   |";
            this.toolTip.SetToolTip(this.checkWriteEEPROM, "Select if the device\'s EEPROM memory must be written with data contained in the s" +
        "elected file.");
            this.checkWriteEEPROM.UseVisualStyleBackColor = true;
            // 
            // buttonWrite
            // 
            this.buttonWrite.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonWrite.Location = new System.Drawing.Point(10, 39);
            this.buttonWrite.Name = "buttonWrite";
            this.buttonWrite.Size = new System.Drawing.Size(92, 23);
            this.buttonWrite.TabIndex = 0;
            this.buttonWrite.Text = "Write Device";
            this.toolTip.SetToolTip(this.buttonWrite, "Write the selected file to the microcontroller.");
            this.buttonWrite.UseVisualStyleBackColor = true;
            this.buttonWrite.Click += new System.EventHandler(this.buttonWrite_Click);
            // 
            // buttonCheck
            // 
            this.buttonCheck.Location = new System.Drawing.Point(10, 64);
            this.buttonCheck.Name = "buttonCheck";
            this.buttonCheck.Size = new System.Drawing.Size(92, 23);
            this.buttonCheck.TabIndex = 6;
            this.buttonCheck.Text = "Check Device";
            this.toolTip.SetToolTip(this.buttonCheck, "Check if the microcontroller is correctly connected to the PC. If so, it will dis" +
        "play its designation.");
            this.buttonCheck.UseVisualStyleBackColor = true;
            this.buttonCheck.Click += new System.EventHandler(this.buttonCheck_Click);
            // 
            // buttonAutoDetect
            // 
            this.buttonAutoDetect.Location = new System.Drawing.Point(10, 89);
            this.buttonAutoDetect.Name = "buttonAutoDetect";
            this.buttonAutoDetect.Size = new System.Drawing.Size(92, 23);
            this.buttonAutoDetect.TabIndex = 7;
            this.buttonAutoDetect.Text = "Auto Conf COM";
            this.toolTip.SetToolTip(this.buttonAutoDetect, "Automatically detect the right COM port and Baud Rate. Warning: the microcontroll" +
        "er must be connected and automatic reset must be enabled!");
            this.buttonAutoDetect.UseVisualStyleBackColor = true;
            this.buttonAutoDetect.Click += new System.EventHandler(this.buttonAutoDetect_Click);
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(10, 115);
            this.progressBar.Maximum = 10000;
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(91, 10);
            this.progressBar.TabIndex = 8;
            this.toolTip.SetToolTip(this.progressBar, "Displays the progression of the current operation (write, erase, check device, au" +
        "to conf COM,...)");
            // 
            // buttonAbort
            // 
            this.buttonAbort.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonAbort.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.buttonAbort.Location = new System.Drawing.Point(10, 129);
            this.buttonAbort.Name = "buttonAbort";
            this.buttonAbort.Size = new System.Drawing.Size(92, 23);
            this.buttonAbort.TabIndex = 12;
            this.buttonAbort.Text = "Abort";
            this.toolTip.SetToolTip(this.buttonAbort, "Abort the current operation (write, erase, check device, auto conf COM,...)");
            this.buttonAbort.UseVisualStyleBackColor = true;
            this.buttonAbort.Click += new System.EventHandler(this.buttonAbort_Click);
            // 
            // label25
            // 
            this.label25.AutoSize = true;
            this.label25.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Underline, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label25.Location = new System.Drawing.Point(3, 4);
            this.label25.Name = "label25";
            this.label25.Size = new System.Drawing.Size(89, 13);
            this.label25.TabIndex = 13;
            this.label25.Text = "Transfert options:";
            // 
            // checkWriteFlashProg
            // 
            this.checkWriteFlashProg.AutoSize = true;
            this.checkWriteFlashProg.Checked = true;
            this.checkWriteFlashProg.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkWriteFlashProg.Location = new System.Drawing.Point(201, 3);
            this.checkWriteFlashProg.Name = "checkWriteFlashProg";
            this.checkWriteFlashProg.Size = new System.Drawing.Size(132, 17);
            this.checkWriteFlashProg.TabIndex = 14;
            this.checkWriteFlashProg.Text = "Write Flash Program   |";
            this.toolTip.SetToolTip(this.checkWriteFlashProg, "Select if the device\'s flash program memory must be written with data contained i" +
        "n the selected file.");
            this.checkWriteFlashProg.UseVisualStyleBackColor = true;
            // 
            // linkOnlineSupport
            // 
            this.linkOnlineSupport.AutoSize = true;
            this.linkOnlineSupport.Location = new System.Drawing.Point(403, 434);
            this.linkOnlineSupport.Name = "linkOnlineSupport";
            this.linkOnlineSupport.Size = new System.Drawing.Size(75, 13);
            this.linkOnlineSupport.TabIndex = 15;
            this.linkOnlineSupport.TabStop = true;
            this.linkOnlineSupport.Text = "Online support";
            this.linkOnlineSupport.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkOnlineSupport_LinkClicked);
            // 
            // checkWriteConfig
            // 
            this.checkWriteConfig.AutoSize = true;
            this.checkWriteConfig.Location = new System.Drawing.Point(444, 4);
            this.checkWriteConfig.Name = "checkWriteConfig";
            this.checkWriteConfig.Size = new System.Drawing.Size(113, 17);
            this.checkWriteConfig.TabIndex = 11;
            this.checkWriteConfig.Text = "Write Config Bytes";
            this.checkWriteConfig.UseVisualStyleBackColor = true;
            this.checkWriteConfig.CheckedChanged += new System.EventHandler(this.checkWriteConfig_CheckedChanged);
            // 
            // checkEraseEEPROM
            // 
            this.checkEraseEEPROM.AutoSize = true;
            this.checkEraseEEPROM.Location = new System.Drawing.Point(333, 26);
            this.checkEraseEEPROM.Name = "checkEraseEEPROM";
            this.checkEraseEEPROM.Size = new System.Drawing.Size(102, 17);
            this.checkEraseEEPROM.TabIndex = 16;
            this.checkEraseEEPROM.Text = "Erase EEPROM";
            this.checkEraseEEPROM.UseVisualStyleBackColor = true;
            // 
            // tabAbout
            // 
            this.tabAbout.BackColor = System.Drawing.Color.White;
            this.tabAbout.Controls.Add(this.label26);
            this.tabAbout.Controls.Add(this.linkSourceForge);
            this.tabAbout.Controls.Add(this.label20);
            this.tabAbout.Controls.Add(this.label19);
            this.tabAbout.Controls.Add(this.label18);
            this.tabAbout.Controls.Add(this.label17);
            this.tabAbout.Controls.Add(this.label16);
            this.tabAbout.Controls.Add(this.label15);
            this.tabAbout.Controls.Add(this.label14);
            this.tabAbout.Controls.Add(this.linkCChiculita);
            this.tabAbout.Controls.Add(this.label13);
            this.tabAbout.Controls.Add(this.label12);
            this.tabAbout.Controls.Add(this.label11);
            this.tabAbout.Controls.Add(this.label10);
            this.tabAbout.Location = new System.Drawing.Point(4, 22);
            this.tabAbout.Name = "tabAbout";
            this.tabAbout.Padding = new System.Windows.Forms.Padding(3);
            this.tabAbout.Size = new System.Drawing.Size(444, 301);
            this.tabAbout.TabIndex = 3;
            this.tabAbout.Text = "About";
            // 
            // label26
            // 
            this.label26.AutoSize = true;
            this.label26.Location = new System.Drawing.Point(47, 50);
            this.label26.Name = "label26";
            this.label26.Size = new System.Drawing.Size(286, 13);
            this.label26.TabIndex = 14;
            this.label26.Text = "and Dan (http://www3.hp-ez.com/hp/bequest333) - Japan";
            // 
            // linkSourceForge
            // 
            this.linkSourceForge.AutoSize = true;
            this.linkSourceForge.Location = new System.Drawing.Point(58, 99);
            this.linkSourceForge.Name = "linkSourceForge";
            this.linkSourceForge.Size = new System.Drawing.Size(235, 13);
            this.linkSourceForge.TabIndex = 12;
            this.linkSourceForge.TabStop = true;
            this.linkSourceForge.Text = "http://sourceforge.net/projects/tinypicbootload/";
            this.linkSourceForge.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkSourceForge_LinkClicked);
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.Location = new System.Drawing.Point(47, 80);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(125, 13);
            this.label20.TabIndex = 11;
            this.label20.Text = "It can be downloaded at:";
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label19.Location = new System.Drawing.Point(58, 224);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(225, 13);
            this.label19.TabIndex = 10;
            this.label19.Text = "- you CAN\'T sell it, even if you have modified it";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label18.Location = new System.Drawing.Point(58, 205);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(334, 13);
            this.label18.TabIndex = 9;
            this.label18.Text = "- you can modify it as you want, but this licence must remain the same";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label17.Location = new System.Drawing.Point(58, 186);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(306, 13);
            this.label17.TabIndex = 8;
            this.label17.Text = "- you can share it for free, but this licence must remain the same";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label16.Location = new System.Drawing.Point(58, 167);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(153, 13);
            this.label16.TabIndex = 7;
            this.label16.Text = "- you can use it at work for free";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.Location = new System.Drawing.Point(58, 148);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(156, 13);
            this.label15.TabIndex = 6;
            this.label15.Text = "- you can use it at home for free";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(6, 131);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(387, 13);
            this.label14.TabIndex = 5;
            this.label14.Text = " This software is under \"Creative Commons Attribution Non-Commercial License\":";
            // 
            // linkCChiculita
            // 
            this.linkCChiculita.AutoSize = true;
            this.linkCChiculita.Location = new System.Drawing.Point(58, 274);
            this.linkCChiculita.Name = "linkCChiculita";
            this.linkCChiculita.Size = new System.Drawing.Size(299, 13);
            this.linkCChiculita.TabIndex = 4;
            this.linkCChiculita.TabStop = true;
            this.linkCChiculita.Text = "http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm";
            this.linkCChiculita.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkCChiculita_LinkClicked);
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(10, 254);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(408, 13);
            this.label13.TabIndex = 3;
            this.label13.Text = "The idea and first realisation of \"Tiny PIC Bootloader\" is the work of Claudiu Ch" +
    "iculita.";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(47, 33);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(169, 13);
            this.label12.TabIndex = 2;
            this.label12.Text = "by Edorul (edorul@free.fr) - France";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(168, 8);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(98, 13);
            this.label11.TabIndex = 1;
            this.label11.Text = "v0.11.0 (may 2016)";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.Location = new System.Drawing.Point(6, 8);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(134, 13);
            this.label10.TabIndex = 0;
            this.label10.Text = "Tiny Multi Bootloader+";
            // 
            // tabDebug
            // 
            this.tabDebug.BackColor = System.Drawing.Color.White;
            this.tabDebug.Controls.Add(this.groupBox10);
            this.tabDebug.Controls.Add(this.groupBox7);
            this.tabDebug.Controls.Add(this.groupBox6);
            this.tabDebug.Location = new System.Drawing.Point(4, 22);
            this.tabDebug.Name = "tabDebug";
            this.tabDebug.Size = new System.Drawing.Size(444, 301);
            this.tabDebug.TabIndex = 2;
            this.tabDebug.Text = "Debug";
            // 
            // groupBox10
            // 
            this.groupBox10.Controls.Add(this.checkShowTransfert);
            this.groupBox10.Controls.Add(this.checkShowAutoDetect);
            this.groupBox10.Controls.Add(this.checkShowCheckFile);
            this.groupBox10.Controls.Add(this.checkShowAnswer);
            this.groupBox10.Controls.Add(this.label39);
            this.groupBox10.Controls.Add(this.checkShowFile);
            this.groupBox10.Location = new System.Drawing.Point(214, 3);
            this.groupBox10.Name = "groupBox10";
            this.groupBox10.Size = new System.Drawing.Size(215, 140);
            this.groupBox10.TabIndex = 11;
            this.groupBox10.TabStop = false;
            this.groupBox10.Text = "Debug Messages:";
            // 
            // checkShowTransfert
            // 
            this.checkShowTransfert.AutoSize = true;
            this.checkShowTransfert.Location = new System.Drawing.Point(6, 118);
            this.checkShowTransfert.Name = "checkShowTransfert";
            this.checkShowTransfert.Size = new System.Drawing.Size(142, 17);
            this.checkShowTransfert.TabIndex = 11;
            this.checkShowTransfert.Text = "Show Transfered Blocks";
            this.toolTip.SetToolTip(this.checkShowTransfert, "Displays in the \"Messages\" tab all the blocks of data transfered with their heade" +
        "rs and addresses where they are written.");
            this.checkShowTransfert.UseVisualStyleBackColor = true;
            // 
            // checkShowAutoDetect
            // 
            this.checkShowAutoDetect.AutoSize = true;
            this.checkShowAutoDetect.Location = new System.Drawing.Point(6, 96);
            this.checkShowAutoDetect.Name = "checkShowAutoDetect";
            this.checkShowAutoDetect.Size = new System.Drawing.Size(135, 17);
            this.checkShowAutoDetect.TabIndex = 10;
            this.checkShowAutoDetect.Text = "Show Auto Detect tries";
            this.toolTip.SetToolTip(this.checkShowAutoDetect, "Displays in the \"Messages\" tab the Baud Rates and COM ports tested during a [Auto" +
        " Conf COM].");
            this.checkShowAutoDetect.UseVisualStyleBackColor = true;
            // 
            // checkShowCheckFile
            // 
            this.checkShowCheckFile.AutoSize = true;
            this.checkShowCheckFile.Location = new System.Drawing.Point(6, 74);
            this.checkShowCheckFile.Name = "checkShowCheckFile";
            this.checkShowCheckFile.Size = new System.Drawing.Size(147, 17);
            this.checkShowCheckFile.TabIndex = 9;
            this.checkShowCheckFile.Text = "Show check file elements";
            this.toolTip.SetToolTip(this.checkShowCheckFile, resources.GetString("checkShowCheckFile.ToolTip"));
            this.checkShowCheckFile.UseVisualStyleBackColor = true;
            // 
            // checkShowAnswer
            // 
            this.checkShowAnswer.AutoSize = true;
            this.checkShowAnswer.Location = new System.Drawing.Point(6, 52);
            this.checkShowAnswer.Name = "checkShowAnswer";
            this.checkShowAnswer.Size = new System.Drawing.Size(199, 17);
            this.checkShowAnswer.TabIndex = 8;
            this.checkShowAnswer.Text = "Show answer during [Check Device]";
            this.toolTip.SetToolTip(this.checkShowAnswer, "Displays in the \"Messages\" tab the PC\'s request and the device\'s answers during a" +
        " Check Device. Then display all the device\'s properties gathered from \"piccodes." +
        "ini\" file.");
            this.checkShowAnswer.UseVisualStyleBackColor = true;
            // 
            // label39
            // 
            this.label39.AutoSize = true;
            this.label39.Location = new System.Drawing.Point(19, 35);
            this.label39.Name = "label39";
            this.label39.Size = new System.Drawing.Size(175, 13);
            this.label39.TabIndex = 7;
            this.label39.Text = "(may loose connection with Device)";
            this.toolTip.SetToolTip(this.label39, "Displays in the \"Messages\" tab the \".hex\" file (and/or \".eep\" file) line by line " +
        "with the addresses and data collected in each of them.");
            // 
            // checkShowFile
            // 
            this.checkShowFile.AutoSize = true;
            this.checkShowFile.Location = new System.Drawing.Point(6, 19);
            this.checkShowFile.Name = "checkShowFile";
            this.checkShowFile.Size = new System.Drawing.Size(168, 17);
            this.checkShowFile.TabIndex = 1;
            this.checkShowFile.Text = "Show Hex file before transfert ";
            this.toolTip.SetToolTip(this.checkShowFile, "Displays in the \"Messages\" tab the \".hex\" file (and/or \".eep\" file) line by line " +
        "with the addresses and data collected in each of them.");
            this.checkShowFile.UseVisualStyleBackColor = true;
            // 
            // groupBox7
            // 
            this.groupBox7.Controls.Add(this.textRawTransfert);
            this.groupBox7.Location = new System.Drawing.Point(3, 143);
            this.groupBox7.Name = "groupBox7";
            this.groupBox7.Size = new System.Drawing.Size(427, 156);
            this.groupBox7.TabIndex = 10;
            this.groupBox7.TabStop = false;
            this.groupBox7.Text = "Serial Transfert: RAW Display (hexa):";
            // 
            // textRawTransfert
            // 
            this.textRawTransfert.BackColor = System.Drawing.SystemColors.HighlightText;
            this.textRawTransfert.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textRawTransfert.Location = new System.Drawing.Point(6, 16);
            this.textRawTransfert.Multiline = true;
            this.textRawTransfert.Name = "textRawTransfert";
            this.textRawTransfert.ReadOnly = true;
            this.textRawTransfert.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textRawTransfert.Size = new System.Drawing.Size(415, 134);
            this.textRawTransfert.TabIndex = 11;
            this.toolTip.SetToolTip(this.textRawTransfert, "Displays the raw data during communication with a device.");
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.label24);
            this.groupBox6.Controls.Add(this.textVirtualPICFam);
            this.groupBox6.Controls.Add(this.label21);
            this.groupBox6.Controls.Add(this.textVirtualPIC);
            this.groupBox6.Controls.Add(this.checkVirtualPIC);
            this.groupBox6.Location = new System.Drawing.Point(3, 3);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(205, 44);
            this.groupBox6.TabIndex = 9;
            this.groupBox6.TabStop = false;
            this.groupBox6.Text = "Virtual Device:";
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.Location = new System.Drawing.Point(90, 20);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(35, 13);
            this.label24.TabIndex = 4;
            this.label24.Text = "ID=0x";
            this.toolTip.SetToolTip(this.label24, "Define the \"ID code\" of the simulated virtual device. For the complete list of co" +
        "des, look in the \"piccodes.ini\" file.");
            // 
            // textVirtualPICFam
            // 
            this.textVirtualPICFam.Enabled = false;
            this.textVirtualPICFam.Location = new System.Drawing.Point(184, 17);
            this.textVirtualPICFam.Name = "textVirtualPICFam";
            this.textVirtualPICFam.Size = new System.Drawing.Size(15, 20);
            this.textVirtualPICFam.TabIndex = 3;
            this.textVirtualPICFam.Text = "K";
            this.toolTip.SetToolTip(this.textVirtualPICFam, "Define the \"Family\" of the simulated virtual device. The different families are i" +
        "n the \"piccodes.ini\" file.");
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Location = new System.Drawing.Point(151, 20);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(33, 13);
            this.label21.TabIndex = 2;
            this.label21.Text = "Fam=";
            this.toolTip.SetToolTip(this.label21, "Define the \"Family\" of the simulated virtual device. The different families are i" +
        "n the \"piccodes.ini\" file.");
            // 
            // textVirtualPIC
            // 
            this.textVirtualPIC.Enabled = false;
            this.textVirtualPIC.Location = new System.Drawing.Point(125, 17);
            this.textVirtualPIC.Name = "textVirtualPIC";
            this.textVirtualPIC.Size = new System.Drawing.Size(24, 20);
            this.textVirtualPIC.TabIndex = 1;
            this.textVirtualPIC.Text = "21";
            this.toolTip.SetToolTip(this.textVirtualPIC, "Define the \"ID code\" of the simulated virtual device. For the complete list of co" +
        "des, look in the \"piccodes.ini\" file.");
            // 
            // checkVirtualPIC
            // 
            this.checkVirtualPIC.AutoSize = true;
            this.checkVirtualPIC.Location = new System.Drawing.Point(6, 19);
            this.checkVirtualPIC.Name = "checkVirtualPIC";
            this.checkVirtualPIC.Size = new System.Drawing.Size(92, 17);
            this.checkVirtualPIC.TabIndex = 0;
            this.checkVirtualPIC.Text = "Virtual Device";
            this.toolTip.SetToolTip(this.checkVirtualPIC, "Simulates the communications between the PC and a virtual device. This option is " +
        "only useful for PC software developpers.");
            this.checkVirtualPIC.UseVisualStyleBackColor = true;
            this.checkVirtualPIC.CheckedChanged += new System.EventHandler(this.checkVirtualPIC_CheckedChanged);
            // 
            // tabMessages
            // 
            this.tabMessages.Controls.Add(this.textMessages);
            this.tabMessages.Location = new System.Drawing.Point(4, 22);
            this.tabMessages.Name = "tabMessages";
            this.tabMessages.Padding = new System.Windows.Forms.Padding(3);
            this.tabMessages.Size = new System.Drawing.Size(444, 301);
            this.tabMessages.TabIndex = 0;
            this.tabMessages.Text = "Messages";
            this.tabMessages.UseVisualStyleBackColor = true;
            // 
            // textMessages
            // 
            this.textMessages.BackColor = System.Drawing.SystemColors.HighlightText;
            this.textMessages.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textMessages.Location = new System.Drawing.Point(0, 0);
            this.textMessages.Multiline = true;
            this.textMessages.Name = "textMessages";
            this.textMessages.ReadOnly = true;
            this.textMessages.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textMessages.Size = new System.Drawing.Size(443, 301);
            this.textMessages.TabIndex = 1;
            this.toolTip.SetToolTip(this.textMessages, "Place where the log of all the program\'s actions are displayed.");
            // 
            // tabControl
            // 
            this.tabControl.Controls.Add(this.tabMessages);
            this.tabControl.Controls.Add(this.tabConfig);
            this.tabControl.Controls.Add(this.tabFirmware);
            this.tabControl.Controls.Add(this.tabDebug);
            this.tabControl.Controls.Add(this.tabAbout);
            this.tabControl.Location = new System.Drawing.Point(112, 39);
            this.tabControl.Name = "tabControl";
            this.tabControl.SelectedIndex = 0;
            this.tabControl.Size = new System.Drawing.Size(452, 327);
            this.tabControl.TabIndex = 5;
            // 
            // tabConfig
            // 
            this.tabConfig.BackColor = System.Drawing.Color.White;
            this.tabConfig.Controls.Add(this.groupReset);
            this.tabConfig.Controls.Add(this.groupBoxRemoteSignal);
            this.tabConfig.Controls.Add(this.groupBox8);
            this.tabConfig.Controls.Add(this.groupBox5);
            this.tabConfig.Controls.Add(this.groupBox4);
            this.tabConfig.Controls.Add(this.groupBox3);
            this.tabConfig.Controls.Add(this.groupBoxRTSreset);
            this.tabConfig.Location = new System.Drawing.Point(4, 22);
            this.tabConfig.Name = "tabConfig";
            this.tabConfig.Padding = new System.Windows.Forms.Padding(3);
            this.tabConfig.Size = new System.Drawing.Size(444, 301);
            this.tabConfig.TabIndex = 4;
            this.tabConfig.Text = "Configuration";
            // 
            // groupReset
            // 
            this.groupReset.Controls.Add(this.radioResetDTR);
            this.groupReset.Controls.Add(this.radioResetRemoteSignal);
            this.groupReset.Controls.Add(this.radioResetRTS);
            this.groupReset.Controls.Add(this.radioResetManual);
            this.groupReset.Location = new System.Drawing.Point(213, 239);
            this.groupReset.Name = "groupReset";
            this.groupReset.Size = new System.Drawing.Size(225, 56);
            this.groupReset.TabIndex = 19;
            this.groupReset.TabStop = false;
            this.groupReset.Text = "Reset Type:";
            this.toolTip.SetToolTip(this.groupReset, "To enter in bootloader mode the device must be reseted and programmation must beg" +
        "in within 1 second.");
            // 
            // radioResetDTR
            // 
            this.radioResetDTR.AutoSize = true;
            this.radioResetDTR.Location = new System.Drawing.Point(71, 35);
            this.radioResetDTR.Name = "radioResetDTR";
            this.radioResetDTR.Size = new System.Drawing.Size(48, 17);
            this.radioResetDTR.TabIndex = 5;
            this.radioResetDTR.Text = "DTR";
            this.toolTip.SetToolTip(this.radioResetDTR, resources.GetString("radioResetDTR.ToolTip"));
            this.radioResetDTR.UseVisualStyleBackColor = true;
            this.radioResetDTR.CheckedChanged += new System.EventHandler(this.radioResetDTR_CheckedChanged);
            // 
            // radioResetRemoteSignal
            // 
            this.radioResetRemoteSignal.AutoSize = true;
            this.radioResetRemoteSignal.Location = new System.Drawing.Point(126, 17);
            this.radioResetRemoteSignal.Name = "radioResetRemoteSignal";
            this.radioResetRemoteSignal.Size = new System.Drawing.Size(94, 17);
            this.radioResetRemoteSignal.TabIndex = 4;
            this.radioResetRemoteSignal.Text = "Remote Signal";
            this.toolTip.SetToolTip(this.radioResetRemoteSignal, "Remote software reset option. So your code (not the bootloader) receives the \"rem" +
        "ote message\" and reboots.");
            this.radioResetRemoteSignal.UseVisualStyleBackColor = true;
            this.radioResetRemoteSignal.CheckedChanged += new System.EventHandler(this.radioResetRemoteSignal_CheckedChanged);
            // 
            // radioResetRTS
            // 
            this.radioResetRTS.AutoSize = true;
            this.radioResetRTS.Checked = true;
            this.radioResetRTS.Location = new System.Drawing.Point(71, 17);
            this.radioResetRTS.Name = "radioResetRTS";
            this.radioResetRTS.Size = new System.Drawing.Size(58, 17);
            this.radioResetRTS.TabIndex = 3;
            this.radioResetRTS.TabStop = true;
            this.radioResetRTS.Text = "RTS   |";
            this.toolTip.SetToolTip(this.radioResetRTS, resources.GetString("radioResetRTS.ToolTip"));
            this.radioResetRTS.UseVisualStyleBackColor = true;
            this.radioResetRTS.CheckedChanged += new System.EventHandler(this.radioRTS_CheckedChanged);
            // 
            // radioResetManual
            // 
            this.radioResetManual.AutoSize = true;
            this.radioResetManual.Location = new System.Drawing.Point(6, 17);
            this.radioResetManual.Name = "radioResetManual";
            this.radioResetManual.Size = new System.Drawing.Size(68, 17);
            this.radioResetManual.TabIndex = 1;
            this.radioResetManual.Text = "Manual  |";
            this.toolTip.SetToolTip(this.radioResetManual, "You must manually reset your device to get it entered in bootloader mode.");
            this.radioResetManual.UseVisualStyleBackColor = true;
            // 
            // groupBoxRemoteSignal
            // 
            this.groupBoxRemoteSignal.Controls.Add(this.textRemoteWait);
            this.groupBoxRemoteSignal.Controls.Add(this.label3);
            this.groupBoxRemoteSignal.Controls.Add(this.textRemoteMessage);
            this.groupBoxRemoteSignal.Controls.Add(this.label2);
            this.groupBoxRemoteSignal.Location = new System.Drawing.Point(3, 217);
            this.groupBoxRemoteSignal.Name = "groupBoxRemoteSignal";
            this.groupBoxRemoteSignal.Size = new System.Drawing.Size(204, 74);
            this.groupBoxRemoteSignal.TabIndex = 18;
            this.groupBoxRemoteSignal.TabStop = false;
            this.groupBoxRemoteSignal.Text = "Remote Reset Signal:";
            // 
            // textRemoteWait
            // 
            this.textRemoteWait.Location = new System.Drawing.Point(157, 43);
            this.textRemoteWait.Name = "textRemoteWait";
            this.textRemoteWait.Size = new System.Drawing.Size(41, 20);
            this.textRemoteWait.TabIndex = 3;
            this.textRemoteWait.Text = "500";
            this.toolTip.SetToolTip(this.textRemoteWait, "Time between the Remote Message sending and the start of the programming.");
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(6, 46);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(150, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Wait before programming (ms):";
            this.toolTip.SetToolTip(this.label3, "Time between the Remote Message sending and the start of the programming.");
            // 
            // textRemoteMessage
            // 
            this.textRemoteMessage.Location = new System.Drawing.Point(105, 17);
            this.textRemoteMessage.Name = "textRemoteMessage";
            this.textRemoteMessage.Size = new System.Drawing.Size(93, 20);
            this.textRemoteMessage.TabIndex = 1;
            this.textRemoteMessage.Text = "65 66 67";
            this.toolTip.SetToolTip(this.textRemoteMessage, "Characters sended during a Remote Signal Reset. Characters are entered in this te" +
        "xt box by their decimal ascii codes separated by spaces. Example: 65 66 67 will " +
        "send ABC");
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 20);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(93, 13);
            this.label2.TabIndex = 0;
            this.label2.Text = "Remote Message:";
            this.toolTip.SetToolTip(this.label2, "Characters sended during a Remote Signal Reset. Characters are entered in this te" +
        "xt box by their decimal ascii codes separated by spaces. Example: 65 66 67 will " +
        "send ABC");
            // 
            // groupBox8
            // 
            this.groupBox8.Controls.Add(this.label31);
            this.groupBox8.Controls.Add(this.label32);
            this.groupBox8.Controls.Add(this.label33);
            this.groupBox8.Controls.Add(this.label34);
            this.groupBox8.Controls.Add(this.textBaudFinal);
            this.groupBox8.Controls.Add(this.textClockFinal);
            this.groupBox8.Controls.Add(this.textClockInit);
            this.groupBox8.Controls.Add(this.textBaudInit);
            this.groupBox8.Controls.Add(this.checkUseSpecialBaudRate);
            this.groupBox8.Location = new System.Drawing.Point(213, 53);
            this.groupBox8.Name = "groupBox8";
            this.groupBox8.Size = new System.Drawing.Size(225, 108);
            this.groupBox8.TabIndex = 17;
            this.groupBox8.TabStop = false;
            this.groupBox8.Text = "Special Baudrate after frequency change";
            // 
            // label31
            // 
            this.label31.AutoSize = true;
            this.label31.Location = new System.Drawing.Point(12, 86);
            this.label31.Name = "label31";
            this.label31.Size = new System.Drawing.Size(32, 13);
            this.label31.TabIndex = 9;
            this.label31.Text = "Final:";
            // 
            // label32
            // 
            this.label32.AutoSize = true;
            this.label32.Location = new System.Drawing.Point(12, 60);
            this.label32.Name = "label32";
            this.label32.Size = new System.Drawing.Size(34, 13);
            this.label32.TabIndex = 8;
            this.label32.Text = "Initial:";
            // 
            // label33
            // 
            this.label33.AutoSize = true;
            this.label33.Location = new System.Drawing.Point(143, 39);
            this.label33.Name = "label33";
            this.label33.Size = new System.Drawing.Size(58, 13);
            this.label33.TabIndex = 7;
            this.label33.Text = "Baud Rate";
            // 
            // label34
            // 
            this.label34.AutoSize = true;
            this.label34.Location = new System.Drawing.Point(54, 39);
            this.label34.Name = "label34";
            this.label34.Size = new System.Drawing.Size(75, 13);
            this.label34.TabIndex = 6;
            this.label34.Text = "PIC clock (Hz)";
            // 
            // textBaudFinal
            // 
            this.textBaudFinal.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.textBaudFinal.Enabled = false;
            this.textBaudFinal.Location = new System.Drawing.Point(133, 83);
            this.textBaudFinal.Name = "textBaudFinal";
            this.textBaudFinal.ReadOnly = true;
            this.textBaudFinal.Size = new System.Drawing.Size(73, 20);
            this.textBaudFinal.TabIndex = 5;
            // 
            // textClockFinal
            // 
            this.textClockFinal.Enabled = false;
            this.textClockFinal.Location = new System.Drawing.Point(54, 83);
            this.textClockFinal.Name = "textClockFinal";
            this.textClockFinal.Size = new System.Drawing.Size(73, 20);
            this.textClockFinal.TabIndex = 4;
            this.textClockFinal.Text = "20000000";
            this.textClockFinal.TextChanged += new System.EventHandler(this.textClockFinal_TextChanged);
            // 
            // textClockInit
            // 
            this.textClockInit.Enabled = false;
            this.textClockInit.Location = new System.Drawing.Point(54, 57);
            this.textClockInit.Name = "textClockInit";
            this.textClockInit.Size = new System.Drawing.Size(73, 20);
            this.textClockInit.TabIndex = 2;
            this.textClockInit.Text = "48000000";
            this.textClockInit.TextChanged += new System.EventHandler(this.textClockInit_TextChanged);
            // 
            // textBaudInit
            // 
            this.textBaudInit.Enabled = false;
            this.textBaudInit.Location = new System.Drawing.Point(133, 57);
            this.textBaudInit.Name = "textBaudInit";
            this.textBaudInit.Size = new System.Drawing.Size(73, 20);
            this.textBaudInit.TabIndex = 3;
            this.textBaudInit.Text = "115200";
            this.textBaudInit.TextChanged += new System.EventHandler(this.textBaudInit_TextChanged);
            // 
            // checkUseSpecialBaudRate
            // 
            this.checkUseSpecialBaudRate.AutoSize = true;
            this.checkUseSpecialBaudRate.Location = new System.Drawing.Point(6, 19);
            this.checkUseSpecialBaudRate.Name = "checkUseSpecialBaudRate";
            this.checkUseSpecialBaudRate.Size = new System.Drawing.Size(187, 17);
            this.checkUseSpecialBaudRate.TabIndex = 0;
            this.checkUseSpecialBaudRate.Text = "Use calculated special Baud Rate";
            this.checkUseSpecialBaudRate.UseVisualStyleBackColor = true;
            this.checkUseSpecialBaudRate.CheckedChanged += new System.EventHandler(this.checkUseSpecialBaudRate_CheckedChanged);
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.checkPowerRTS);
            this.groupBox5.Location = new System.Drawing.Point(3, 165);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(204, 42);
            this.groupBox5.TabIndex = 16;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "RS232 powering:";
            // 
            // checkPowerRTS
            // 
            this.checkPowerRTS.AutoSize = true;
            this.checkPowerRTS.Location = new System.Drawing.Point(9, 19);
            this.checkPowerRTS.Name = "checkPowerRTS";
            this.checkPowerRTS.Size = new System.Drawing.Size(97, 17);
            this.checkPowerRTS.TabIndex = 1;
            this.checkPowerRTS.Text = "by RTS + DTR";
            this.toolTip.SetToolTip(this.checkPowerRTS, resources.GetString("checkPowerRTS.ToolTip"));
            this.checkPowerRTS.UseVisualStyleBackColor = true;
            this.checkPowerRTS.CheckedChanged += new System.EventHandler(this.checkPowerRTS_CheckedChanged);
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.doChoosePiccodes);
            this.groupBox4.Controls.Add(this.textPiccodesPath);
            this.groupBox4.Controls.Add(this.checkForcePiccodes);
            this.groupBox4.Location = new System.Drawing.Point(3, 3);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(427, 46);
            this.groupBox4.TabIndex = 15;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "\"piccodes.ini\" file:";
            // 
            // doChoosePiccodes
            // 
            this.doChoosePiccodes.Enabled = false;
            this.doChoosePiccodes.Location = new System.Drawing.Point(349, 15);
            this.doChoosePiccodes.Name = "doChoosePiccodes";
            this.doChoosePiccodes.Size = new System.Drawing.Size(75, 23);
            this.doChoosePiccodes.TabIndex = 2;
            this.doChoosePiccodes.Text = "Browse";
            this.toolTip.SetToolTip(this.doChoosePiccodes, "Find in you computer the alternate \"piccodes.ini\" you want to use.");
            this.doChoosePiccodes.UseVisualStyleBackColor = true;
            this.doChoosePiccodes.Click += new System.EventHandler(this.doChoosePiccodes_Click);
            // 
            // textPiccodesPath
            // 
            this.textPiccodesPath.Enabled = false;
            this.textPiccodesPath.Location = new System.Drawing.Point(176, 16);
            this.textPiccodesPath.Name = "textPiccodesPath";
            this.textPiccodesPath.Size = new System.Drawing.Size(167, 20);
            this.textPiccodesPath.TabIndex = 1;
            this.toolTip.SetToolTip(this.textPiccodesPath, "Path of the alternate \"piccodes.ini\" that will be used.");
            // 
            // checkForcePiccodes
            // 
            this.checkForcePiccodes.AutoSize = true;
            this.checkForcePiccodes.Location = new System.Drawing.Point(6, 19);
            this.checkForcePiccodes.Name = "checkForcePiccodes";
            this.checkForcePiccodes.Size = new System.Drawing.Size(170, 17);
            this.checkForcePiccodes.TabIndex = 0;
            this.checkForcePiccodes.Text = "Force use of \"piccodes.ini\" file";
            this.toolTip.SetToolTip(this.checkForcePiccodes, "Possibility to use an alternate \"piccodes.ini\". Can be useful for tests purposes " +
        "of the devices\' properties.");
            this.checkForcePiccodes.UseVisualStyleBackColor = true;
            this.checkForcePiccodes.CheckedChanged += new System.EventHandler(this.checkForcePiccodes_CheckedChanged);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.label36);
            this.groupBox3.Controls.Add(this.textNbChecks);
            this.groupBox3.Controls.Add(this.label37);
            this.groupBox3.Controls.Add(this.textDelayCheck);
            this.groupBox3.Controls.Add(this.label38);
            this.groupBox3.Controls.Add(this.textReadTimeOut);
            this.groupBox3.Location = new System.Drawing.Point(3, 56);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(204, 97);
            this.groupBox3.TabIndex = 14;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "COM parameters:";
            // 
            // label36
            // 
            this.label36.AutoSize = true;
            this.label36.Location = new System.Drawing.Point(6, 66);
            this.label36.Name = "label36";
            this.label36.Size = new System.Drawing.Size(97, 13);
            this.label36.TabIndex = 6;
            this.label36.Text = "Number of checks:";
            this.toolTip.SetToolTip(this.label36, "Number of requests from the PC during a Check Device");
            // 
            // textNbChecks
            // 
            this.textNbChecks.Location = new System.Drawing.Point(148, 63);
            this.textNbChecks.Name = "textNbChecks";
            this.textNbChecks.Size = new System.Drawing.Size(45, 20);
            this.textNbChecks.TabIndex = 7;
            this.textNbChecks.Text = "10";
            this.toolTip.SetToolTip(this.textNbChecks, "Number of requests from the PC during a Check Device");
            // 
            // label37
            // 
            this.label37.AutoSize = true;
            this.label37.Location = new System.Drawing.Point(6, 41);
            this.label37.Name = "label37";
            this.label37.Size = new System.Drawing.Size(136, 13);
            this.label37.TabIndex = 4;
            this.label37.Text = "Delay between check (ms):";
            this.toolTip.SetToolTip(this.label37, "Time to wait between two successive requests from the PC during a Check Device");
            // 
            // textDelayCheck
            // 
            this.textDelayCheck.Location = new System.Drawing.Point(148, 38);
            this.textDelayCheck.Name = "textDelayCheck";
            this.textDelayCheck.Size = new System.Drawing.Size(45, 20);
            this.textDelayCheck.TabIndex = 5;
            this.textDelayCheck.Text = "200";
            this.toolTip.SetToolTip(this.textDelayCheck, "Time to wait between two successive requests from the PC during a Check Device");
            // 
            // label38
            // 
            this.label38.AutoSize = true;
            this.label38.Location = new System.Drawing.Point(6, 16);
            this.label38.Name = "label38";
            this.label38.Size = new System.Drawing.Size(104, 13);
            this.label38.TabIndex = 2;
            this.label38.Text = "Read Time Out (ms):";
            this.toolTip.SetToolTip(this.label38, "Amount of time the PC will wait for the device\'s answer. nIf this duration is exc" +
        "eeded, the PC considers there will be no answer.");
            // 
            // textReadTimeOut
            // 
            this.textReadTimeOut.Location = new System.Drawing.Point(148, 13);
            this.textReadTimeOut.Name = "textReadTimeOut";
            this.textReadTimeOut.Size = new System.Drawing.Size(45, 20);
            this.textReadTimeOut.TabIndex = 3;
            this.textReadTimeOut.Text = "200";
            this.toolTip.SetToolTip(this.textReadTimeOut, "Amount of time the PC will wait for the device\'s answer. If this duration is exce" +
        "eded, the PC considers there will be no answer.");
            // 
            // groupBoxRTSreset
            // 
            this.groupBoxRTSreset.Controls.Add(this.pictureBox1);
            this.groupBoxRTSreset.Controls.Add(this.label40);
            this.groupBoxRTSreset.Controls.Add(this.textRTSFalse);
            this.groupBoxRTSreset.Controls.Add(this.textRTSTrue);
            this.groupBoxRTSreset.Controls.Add(this.label41);
            this.groupBoxRTSreset.Location = new System.Drawing.Point(213, 165);
            this.groupBoxRTSreset.Name = "groupBoxRTSreset";
            this.groupBoxRTSreset.Size = new System.Drawing.Size(225, 74);
            this.groupBoxRTSreset.TabIndex = 12;
            this.groupBoxRTSreset.TabStop = false;
            this.groupBoxRTSreset.Text = "RTS (or DTR) Reset (on !MCLR pin):";
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(144, 15);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(75, 53);
            this.pictureBox1.TabIndex = 4;
            this.pictureBox1.TabStop = false;
            // 
            // label40
            // 
            this.label40.AutoSize = true;
            this.label40.Location = new System.Drawing.Point(5, 22);
            this.label40.Name = "label40";
            this.label40.Size = new System.Drawing.Size(103, 13);
            this.label40.TabIndex = 0;
            this.label40.Text = "RTS/DTR true (ms):";
            this.toolTip.SetToolTip(this.label40, "Duration of reset on the !RESET pin for AVR devices, or the !MCLR pin for PIC dev" +
        "ices, pulled down to ground by !RTS pin. . If there is  a capacitor on this pin," +
        " you should increase this value.");
            // 
            // textRTSFalse
            // 
            this.textRTSFalse.Location = new System.Drawing.Point(110, 45);
            this.textRTSFalse.Name = "textRTSFalse";
            this.textRTSFalse.Size = new System.Drawing.Size(30, 20);
            this.textRTSFalse.TabIndex = 3;
            this.textRTSFalse.Text = "100";
            this.toolTip.SetToolTip(this.textRTSFalse, "Duration between reset and start of programming.  If there is  a capacitor on !MC" +
        "LR or !RESET pin, you should increase this value.");
            // 
            // textRTSTrue
            // 
            this.textRTSTrue.Location = new System.Drawing.Point(110, 19);
            this.textRTSTrue.Name = "textRTSTrue";
            this.textRTSTrue.Size = new System.Drawing.Size(30, 20);
            this.textRTSTrue.TabIndex = 1;
            this.textRTSTrue.Text = "200";
            this.toolTip.SetToolTip(this.textRTSTrue, "Duration of reset on the !RESET pin for AVR devices, or the !MCLR pin for PIC dev" +
        "ices, pulled down to ground by !RTS pin. If there is  a capacitor on this pin, y" +
        "ou should increase this value.");
            // 
            // label41
            // 
            this.label41.AutoSize = true;
            this.label41.Location = new System.Drawing.Point(5, 48);
            this.label41.Name = "label41";
            this.label41.Size = new System.Drawing.Size(107, 13);
            this.label41.TabIndex = 2;
            this.label41.Text = "RTS/DTR false (ms):";
            this.toolTip.SetToolTip(this.label41, "Duration between reset and start of programming.  If there is  a capacitor on !MC" +
        "LR or !RESET pin, you should increase this value.");
            // 
            // tabFirmware
            // 
            this.tabFirmware.Controls.Add(this.textDefaultBaudRate);
            this.tabFirmware.Controls.Add(this.textFirmwareFileName);
            this.tabFirmware.Controls.Add(this.label30);
            this.tabFirmware.Controls.Add(this.tb_Test);
            this.tabFirmware.Controls.Add(this.label44);
            this.tabFirmware.Controls.Add(this.comboFirmwareFlavour);
            this.tabFirmware.Controls.Add(this.b_flashDevice);
            this.tabFirmware.Controls.Add(this.label35);
            this.tabFirmware.Controls.Add(this.textFreq);
            this.tabFirmware.Controls.Add(this.label42);
            this.tabFirmware.Controls.Add(this.textDefaultTXpin);
            this.tabFirmware.Controls.Add(this.textDefaultRXpin);
            this.tabFirmware.Controls.Add(this.textClockType);
            this.tabFirmware.Controls.Add(this.label29);
            this.tabFirmware.Controls.Add(this.label28);
            this.tabFirmware.Controls.Add(this.label27);
            this.tabFirmware.Controls.Add(this.label23);
            this.tabFirmware.Controls.Add(this.label22);
            this.tabFirmware.Controls.Add(this.comboFirmwareDevice);
            this.tabFirmware.Controls.Add(this.comboFirmwareBrand);
            this.tabFirmware.Controls.Add(this.doChooseFirmwaresFolder);
            this.tabFirmware.Controls.Add(this.textBoxFirmwareFolder);
            this.tabFirmware.Controls.Add(this.groupBox1);
            this.tabFirmware.Controls.Add(this.label9);
            this.tabFirmware.Location = new System.Drawing.Point(4, 22);
            this.tabFirmware.Name = "tabFirmware";
            this.tabFirmware.Padding = new System.Windows.Forms.Padding(3);
            this.tabFirmware.Size = new System.Drawing.Size(444, 301);
            this.tabFirmware.TabIndex = 5;
            this.tabFirmware.Text = "Firmwares";
            this.tabFirmware.UseVisualStyleBackColor = true;
            // 
            // textDefaultBaudRate
            // 
            this.textDefaultBaudRate.BackColor = System.Drawing.SystemColors.Window;
            this.textDefaultBaudRate.Location = new System.Drawing.Point(237, 65);
            this.textDefaultBaudRate.Name = "textDefaultBaudRate";
            this.textDefaultBaudRate.ReadOnly = true;
            this.textDefaultBaudRate.Size = new System.Drawing.Size(49, 20);
            this.textDefaultBaudRate.TabIndex = 17;
            this.textDefaultBaudRate.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.toolTip.SetToolTip(this.textDefaultBaudRate, "Default Baudrate used by the firmware to communicate with the computer");
            // 
            // textFirmwareFileName
            // 
            this.textFirmwareFileName.Location = new System.Drawing.Point(80, 137);
            this.textFirmwareFileName.Name = "textFirmwareFileName";
            this.textFirmwareFileName.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.textFirmwareFileName.Size = new System.Drawing.Size(272, 20);
            this.textFirmwareFileName.TabIndex = 27;
            this.toolTip.SetToolTip(this.textFirmwareFileName, "Firmware \".hex\" file of the selected device and flavour");
            // 
            // label30
            // 
            this.label30.AutoSize = true;
            this.label30.Location = new System.Drawing.Point(177, 68);
            this.label30.Name = "label30";
            this.label30.Size = new System.Drawing.Size(58, 13);
            this.label30.TabIndex = 15;
            this.label30.Text = "BaudRate:";
            this.toolTip.SetToolTip(this.label30, "Default Baudrate used by the firmware to communicate with the computer");
            // 
            // tb_Test
            // 
            this.tb_Test.BackColor = System.Drawing.SystemColors.HighlightText;
            this.tb_Test.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tb_Test.Location = new System.Drawing.Point(15, 166);
            this.tb_Test.Multiline = true;
            this.tb_Test.Name = "tb_Test";
            this.tb_Test.ReadOnly = true;
            this.tb_Test.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.tb_Test.Size = new System.Drawing.Size(415, 118);
            this.tb_Test.TabIndex = 27;
            this.toolTip.SetToolTip(this.tb_Test, "Displays the communications with the PIC programmer");
            // 
            // label44
            // 
            this.label44.AutoSize = true;
            this.label44.Location = new System.Drawing.Point(313, 36);
            this.label44.Name = "label44";
            this.label44.Size = new System.Drawing.Size(45, 13);
            this.label44.TabIndex = 26;
            this.label44.Text = "Flavour:";
            this.toolTip.SetToolTip(this.label44, "Select the Flavour of the firmware (if more than one available)");
            // 
            // comboFirmwareFlavour
            // 
            this.comboFirmwareFlavour.FormattingEnabled = true;
            this.comboFirmwareFlavour.Location = new System.Drawing.Point(360, 33);
            this.comboFirmwareFlavour.Name = "comboFirmwareFlavour";
            this.comboFirmwareFlavour.Size = new System.Drawing.Size(78, 21);
            this.comboFirmwareFlavour.TabIndex = 25;
            this.toolTip.SetToolTip(this.comboFirmwareFlavour, "Select the Flavour of the firmware (if more than one available)");
            this.comboFirmwareFlavour.SelectedIndexChanged += new System.EventHandler(this.comboFirmwareFlavour_SelectedIndexChanged);
            // 
            // b_flashDevice
            // 
            this.b_flashDevice.Location = new System.Drawing.Point(358, 136);
            this.b_flashDevice.Name = "b_flashDevice";
            this.b_flashDevice.Size = new System.Drawing.Size(79, 23);
            this.b_flashDevice.TabIndex = 25;
            this.b_flashDevice.Text = "Flash Device";
            this.toolTip.SetToolTip(this.b_flashDevice, "Flash the firmware \".hex\" file to your PIC");
            this.b_flashDevice.UseVisualStyleBackColor = true;
            this.b_flashDevice.Click += new System.EventHandler(this.b_flashDevice_Click);
            // 
            // label35
            // 
            this.label35.AutoSize = true;
            this.label35.Location = new System.Drawing.Point(7, 140);
            this.label35.Name = "label35";
            this.label35.Size = new System.Drawing.Size(71, 13);
            this.label35.TabIndex = 24;
            this.label35.Text = "Firmware File:";
            this.toolTip.SetToolTip(this.label35, "Firmware \".hex\" file of the selected device and flavour");
            // 
            // textFreq
            // 
            this.textFreq.BackColor = System.Drawing.SystemColors.Window;
            this.textFreq.Location = new System.Drawing.Point(127, 65);
            this.textFreq.Name = "textFreq";
            this.textFreq.ReadOnly = true;
            this.textFreq.Size = new System.Drawing.Size(45, 20);
            this.textFreq.TabIndex = 24;
            this.textFreq.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.toolTip.SetToolTip(this.textFreq, "Internal frequency defined in the firmware OR frequency of the needed quartz");
            // 
            // label42
            // 
            this.label42.AutoSize = true;
            this.label42.Location = new System.Drawing.Point(94, 68);
            this.label42.Name = "label42";
            this.label42.Size = new System.Drawing.Size(31, 13);
            this.label42.TabIndex = 23;
            this.label42.Text = "Freq:";
            this.toolTip.SetToolTip(this.label42, "Internal frequency defined in the firmware OR frequency of the needed quartz");
            // 
            // textDefaultTXpin
            // 
            this.textDefaultTXpin.BackColor = System.Drawing.SystemColors.Window;
            this.textDefaultTXpin.Location = new System.Drawing.Point(411, 65);
            this.textDefaultTXpin.Name = "textDefaultTXpin";
            this.textDefaultTXpin.ReadOnly = true;
            this.textDefaultTXpin.Size = new System.Drawing.Size(32, 20);
            this.textDefaultTXpin.TabIndex = 20;
            this.textDefaultTXpin.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.toolTip.SetToolTip(this.textDefaultTXpin, "Pin on the microcontroller used as TX pin to communicate with the PC \n(will need " +
        "to be connected with RX pin on the PC side)");
            // 
            // textDefaultRXpin
            // 
            this.textDefaultRXpin.BackColor = System.Drawing.SystemColors.Window;
            this.textDefaultRXpin.Location = new System.Drawing.Point(334, 65);
            this.textDefaultRXpin.Name = "textDefaultRXpin";
            this.textDefaultRXpin.ReadOnly = true;
            this.textDefaultRXpin.Size = new System.Drawing.Size(32, 20);
            this.textDefaultRXpin.TabIndex = 19;
            this.textDefaultRXpin.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.toolTip.SetToolTip(this.textDefaultRXpin, "Pin on the microcontroller used as RX pin to communicate with the PC \n(will need " +
        "to be connected with TX pin on the PC side)");
            // 
            // textClockType
            // 
            this.textClockType.BackColor = System.Drawing.SystemColors.Window;
            this.textClockType.Location = new System.Drawing.Point(41, 65);
            this.textClockType.Name = "textClockType";
            this.textClockType.ReadOnly = true;
            this.textClockType.Size = new System.Drawing.Size(49, 20);
            this.textClockType.TabIndex = 16;
            this.textClockType.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.toolTip.SetToolTip(this.textClockType, "Tell if the microcontroller use it\'s internal clock OR an external quartz");
            // 
            // label29
            // 
            this.label29.AutoSize = true;
            this.label29.Location = new System.Drawing.Point(370, 68);
            this.label29.Name = "label29";
            this.label29.Size = new System.Drawing.Size(41, 13);
            this.label29.TabIndex = 14;
            this.label29.Text = "TX pin:";
            this.toolTip.SetToolTip(this.label29, "Pin on the microcontroller used as TX pin to communicate with the PC \n(will need " +
        "to be connected with RX pin on the PC side)");
            // 
            // label28
            // 
            this.label28.AutoSize = true;
            this.label28.Location = new System.Drawing.Point(292, 68);
            this.label28.Name = "label28";
            this.label28.Size = new System.Drawing.Size(42, 13);
            this.label28.TabIndex = 13;
            this.label28.Text = "RX pin:";
            this.toolTip.SetToolTip(this.label28, "Pin on the microcontroller used as RX pin to communicate with the PC \n(will need " +
        "to be connected with TX pin on the PC side)");
            // 
            // label27
            // 
            this.label27.AutoSize = true;
            this.label27.Location = new System.Drawing.Point(5, 68);
            this.label27.Name = "label27";
            this.label27.Size = new System.Drawing.Size(37, 13);
            this.label27.TabIndex = 12;
            this.label27.Text = "Clock:";
            this.toolTip.SetToolTip(this.label27, "Tell if the microcontroller use it\'s internal clock OR an external quartz");
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Location = new System.Drawing.Point(134, 36);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(44, 13);
            this.label23.TabIndex = 11;
            this.label23.Text = "Device:";
            this.toolTip.SetToolTip(this.label23, "Select the microcontroller device you want the infos");
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(7, 36);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(38, 13);
            this.label22.TabIndex = 10;
            this.label22.Text = "Brand:";
            this.toolTip.SetToolTip(this.label22, "Select the microcontroller\'s brand you want the infos");
            // 
            // comboFirmwareDevice
            // 
            this.comboFirmwareDevice.FormattingEnabled = true;
            this.comboFirmwareDevice.Location = new System.Drawing.Point(181, 33);
            this.comboFirmwareDevice.Name = "comboFirmwareDevice";
            this.comboFirmwareDevice.Size = new System.Drawing.Size(126, 21);
            this.comboFirmwareDevice.TabIndex = 9;
            this.toolTip.SetToolTip(this.comboFirmwareDevice, "Select the microcontroller device you want the infos");
            this.comboFirmwareDevice.SelectedIndexChanged += new System.EventHandler(this.comboFirmwareDevice_SelectedIndexChanged);
            // 
            // comboFirmwareBrand
            // 
            this.comboFirmwareBrand.FormattingEnabled = true;
            this.comboFirmwareBrand.Location = new System.Drawing.Point(47, 33);
            this.comboFirmwareBrand.Name = "comboFirmwareBrand";
            this.comboFirmwareBrand.Size = new System.Drawing.Size(75, 21);
            this.comboFirmwareBrand.TabIndex = 8;
            this.toolTip.SetToolTip(this.comboFirmwareBrand, "Select the microcontroller\'s brand you want the infos");
            this.comboFirmwareBrand.SelectedIndexChanged += new System.EventHandler(this.comboFirmwareBrand_SelectedIndexChanged);
            // 
            // doChooseFirmwaresFolder
            // 
            this.doChooseFirmwaresFolder.Location = new System.Drawing.Point(363, 6);
            this.doChooseFirmwaresFolder.Name = "doChooseFirmwaresFolder";
            this.doChooseFirmwaresFolder.Size = new System.Drawing.Size(75, 23);
            this.doChooseFirmwaresFolder.TabIndex = 7;
            this.doChooseFirmwaresFolder.Text = "Browse";
            this.toolTip.SetToolTip(this.doChooseFirmwaresFolder, "Find in you computer the \"Firmwares\" folder where are located all the firmwares a" +
        "nd \"firmwares.ini\" file");
            this.doChooseFirmwaresFolder.UseVisualStyleBackColor = true;
            this.doChooseFirmwaresFolder.Click += new System.EventHandler(this.doChooseFirmwaresFolder_Click);
            // 
            // textBoxFirmwareFolder
            // 
            this.textBoxFirmwareFolder.Location = new System.Drawing.Point(109, 7);
            this.textBoxFirmwareFolder.Name = "textBoxFirmwareFolder";
            this.textBoxFirmwareFolder.Size = new System.Drawing.Size(248, 20);
            this.textBoxFirmwareFolder.TabIndex = 6;
            this.toolTip.SetToolTip(this.textBoxFirmwareFolder, "Path to the \"Firmwares\" folder where are located all the firmwares and \"firmwares" +
        ".ini\" file");
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.checkProgrammerVDD);
            this.groupBox1.Controls.Add(this.doChooseIPEfolder);
            this.groupBox1.Controls.Add(this.textBoxIPEfolderPath);
            this.groupBox1.Controls.Add(this.label43);
            this.groupBox1.Controls.Add(this.label8);
            this.groupBox1.Controls.Add(this.comboPicProgrammer);
            this.groupBox1.Location = new System.Drawing.Point(3, 87);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(438, 44);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "PIC:";
            // 
            // checkProgrammerVDD
            // 
            this.checkProgrammerVDD.AutoSize = true;
            this.checkProgrammerVDD.Location = new System.Drawing.Point(386, 18);
            this.checkProgrammerVDD.Name = "checkProgrammerVDD";
            this.checkProgrammerVDD.Size = new System.Drawing.Size(49, 17);
            this.checkProgrammerVDD.TabIndex = 27;
            this.checkProgrammerVDD.Text = "VDD";
            this.toolTip.SetToolTip(this.checkProgrammerVDD, "Apply VDD through the programmer");
            this.checkProgrammerVDD.UseVisualStyleBackColor = true;
            // 
            // doChooseIPEfolder
            // 
            this.doChooseIPEfolder.Location = new System.Drawing.Point(203, 16);
            this.doChooseIPEfolder.Name = "doChooseIPEfolder";
            this.doChooseIPEfolder.Size = new System.Drawing.Size(75, 23);
            this.doChooseIPEfolder.TabIndex = 4;
            this.doChooseIPEfolder.Text = "Browse";
            this.toolTip.SetToolTip(this.doChooseIPEfolder, resources.GetString("doChooseIPEfolder.ToolTip"));
            this.doChooseIPEfolder.UseVisualStyleBackColor = true;
            this.doChooseIPEfolder.Click += new System.EventHandler(this.doChooseIPEfolder_Click);
            // 
            // textBoxIPEfolderPath
            // 
            this.textBoxIPEfolderPath.Location = new System.Drawing.Point(58, 17);
            this.textBoxIPEfolderPath.Name = "textBoxIPEfolderPath";
            this.textBoxIPEfolderPath.Size = new System.Drawing.Size(139, 20);
            this.textBoxIPEfolderPath.TabIndex = 3;
            this.textBoxIPEfolderPath.Text = "\"ipecmd.exe\" not found";
            this.toolTip.SetToolTip(this.textBoxIPEfolderPath, "Path of the \"ipecmd.exe\" Microchip\'s software \nused to flash microcontroller with" +
        " your usual PIC programmer\n(should be in \"C:\\Program Files (x86)\\Microchip\\MPLAB" +
        "X\\vX.X0\\mplab_ipe\" folder)");
            // 
            // label43
            // 
            this.label43.AutoSize = true;
            this.label43.Location = new System.Drawing.Point(280, 20);
            this.label43.Name = "label43";
            this.label43.Size = new System.Drawing.Size(32, 13);
            this.label43.TabIndex = 25;
            this.label43.Text = "Prog:";
            this.toolTip.SetToolTip(this.label43, "Programmer to use for flashing the firmware in your PIC device");
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(5, 21);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(51, 13);
            this.label8.TabIndex = 0;
            this.label8.Text = "IPECMD:";
            this.toolTip.SetToolTip(this.label8, "Path of the \"ipecmd.exe\" Microchip\'s software \nused to flash microcontroller with" +
        " your usual PIC programmer\n(should be in \"C:\\Program Files (x86)\\Microchip\\MPLAB" +
        "X\\vX.X0\\mplab_ipe\" folder)");
            // 
            // comboPicProgrammer
            // 
            this.comboPicProgrammer.FormattingEnabled = true;
            this.comboPicProgrammer.Items.AddRange(new object[] {
            "Pickit3",
            "ICD3",
            "Real Ice",
            "PM3",
            "PKOB"});
            this.comboPicProgrammer.Location = new System.Drawing.Point(313, 16);
            this.comboPicProgrammer.Name = "comboPicProgrammer";
            this.comboPicProgrammer.Size = new System.Drawing.Size(67, 21);
            this.comboPicProgrammer.TabIndex = 26;
            this.toolTip.SetToolTip(this.comboPicProgrammer, "Programmer to use for flashing the firmware in your PIC device");
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(12, 11);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(96, 13);
            this.label9.TabIndex = 5;
            this.label9.Text = "\"Firmwares\" folder:";
            this.toolTip.SetToolTip(this.label9, "Path to the \"Firmwares\" folder where are located all the firmwares and \"firmwares" +
        ".ini\" file");
            // 
            // toolTip
            // 
            this.toolTip.IsBalloon = true;
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.label25);
            this.panel1.Controls.Add(this.checkEraseEEPROM);
            this.panel1.Controls.Add(this.checkFile);
            this.panel1.Controls.Add(this.checkWriteConfig);
            this.panel1.Controls.Add(this.checkWriteEEPROM);
            this.panel1.Controls.Add(this.checkWriteFlashProg);
            this.panel1.Location = new System.Drawing.Point(9, 369);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(555, 48);
            this.panel1.TabIndex = 17;
            // 
            // checkShowToolTip
            // 
            this.checkShowToolTip.AutoSize = true;
            this.checkShowToolTip.Checked = true;
            this.checkShowToolTip.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkShowToolTip.Location = new System.Drawing.Point(277, 426);
            this.checkShowToolTip.Name = "checkShowToolTip";
            this.checkShowToolTip.Size = new System.Drawing.Size(101, 17);
            this.checkShowToolTip.TabIndex = 19;
            this.checkShowToolTip.Text = "Show Help Tips";
            this.checkShowToolTip.UseVisualStyleBackColor = true;
            this.checkShowToolTip.CheckedChanged += new System.EventHandler(this.checkShowToolTip_CheckedChanged);
            // 
            // linkDoc
            // 
            this.linkDoc.AutoSize = true;
            this.linkDoc.Location = new System.Drawing.Point(403, 419);
            this.linkDoc.Name = "linkDoc";
            this.linkDoc.Size = new System.Drawing.Size(60, 13);
            this.linkDoc.TabIndex = 20;
            this.linkDoc.TabStop = true;
            this.linkDoc.Text = "Online Doc";
            this.linkDoc.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkDoc_LinkClicked);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(0, 419);
            this.label7.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(101, 13);
            this.label7.TabIndex = 22;
            this.label7.Text = "Supported Devices:";
            // 
            // link8051List
            // 
            this.link8051List.AutoSize = true;
            this.link8051List.Location = new System.Drawing.Point(62, 434);
            this.link8051List.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.link8051List.Name = "link8051List";
            this.link8051List.Size = new System.Drawing.Size(31, 13);
            this.link8051List.TabIndex = 23;
            this.link8051List.TabStop = true;
            this.link8051List.Text = "8051";
            this.link8051List.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.link8051List_LinkClicked);
            // 
            // linkAtmelList
            // 
            this.linkAtmelList.AutoSize = true;
            this.linkAtmelList.Location = new System.Drawing.Point(116, 419);
            this.linkAtmelList.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.linkAtmelList.Name = "linkAtmelList";
            this.linkAtmelList.Size = new System.Drawing.Size(33, 13);
            this.linkAtmelList.TabIndex = 24;
            this.linkAtmelList.TabStop = true;
            this.linkAtmelList.Text = "Atmel";
            this.linkAtmelList.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkAtmelList_LinkClicked);
            // 
            // linkMicrochipList
            // 
            this.linkMicrochipList.AutoSize = true;
            this.linkMicrochipList.Location = new System.Drawing.Point(116, 434);
            this.linkMicrochipList.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.linkMicrochipList.Name = "linkMicrochipList";
            this.linkMicrochipList.Size = new System.Drawing.Size(53, 13);
            this.linkMicrochipList.TabIndex = 25;
            this.linkMicrochipList.TabStop = true;
            this.linkMicrochipList.Text = "Microchip";
            this.linkMicrochipList.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkMicrochipList_LinkClicked);
            // 
            // linkNxpList
            // 
            this.linkNxpList.AutoSize = true;
            this.linkNxpList.Location = new System.Drawing.Point(195, 419);
            this.linkNxpList.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.linkNxpList.Name = "linkNxpList";
            this.linkNxpList.Size = new System.Drawing.Size(29, 13);
            this.linkNxpList.TabIndex = 26;
            this.linkNxpList.TabStop = true;
            this.linkNxpList.Text = "NXP";
            this.linkNxpList.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkNxpList_LinkClicked);
            // 
            // linkTiList
            // 
            this.linkTiList.AutoSize = true;
            this.linkTiList.Location = new System.Drawing.Point(195, 434);
            this.linkTiList.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.linkTiList.Name = "linkTiList";
            this.linkTiList.Size = new System.Drawing.Size(17, 13);
            this.linkTiList.TabIndex = 27;
            this.linkTiList.TabStop = true;
            this.linkTiList.Text = "TI";
            this.linkTiList.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkTiList_LinkClicked);
            // 
            // openIPEcmdFile
            // 
            this.openIPEcmdFile.Filter = "ipecmd.exe|ipecmd.exe|exe files|*.exe";
            this.openIPEcmdFile.FileOk += new System.ComponentModel.CancelEventHandler(this.openIPEcmdFile_FileOk);
            // 
            // buttonDonate
            // 
            this.buttonDonate.Font = new System.Drawing.Font("Courier New", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonDonate.Image = ((System.Drawing.Image)(resources.GetObject("buttonDonate.Image")));
            this.buttonDonate.ImageAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.buttonDonate.Location = new System.Drawing.Point(489, 422);
            this.buttonDonate.Name = "buttonDonate";
            this.buttonDonate.Size = new System.Drawing.Size(74, 23);
            this.buttonDonate.TabIndex = 21;
            this.buttonDonate.Text = "Donate";
            this.buttonDonate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.buttonDonate.UseVisualStyleBackColor = true;
            this.buttonDonate.Click += new System.EventHandler(this.buttonDonate_Click);
            // 
            // Form1
            // 
            this.AllowDrop = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(571, 449);
            this.Controls.Add(this.linkTiList);
            this.Controls.Add(this.linkNxpList);
            this.Controls.Add(this.linkMicrochipList);
            this.Controls.Add(this.linkAtmelList);
            this.Controls.Add(this.link8051List);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.buttonDonate);
            this.Controls.Add(this.linkDoc);
            this.Controls.Add(this.checkShowToolTip);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.linkOnlineSupport);
            this.Controls.Add(this.buttonAbort);
            this.Controls.Add(this.buttonWrite);
            this.Controls.Add(this.buttonCheck);
            this.Controls.Add(this.buttonAutoDetect);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.tabControl);
            this.Controls.Add(this.groupComm);
            this.Controls.Add(this.doBrowse);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.listHexFiles);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Tiny Multi Bootloader+ (v0.11.0)";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_Closing);
            this.Load += new System.EventHandler(this.Form1_Load);
            this.Shown += new System.EventHandler(this.Form1_Shown);
            this.DragDrop += new System.Windows.Forms.DragEventHandler(this.Form1_DragDrop);
            this.DragEnter += new System.Windows.Forms.DragEventHandler(this.Form1_DragEnter);
            this.groupComm.ResumeLayout(false);
            this.groupComm.PerformLayout();
            this.tabAbout.ResumeLayout(false);
            this.tabAbout.PerformLayout();
            this.tabDebug.ResumeLayout(false);
            this.groupBox10.ResumeLayout(false);
            this.groupBox10.PerformLayout();
            this.groupBox7.ResumeLayout(false);
            this.groupBox7.PerformLayout();
            this.groupBox6.ResumeLayout(false);
            this.groupBox6.PerformLayout();
            this.tabMessages.ResumeLayout(false);
            this.tabMessages.PerformLayout();
            this.tabControl.ResumeLayout(false);
            this.tabConfig.ResumeLayout(false);
            this.groupReset.ResumeLayout(false);
            this.groupReset.PerformLayout();
            this.groupBoxRemoteSignal.ResumeLayout(false);
            this.groupBoxRemoteSignal.PerformLayout();
            this.groupBox8.ResumeLayout(false);
            this.groupBox8.PerformLayout();
            this.groupBox5.ResumeLayout(false);
            this.groupBox5.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBoxRTSreset.ResumeLayout(false);
            this.groupBoxRTSreset.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.tabFirmware.ResumeLayout(false);
            this.tabFirmware.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox listHexFiles;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button doBrowse;
        private System.Windows.Forms.OpenFileDialog openHexFile;
        private System.IO.Ports.SerialPort serialPort;
        private System.Windows.Forms.GroupBox groupComm;
        private System.Windows.Forms.ComboBox comboBaudSelect;
        private System.Windows.Forms.ListBox listDetectedCOM;
        private System.Windows.Forms.TextBox selectedCOM;
        private System.Windows.Forms.Button buttonSearch;
        private System.Windows.Forms.CheckBox checkFile;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.OpenFileDialog openPiccodesFile;
        private System.Windows.Forms.CheckBox checkWriteEEPROM;
        private System.Windows.Forms.Button buttonWrite;
        private System.Windows.Forms.Button buttonCheck;
        private System.Windows.Forms.Button buttonAutoDetect;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.Button buttonAbort;
        private System.Windows.Forms.Label label25;
        private System.Windows.Forms.CheckBox checkWriteFlashProg;
        private System.Windows.Forms.LinkLabel linkOnlineSupport;
        private System.Windows.Forms.CheckBox checkWriteConfig;
        private System.Windows.Forms.CheckBox checkEraseEEPROM;
        private System.Windows.Forms.TabPage tabAbout;
        private System.Windows.Forms.Label label26;
        private System.Windows.Forms.LinkLabel linkSourceForge;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.LinkLabel linkCChiculita;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.TabPage tabDebug;
        private System.Windows.Forms.GroupBox groupBox7;
        private System.Windows.Forms.TextBox textRawTransfert;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.TextBox textVirtualPICFam;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox textVirtualPIC;
        private System.Windows.Forms.CheckBox checkVirtualPIC;
        private System.Windows.Forms.TabPage tabMessages;
        private System.Windows.Forms.TextBox textMessages;
        private System.Windows.Forms.TabControl tabControl;
        private System.Windows.Forms.TabPage tabConfig;
        private System.Windows.Forms.GroupBox groupBox8;
        private System.Windows.Forms.Label label31;
        private System.Windows.Forms.Label label32;
        private System.Windows.Forms.Label label33;
        private System.Windows.Forms.Label label34;
        private System.Windows.Forms.TextBox textBaudFinal;
        private System.Windows.Forms.TextBox textClockFinal;
        private System.Windows.Forms.TextBox textClockInit;
        private System.Windows.Forms.TextBox textBaudInit;
        private System.Windows.Forms.CheckBox checkUseSpecialBaudRate;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.CheckBox checkPowerRTS;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Button doChoosePiccodes;
        private System.Windows.Forms.TextBox textPiccodesPath;
        private System.Windows.Forms.CheckBox checkForcePiccodes;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Label label36;
        private System.Windows.Forms.TextBox textNbChecks;
        private System.Windows.Forms.Label label37;
        private System.Windows.Forms.TextBox textDelayCheck;
        private System.Windows.Forms.Label label38;
        private System.Windows.Forms.TextBox textReadTimeOut;
        private System.Windows.Forms.GroupBox groupBoxRTSreset;
        private System.Windows.Forms.Label label40;
        private System.Windows.Forms.TextBox textRTSFalse;
        private System.Windows.Forms.TextBox textRTSTrue;
        private System.Windows.Forms.Label label41;
        private System.Windows.Forms.GroupBox groupBoxRemoteSignal;
        private System.Windows.Forms.ToolTip toolTip;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.CheckBox checkShowToolTip;
        private System.Windows.Forms.GroupBox groupBox10;
        private System.Windows.Forms.Label label39;
        private System.Windows.Forms.CheckBox checkShowFile;
        private System.Windows.Forms.CheckBox checkShowCheckFile;
        private System.Windows.Forms.CheckBox checkShowAnswer;
        private System.Windows.Forms.CheckBox checkShowTransfert;
        private System.Windows.Forms.CheckBox checkShowAutoDetect;
        private System.Windows.Forms.TextBox textRemoteWait;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textRemoteMessage;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.LinkLabel linkDoc;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.GroupBox groupReset;
        private System.Windows.Forms.RadioButton radioResetRemoteSignal;
        private System.Windows.Forms.RadioButton radioResetRTS;
        private System.Windows.Forms.RadioButton radioResetManual;
        private System.Windows.Forms.Button buttonDonate;
        private System.Windows.Forms.RadioButton radioResetDTR;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.LinkLabel link8051List;
        private System.Windows.Forms.LinkLabel linkAtmelList;
        private System.Windows.Forms.LinkLabel linkMicrochipList;
        private System.Windows.Forms.LinkLabel linkNxpList;
        private System.Windows.Forms.LinkLabel linkTiList;
        private System.Windows.Forms.TabPage tabFirmware;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button doChooseFirmwaresFolder;
        private System.Windows.Forms.TextBox textBoxFirmwareFolder;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Button doChooseIPEfolder;
        private System.Windows.Forms.TextBox textBoxIPEfolderPath;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.ComboBox comboFirmwareDevice;
        private System.Windows.Forms.ComboBox comboFirmwareBrand;
        private System.Windows.Forms.TextBox textDefaultTXpin;
        private System.Windows.Forms.TextBox textDefaultRXpin;
        private System.Windows.Forms.TextBox textDefaultBaudRate;
        private System.Windows.Forms.TextBox textClockType;
        private System.Windows.Forms.Label label30;
        private System.Windows.Forms.Label label29;
        private System.Windows.Forms.Label label28;
        private System.Windows.Forms.Label label27;
        private System.Windows.Forms.FolderBrowserDialog fb_Firmwares;
        private System.Windows.Forms.OpenFileDialog openIPEcmdFile;
        private System.Windows.Forms.Button b_flashDevice;
        private System.Windows.Forms.Label label35;
        private System.Windows.Forms.TextBox textFreq;
        private System.Windows.Forms.Label label42;
        private System.Windows.Forms.Label label43;
        private System.Windows.Forms.ComboBox comboPicProgrammer;
        private System.Windows.Forms.Label label44;
        private System.Windows.Forms.ComboBox comboFirmwareFlavour;
        private System.Windows.Forms.TextBox textFirmwareFileName;
        private System.Windows.Forms.TextBox tb_Test;
        private System.Windows.Forms.CheckBox checkProgrammerVDD;
    }
}

