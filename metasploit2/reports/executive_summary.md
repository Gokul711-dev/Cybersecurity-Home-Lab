# Executive Summary

## Penetration Test: Metasploitable 2

**Test Date:** June 02 2026  
**Tester:** Gokul G  
**Environment:** Isolated VirtualBox Lab  

---

## Overview

A controlled security assessment was conducted against Metasploitable 2 to identify vulnerabilities and demonstrate real-world attack paths. The assessment was performed in a **completely isolated lab environment** for educational purposes.

---

## Key Findings (Critical)

| Finding | Impact | Time to Compromise |
|---------|--------|---------------------|
| vsftpd 2.3.4 Backdoor | Full root access | < 30 seconds |
| Open Root Bindshell (port 1524) | Immediate root | < 5 seconds |
| Samba Usermap Script | Root RCE | < 1 minute |
| UnrealIRCd Backdoor | Root RCE | < 1 minute |
| PostgreSQL Default Creds | Database + root escalation | < 2 minutes |

---

## Risk Assessment
CRITICAL ████████████████████ (10 vulnerabilities rated 9.0+)
HIGH ███ (0)
MEDIUM █ (0)
LOW █ (0)

text

**Overall Risk Rating:** 🔴 **CRITICAL**

---

## Most Concerning Finding

The **open root bindshell on port 1524** requires no authentication, no exploit, no skill. Any user on the same network can become root immediately by running:

```bash
nc 192.168.56.101 1524
whoami   # root
This service must be removed immediately in any real environment.
```
## Business Impact (Simulated)
If this system were production (which it should never be), an attacker would have:

Full control of the server

Access to all data

Ability to pivot to internal networks

Ability to install ransomware or backdoors

Complete compromise of any credentials stored on the system

## Remediation Summary
Action	Effort	Impact
Block port 1524 at firewall	Low	Eliminates 1 critical finding
Change all default passwords	Low	Eliminates 3 findings
Patch vsftpd, Samba, UnrealIRCd	Medium	Eliminates 3 critical CVEs
Disable unused services	Low	Reduces attack surface

## Conclusion
Metasploitable 2 is fundamentally insecure and demonstrates why default configurations and lack of patching lead to complete compromise. This assessment validates that even a novice attacker can gain root access within seconds.

Next Steps for the Tester: Apply these remediation lessons to real-world systems, implement defense-in-depth, and regular vulnerability scanning.

## Report prepared by: Gokul G
## GitHub Portfolio: [https://github.com/Gokul711-dev/Gokul711-dev]