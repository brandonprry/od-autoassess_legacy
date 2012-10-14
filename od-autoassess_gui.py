#!/usr/bin/env python

import sys
from PyQt4 import Qt
from PyQt4 import QtGui
from PyQt4 import QtCore

class AutoAssess(QtGui.QWidget):
	def __init__(self, parent=None):
        	QtGui.QWidget.__init__(self, parent)
        	
		self.buildTabs()
		self.setGeometry(0,0,500, 400)
		self.center()
		self.setWindowTitle('OpenDiagnostics AutoAssess Network Script GUI')


	def closeEvent(self, event):
        	reply = QtGui.QMessageBox.question(self, 'Message', "Are you sure to quit?", QtGui.QMessageBox.Yes, QtGui.QMessageBox.No)

		if reply == QtGui.QMessageBox.Yes:
            		event.accept()
        	else:
            		event.ignore()

        def center(self):
	        screen = QtGui.QDesktopWidget().screenGeometry()
        	size = self.geometry()
        	self.move((screen.width()-size.width())/2, (screen.height()-size.height())/2)

	def buildTabs(self):
		tabs = QtGui.QTabWidget()

                general = QtGui.QWidget()
                openvas = QtGui.QWidget()
                metasploit = QtGui.QWidget()
                mbsa = QtGui.QWidget()
		settings = QtGui.QWidget()

                generalLayout = QtGui.QVBoxLayout(general)
                openvasLayout = QtGui.QVBoxLayout(openvas)
                msfLayout = QtGui.QVBoxLayout(metasploit)
                mbsaLayout = QtGui.QVBoxLayout(mbsa)
		settingsLayout = QtGui.QVBoxLayout(settings)

		self.buildGeneralTab(generalLayout)
		self.buildOpenVASTab(openvasLayout)
		self.buildMSFTab(msfLayout)
		self.buildMBSATab(mbsaLayout)
		self.buildSettingsTab(settingsLayout)

                tabs.addTab(general, 'General')
                tabs.addTab(openvas, 'OpenVAS')
                tabs.addTab(metasploit, 'Metasploit')
                tabs.addTab(mbsa, 'MBSA')
		tabs.addTab(settings, 'Local Settings')

                mainLayout = QtGui.QVBoxLayout()
                mainLayout.addWidget(tabs)
		
		run = QtGui.QPushButton('Run Scan', self)
		run.connect(run, QtCore.SIGNAL('clicked()'), self.clicked)
		
		mainLayout.addWidget(run)
		
		self.setLayout(mainLayout)

	def clicked(self):
		isSingleHost = singleHostRadio.toggled()
		isRangedHosts = rangedHostsRadio.toggled()
		singleHost = singleEntry.text()
		rangedHosts = rangedEntry.text()
		clientName = clientName.text()
		companyName = companyNameEntry.text()
		companyLogo = companyLogoEntry.text()
		ovasUser = ovasUserEntry.text()
		ovasPass = ovasPassEntry.text()
		ovasPort = portEntry.text()
		ovasServer = serverEntry.text()
		msfDriver = msfDriverEntry.text()
		msfConn = msfConnEntry.text()
		mbsaUser = userEntry.text()
		mbsaPass = passEntry.text()
		mbsaRemotePath = remotePathEntry.text()
                isProfile = not enableVulnScansCheckBox.checked()
                wantsPrint = printCheckbox.checked()
                enableMbsa = enableMBSACheckBox.checked()
                startOpenvassd = startopenvassdCheckBox.checked()
		
		if clientName == "":
			QtGui.QMessageBox.information(self, "You need a client name", "Please supply a client name for the scan.", QtGui.QMessageBox.Ok )
			return

		command = "od-autoassess --client-name=\"%s\"" % clientName

	def buildGeneralTab(self, tabLayout):
		top = QtGui.QVBoxLayout()		
		middle = QtGui.QVBoxLayout()
		bottom = QtGui.QVBoxLayout()	

		single = QtGui.QHBoxLayout()		
		ranged = QtGui.QHBoxLayout()

		global singleHostRadio
		singleHostRadio = QtGui.QRadioButton('Single-Host', self)
		
		global rangedHostsRadio
		rangedHostsRadio = QtGui.QRadioButton('Range of IP addresses', self)
		
		global singleEntry 
		singleEntry = QtGui.QLineEdit(self)
		singleEntry.setAlignment(QtCore.Qt.AlignRight)
		singleEntry.setMaximumSize(214, 20)
	
		global rangedEntry 
		rangedEntry = QtGui.QLineEdit(self)
		rangedEntry.setAlignment(QtCore.Qt.AlignRight)	
		rangedEntry.setMaximumSize(150, 20)

		single.addWidget(singleHostRadio)
		single.addWidget(singleEntry)

		ranged.addWidget(rangedHostsRadio)
		ranged.addWidget(rangedEntry)

		top.addLayout(ranged)
		top.addLayout(single)

		clientLayout = QtGui.QHBoxLayout()

		clientLabel = QtGui.QLabel('Client Name:', self)

		global clientEntry 
		clientEntry = QtGui.QLineEdit(self)
		clientEntry.setAlignment(QtCore.Qt.AlignRight)
		clientEntry.setMaximumSize(224, 20)

		clientLayout.addWidget(clientLabel)
		clientLayout.addWidget(clientEntry)

		middle.addLayout(clientLayout)

		companyLayout = QtGui.QVBoxLayout()
		companyNameLayout = QtGui.QHBoxLayout()

		companyNameLabel = QtGui.QLabel('Company Name:', self)
		
		global companyNameEntry 
		companyNameEntry = QtGui.QLineEdit(self)
		companyNameEntry.setAlignment(QtCore.Qt.AlignRight)
		companyNameEntry.setMaximumSize(202, 20)

		companyNameLayout.addWidget(companyNameLabel)
		companyNameLayout.addWidget(companyNameEntry)

		bottom.addLayout(companyNameLayout)

		companyLogoLayout = QtGui.QHBoxLayout()
		
		companyLogoLabel = QtGui.QLabel('Company Logo:', self)
		
		global companyLogoEntry 
		companyLogoEntry = QtGui.QLineEdit(self)
		companyLogoEntry.setAlignment(QtCore.Qt.AlignRight)
		companyLogoEntry.setMaximumSize(208, 20)

		companyLogoLayout.addWidget(companyLogoLabel)
		companyLogoLayout.addWidget(companyLogoEntry)

		bottom.addLayout(companyLogoLayout)		

		tabLayout.addLayout(top)
		tabLayout.addLayout(middle)
		tabLayout.addLayout(bottom)
	
	def buildOpenVASTab(self, tabLayout):
		top = QtGui.QVBoxLayout()
		middle = QtGui.QVBoxLayout()
		bottom = QtGui.QVBoxLayout()
		
		userInfoLayout = QtGui.QHBoxLayout()
		passInfoLayout = QtGui.QHBoxLayout()
		
		ovasUserLabel = QtGui.QLabel('OpenVAS User:', self)
		ovasPasswordLabel = QtGui.QLabel('OpenVAS Password:', self)

		global ovasUserEntry 
		ovasUserEntry = QtGui.QLineEdit(self)
		ovasUserEntry.setAlignment(QtCore.Qt.AlignRight)
		ovasUserEntry.setMaximumSize(230, 20)

		global ovasPasswordEntry 
		ovasPasswordEntry = QtGui.QLineEdit(self)
		ovasPasswordEntry.setAlignment(QtCore.Qt.AlignRight)
		ovasPasswordEntry.setMaximumSize(200, 20)

		userInfoLayout.addWidget(ovasUserLabel)
		userInfoLayout.addWidget(ovasUserEntry)

		passInfoLayout.addWidget(ovasPasswordLabel)
		passInfoLayout.addWidget(ovasPasswordEntry)

		middle.addLayout(userInfoLayout)
		middle.addLayout(passInfoLayout)

		portInfoLayout = QtGui.QHBoxLayout()
		serverInfoLayout = QtGui.QHBoxLayout()

		portLabel = QtGui.QLabel('OpenVAS Port:', self)
		
		global portEntry 
		portEntry = QtGui.QLineEdit(self)
		portEntry.setAlignment(QtCore.Qt.AlignRight)
		portEntry.setMaximumSize(230, 20)

		portInfoLayout.addWidget(portLabel)
		portInfoLayout.addWidget(portEntry)		

		serverLabel = QtGui.QLabel('OpenVAS Server IP:', self)
		
		global serverEntry 
		serverEntry = QtGui.QLineEdit(self)
		serverEntry.setAlignment(QtCore.Qt.AlignRight)
		serverEntry.setMaximumSize(200,20)

		serverInfoLayout.addWidget(serverLabel)
		serverInfoLayout.addWidget(serverEntry)

		bottom.addLayout(portInfoLayout)
		bottom.addLayout(serverInfoLayout)

		tabLayout.addLayout(top)
		tabLayout.addLayout(middle)
		tabLayout.addLayout(bottom)

	def buildMSFTab(self, tabLayout):
		top = QtGui.QVBoxLayout()
		middle = QtGui.QVBoxLayout()
		bottom = QtGui.QVBoxLayout()

		msfDriverLayout = QtGui.QHBoxLayout()
		
		msfDriverLabel = QtGui.QLabel('Metasploit SQL Driver:', self)
		
		global msfDriverEntry 
		msfDriverEntry = QtGui.QLineEdit(self)
		msfDriverEntry.setAlignment(QtCore.Qt.AlignRight)
		
		msfDriverLayout.addWidget(msfDriverLabel)
		msfDriverLayout.addWidget(msfDriverEntry)

		top.addLayout(msfDriverLayout)

		msfConnLayout = QtGui.QHBoxLayout()
		
		msfConnLabel = QtGui.QLabel('Connection string for SQL DB:', self)
		
		global msfConnEntry 
		msfConnEntry = QtGui.QLineEdit(self)
		msfConnEntry.setAlignment(QtCore.Qt.AlignRight)
	
		msfConnLayout.addWidget(msfConnLabel)
		msfConnLayout.addWidget(msfConnEntry)

		middle.addLayout(msfConnLayout)

		tabLayout.addLayout(top)
		tabLayout.addLayout(middle)
		tabLayout.addLayout(bottom)


	def buildMBSATab(self, tabLayout):

		top = QtGui.QVBoxLayout()
		middle = QtGui.QVBoxLayout()
		bottom = QtGui.QVBoxLayout()
	
		userLayout = QtGui.QHBoxLayout()
		passLayout = QtGui.QHBoxLayout()

		userLabel = QtGui.QLabel('Remote Username:', self)
		
		global userEntry 
		userEntry = QtGui.QLineEdit(self)
		userEntry.setAlignment(QtCore.Qt.AlignRight)

		userLayout.addWidget(userLabel)
		userLayout.addWidget(userEntry)

		passLabel = QtGui.QLabel('Remote Password:', self)
		
		global passEntry 
		passEntry = QtGui.QLineEdit(self)
		passEntry.setAlignment(QtCore.Qt.AlignRight)

		passLayout.addWidget(passLabel)
		passLayout.addWidget(passEntry)

		middle.addLayout(userLayout)
		middle.addLayout(passLayout)

		remotePathLayout = QtGui.QHBoxLayout()
		
		remotePathLabel = QtGui.QLabel('Remote MBSA path:', self)
		
		global remotePathEntry 
		remotePathEntry = QtGui.QLineEdit(self)
		remotePathEntry.setAlignment(QtCore.Qt.AlignRight)

		remotePathLayout.addWidget(remotePathLabel)
		remotePathLayout.addWidget(remotePathEntry)

		bottom.addLayout(remotePathLayout)
		
		tabLayout.addLayout(top)
		tabLayout.addLayout(middle)
		tabLayout.addLayout(bottom)

	def buildSettingsTab(self, tabLayout):
		global enableVulnScansCheckBox
		global printCheckbox
		global enableMBSACheckBox
		global startopenvassdCheckBox

		enableVulnScansCheckBox = QtGui.QCheckBox('Enable OpenVAS and Metasploit vulnerability assessments', self)
		printCheckbox = QtGui.QCheckBox('Print reports to default printer when done', self)
		enableMBSACheckBox = QtGui.QCheckBox('Enable MBSA Remote Scan', self)
		startopenvassdCheckBox = QtGui.QCheckBox('Start local openvassd instance (127.0.0.1)', self)
		
		tabLayout.addWidget(enableVulnScansCheckBox)
		tabLayout.addWidget(printCheckbox)
		tabLayout.addWidget(enableMBSACheckBox)
		tabLayout.addWidget(startopenvassdCheckBox)
		

app = QtGui.QApplication(sys.argv)
aa = AutoAssess()
aa.show()
sys.exit(app.exec_())
