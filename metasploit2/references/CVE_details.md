# CVE Details for Metasploitable 2 Vulnerabilities

| CVE | Service | CVSS | Description | Exploit |
|-----|---------|------|-------------|---------|
| CVE-2011-2523 | vsftpd 2.3.4 | 10.0 | Malicious backdoor in vsftpd source code. Username containing ":)" opens root shell on port 6200. | [Exploit-DB 17491](https://www.exploit-db.com/exploits/17491) |
| CVE-2007-2447 | Samba 3.0.20 | 10.0 | Command injection via username field in usermap script. Allows remote root RCE. | [Exploit-DB 16320](https://www.exploit-db.com/exploits/16320) |
| CVE-2010-2075 | UnrealIRCd 3.2.8.1 | 10.0 | Backdoor in UnrealIRCd allowing remote code execution. | [Exploit-DB 13853](https://www.exploit-db.com/exploits/13853) |
| CVE-2007-3278 | PostgreSQL 8.3 | 9.0 | PostgreSQL allows unauthenticated command execution via user-defined functions. | [Exploit-DB 43905](https://www.exploit-db.com/exploits/43905) |
| CVE-2009-3843 | Tomcat 5.5 | 9.3 | Tomcat manager default credentials allow WAR upload and RCE. | [Exploit-DB 8754](https://www.exploit-db.com/exploits/8754) |
| CVE-2012-2122 | MySQL 5.0.51a | 8.8 | When password hash matches empty hash, authentication bypass. | [Exploit-DB 19092](https://www.exploit-db.com/exploits/19092) |
| CVE-2002-2095 | Distcc 2.x | 9.0 | Distcc daemon allows arbitrary command execution. | [Exploit-DB 991](https://www.exploit-db.com/exploits/991) |

## Full Vulnerability Descriptions

### CVE-2011-2523: vsftpd 2.3.4 Backdoor
- **Affected versions:** vsftpd 2.3.4
- **Attack vector:** FTP (port 21)
- **Impact:** Remote root shell
- **Remediation:** Upgrade to vsftpd 3.0.5+ or disable FTP

### CVE-2007-2447: Samba Usermap Script
- **Affected versions:** Samba 3.0.20-3.0.25rc3
- **Attack vector:** SMB (port 445)
- **Impact:** Remote root command injection
- **Remediation:** Update Samba to 3.0.25+ or apply MS07-029 patch

### CVE-2010-2075: UnrealIRCd Backdoor
- **Affected versions:** UnrealIRCd 3.2.8.1
- **Attack vector:** IRC (port 6667)
- **Impact:** Remote code execution as the user running IRC
- **Remediation:** Upgrade to UnrealIRCd 3.2.8.2+ or disable IRC

## References
- [NVD Database](https://nvd.nist.gov/)
- [Exploit-DB](https://www.exploit-db.com/)
- [CVE Details](https://www.cvedetails.com/)