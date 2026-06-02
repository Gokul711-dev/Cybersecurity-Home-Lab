# 🎯 Metasploitable 2 Penetration Testing Lab

## 📌 Overview
This repository documents a complete penetration testing engagement against **Metasploitable 2**, an intentionally vulnerable Linux VM, conducted in an isolated VirtualBox lab environment.

**Attacker:** Kali Linux  
**Target:** Metasploitable 2  
**Date:** May 2026  
**Environment:** Isolated Host-Only Network

## ⚠️ Disclaimer
> This project was conducted in a **controlled, isolated lab environment** for **educational purposes only**. All activities were performed legally on systems I own. Do not use these techniques against systems without explicit permission.

## 🎯 Key Findings

| Vulnerability | CVE | CVSS | Impact |
|---------------|-----|------|---------|
| vsftpd 2.3.4 Backdoor | CVE-2011-2523 | 10.0 | Root RCE |
| Samba usermap_script | CVE-2007-2447 | 10.0 | Root RCE |
| UnrealIRCd Backdoor | CVE-2010-2075 | 10.0 | Root RCE |
| Open Root Bindshell | N/A | 10.0 | Direct Root Access |
| PostgreSQL Default Creds | CVE-2007-3278 | 9.0 | RCE + Priv Esc |
| VNC Default Password | N/A | 9.8 | Root GUI Access |
| Tomcat Default Creds | CVE-2009-3843 | 9.3 | RCE as tomcat55 |
| MySQL Default Creds | CVE-2012-2122 | 8.8 | Database Access |

**Result:** Full root compromise achieved via multiple independent attack paths.

## 🛠️ Tools Used
- Nmap / Zenmap
- Metasploit Framework
- Netcat
- enum4linux
- Nikto
- Gobuster
- John the Ripper
- Wireshark

## 📊 Attack Methodology (PTES Standard)

1. **Reconnaissance** - Network scanning, service discovery
2. **Enumeration** - Service fingerprinting, vulnerability research
3. **Exploitation** - Gaining initial access via 8 different vectors
4. **Post-Exploitation** - Privilege escalation, data extraction, persistence
5. **Reporting** - Documentation with CVE references and remediation

## 📸 Evidence Gallery
[Link to screenshots folder]

## 📄 Reports
- [Full Penetration Test Report](reports/penetration_test_report.md)
- [Executive Summary](reports/executive_summary.md)

## 🔗 MITRE ATT&CK Tactics Demonstrated
- TA0001 - Initial Access
- TA0003 - Persistence
- TA0004 - Privilege Escalation
- TA0006 - Credential Access
- TA0007 - Discovery
- TA0010 - Exfiltration

## 🛡️ Remediation Recommendations
1. Upgrade vsftpd to 3.0.5+
2. Remove UnrealIRCd and vsftpd backdoors
3. Close port 1524 immediately
4. Change all default credentials
5. Implement firewall rules
6. Patch Samba to latest version
7. Disable unused services (telnet, VNC if not needed)

## 📚 Lessons Learned
- Default credentials remain a critical security gap
- Backdoored software presents supply chain risks
- Network segmentation prevents lateral movement
- Regular patching would eliminate 100% of exploited vulnerabilities

## 🚀 Quick Start (Run This Lab Yourself)
```bash
# Clone this repo
git clone https://github.com/YOURUSERNAME/metasploitable2-pentest-lab.git

# Review the disclaimer
cat DISCLAIMER.md

# Check lab setup instructions
cat LAB_SETUP.md

# Run the reconnaissance script
./reconnaissance/auto_scan.sh <target_ip>
