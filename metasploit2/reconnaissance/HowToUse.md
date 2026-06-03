## 📋 How to Use
### Save the file:
```bash
nano auto_scan.sh

# OR
vim auto_scan.sh
```
### Make it executable:
```bash
chmod +x auto_scan.sh
```
### Run it:
```bash
# Basic usage
./auto_scan.sh 192.168.56.101

# With custom output directory
./auto_scan.sh 192.168.56.101 ./my_scan_results
```
## 📁 Output Structure
### The script creates the following files:
```bash
scan_results_20260603_120000/
├── 01_host_discovery.nmap
├── 02_quick_scan.txt
├── 03_full_port_scan.txt
├── 04_service_versions.txt
├── 05_os_detection.txt
├── 06_vuln_scan.txt
├── 07_ftp_enum.txt
├── 07_smb_enum.txt
├── 07_enum4linux.txt
├── 07_nikto_scan.txt
├── 07_gobuster.txt
├── 07_mysql_enum.txt
├── 07_postgres_enum.txt
├── 08_udp_scan.txt
└── 99_scan_summary.txt
```