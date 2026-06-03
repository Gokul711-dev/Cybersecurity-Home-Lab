#!/bin/bash
# ============================================================
# Auto Scan Script - Cybersecurity Home Lab
# Automated reconnaissance and enumeration script
# For educational use in isolated lab environments only
# ============================================================

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           🔍 AUTO SCAN - RECONNAISSANCE TOOL              ║"
echo "║              Cybersecurity Home Lab                       ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if target is provided
if [ -z "$1" ]; then
    echo -e "${RED}[!] Usage: $0 <target_ip> [output_directory]${NC}"
    echo -e "${YELLOW}Example: $0 192.168.56.101${NC}"
    echo -e "${YELLOW}Example: $0 192.168.56.101 ./scan_results${NC}"
    exit 1
fi

TARGET=$1
OUTPUT_DIR="${2:-scan_results_$(date +%Y%m%d_%H%M%S)}"

# Create output directory
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}[+] Output directory: $OUTPUT_DIR${NC}"

# Timestamp
echo -e "${BLUE}[*] Scan started at: $(date)${NC}"
echo ""

# ============================================================
# PHASE 1: Host Discovery
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}📡 PHASE 1: HOST DISCOVERY${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Checking if target is alive...${NC}"
if ping -c 3 "$TARGET" > /dev/null 2>&1; then
    echo -e "${GREEN}[+] Target $TARGET is reachable${NC}"
else
    echo -e "${RED}[!] Target $TARGET is not responding to ping${NC}"
    echo -e "${YELLOW}[*] Continuing with scan anyway...${NC}"
fi
echo ""

# Network discovery on the same subnet
SUBNET=$(echo "$TARGET" | cut -d. -f1-3)
echo -e "${BLUE}[*] Discovering hosts on $SUBNET.0/24...${NC}"
nmap -sn "$SUBNET.0/24" -oN "$OUTPUT_DIR/01_host_discovery.nmap" > /dev/null 2>&1
echo -e "${GREEN}[+] Host discovery saved to: $OUTPUT_DIR/01_host_discovery.nmap${NC}"
echo ""

# ============================================================
# PHASE 2: Quick Port Scan
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}🔌 PHASE 2: QUICK PORT SCAN${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Scanning top 1000 ports...${NC}"
nmap -T4 -F "$TARGET" -oN "$OUTPUT_DIR/02_quick_scan.txt" > /dev/null 2>&1
echo -e "${GREEN}[+] Quick scan saved to: $OUTPUT_DIR/02_quick_scan.txt${NC}"

# Extract open ports for detailed scan
OPEN_PORTS=$(grep -E "^[0-9]+/tcp" "$OUTPUT_DIR/02_quick_scan.txt" | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
if [ -n "$OPEN_PORTS" ]; then
    echo -e "${GREEN}[+] Open ports detected: $OPEN_PORTS${NC}"
else
    echo -e "${YELLOW}[!] No open ports found in quick scan. Running full scan...${NC}"
fi
echo ""

# ============================================================
# PHASE 3: Full Port Scan
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}🌐 PHASE 3: FULL PORT SCAN${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Scanning all 65535 ports (this may take several minutes)...${NC}"
nmap -p- --min-rate 1000 "$TARGET" -oN "$OUTPUT_DIR/03_full_port_scan.txt" > /dev/null 2>&1
echo -e "${GREEN}[+] Full port scan saved to: $OUTPUT_DIR/03_full_port_scan.txt${NC}"

# Extract all open ports
ALL_OPEN_PORTS=$(grep -E "^[0-9]+/tcp" "$OUTPUT_DIR/03_full_port_scan.txt" | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
echo -e "${GREEN}[+] All open ports: $ALL_OPEN_PORTS${NC}"
echo ""

# ============================================================
# PHASE 4: Service Version Detection
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}🔧 PHASE 4: SERVICE VERSION DETECTION${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Detecting service versions...${NC}"
nmap -sV -sC -p "$ALL_OPEN_PORTS" "$TARGET" -oN "$OUTPUT_DIR/04_service_versions.txt" > /dev/null 2>&1
echo -e "${GREEN}[+] Service version scan saved to: $OUTPUT_DIR/04_service_versions.txt${NC}"
echo ""

# ============================================================
# PHASE 5: OS Detection
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}💻 PHASE 5: OS DETECTION${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Attempting OS fingerprinting...${NC}"
nmap -O --osscan-guess "$TARGET" -oN "$OUTPUT_DIR/05_os_detection.txt" > /dev/null 2>&1
echo -e "${GREEN}[+] OS detection saved to: $OUTPUT_DIR/05_os_detection.txt${NC}"
echo ""

# ============================================================
# PHASE 6: Vulnerability Scanning
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}⚠️  PHASE 6: VULNERABILITY SCANNING${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Running Nmap vulnerability scripts...${NC}"
nmap --script vuln -p "$ALL_OPEN_PORTS" "$TARGET" -oN "$OUTPUT_DIR/06_vuln_scan.txt" > /dev/null 2>&1
echo -e "${GREEN}[+] Vulnerability scan saved to: $OUTPUT_DIR/06_vuln_scan.txt${NC}"
echo ""

# ============================================================
# PHASE 7: Service-Specific Enumeration
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}📂 PHASE 7: SERVICE-SPECIFIC ENUMERATION${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

# FTP enumeration
if echo "$ALL_OPEN_PORTS" | grep -q "21"; then
    echo -e "${BLUE}[*] Enumerating FTP (port 21)...${NC}"
    nmap -p 21 --script ftp-anon,ftp-vuln* "$TARGET" -oN "$OUTPUT_DIR/07_ftp_enum.txt" > /dev/null 2>&1
    echo -e "${GREEN}[+] FTP enumeration saved to: $OUTPUT_DIR/07_ftp_enum.txt${NC}"
fi

# SMB enumeration
if echo "$ALL_OPEN_PORTS" | grep -q "445"; then
    echo -e "${BLUE}[*] Enumerating SMB (port 445)...${NC}"
    nmap -p 445 --script smb-vuln*,smb-os-discovery "$TARGET" -oN "$OUTPUT_DIR/07_smb_enum.txt" > /dev/null 2>&1
    echo -e "${GREEN}[+] SMB enumeration saved to: $OUTPUT_DIR/07_smb_enum.txt${NC}"
    
    # enum4linux if available
    if command -v enum4linux &> /dev/null; then
        echo -e "${BLUE}[*] Running enum4linux...${NC}"
        enum4linux "$TARGET" > "$OUTPUT_DIR/07_enum4linux.txt" 2>/dev/null
        echo -e "${GREEN}[+] enum4linux output saved to: $OUTPUT_DIR/07_enum4linux.txt${NC}"
    fi
fi

# HTTP enumeration
if echo "$ALL_OPEN_PORTS" | grep -qE "80|8080|8180"; then
    echo -e "${BLUE}[*] Enumerating HTTP services...${NC}"
    
    # Nikto if available
    if command -v nikto &> /dev/null; then
        echo -e "${BLUE}[*] Running Nikto...${NC}"
        nikto -h "http://$TARGET" -o "$OUTPUT_DIR/07_nikto_scan.txt" > /dev/null 2>&1
        echo -e "${GREEN}[+] Nikto scan saved to: $OUTPUT_DIR/07_nikto_scan.txt${NC}"
    fi
    
    # Gobuster if available
    if command -v gobuster &> /dev/null; then
        echo -e "${BLUE}[*] Running Gobuster directory brute force...${NC}"
        gobuster dir -u "http://$TARGET" -w /usr/share/wordlists/dirb/common.txt -o "$OUTPUT_DIR/07_gobuster.txt" > /dev/null 2>&1
        echo -e "${GREEN}[+] Gobuster results saved to: $OUTPUT_DIR/07_gobuster.txt${NC}"
    fi
fi

# MySQL enumeration
if echo "$ALL_OPEN_PORTS" | grep -q "3306"; then
    echo -e "${BLUE}[*] Enumerating MySQL (port 3306)...${NC}"
    nmap -p 3306 --script mysql-enum,mysql-info "$TARGET" -oN "$OUTPUT_DIR/07_mysql_enum.txt" > /dev/null 2>&1
    echo -e "${GREEN}[+] MySQL enumeration saved to: $OUTPUT_DIR/07_mysql_enum.txt${NC}"
fi

# PostgreSQL enumeration
if echo "$ALL_OPEN_PORTS" | grep -q "5432"; then
    echo -e "${BLUE}[*] Enumerating PostgreSQL (port 5432)...${NC}"
    nmap -p 5432 --script pgsql-brute "$TARGET" -oN "$OUTPUT_DIR/07_postgres_enum.txt" > /dev/null 2>&1
    echo -e "${GREEN}[+] PostgreSQL enumeration saved to: $OUTPUT_DIR/07_postgres_enum.txt${NC}"
fi

echo ""

# ============================================================
# PHASE 8: UDP Scan
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}📡 PHASE 8: UDP SCAN${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

echo -e "${BLUE}[*] Scanning common UDP ports...${NC}"
nmap -sU --top-ports 20 "$TARGET" -oN "$OUTPUT_DIR/08_udp_scan.txt" > /dev/null 2>&1
echo -e "${GREEN}[+] UDP scan saved to: $OUTPUT_DIR/08_udp_scan.txt${NC}"
echo ""

# ============================================================
# PHASE 9: Summary Report
# ============================================================
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}📊 PHASE 9: SCAN SUMMARY${NC}"
echo -e "${PURPLE}════════════════════════════════════════════════════════════${NC}"

# Generate summary file
SUMMARY_FILE="$OUTPUT_DIR/99_scan_summary.txt"
{
    echo "========================================="
    echo "SCAN SUMMARY - $(date)"
    echo "========================================="
    echo ""
    echo "Target IP: $TARGET"
    echo "Output Directory: $OUTPUT_DIR"
    echo ""
    echo "Open Ports Found:"
    echo "$ALL_OPEN_PORTS" | tr ',' '\n' | while read port; do
        if [ -n "$port" ]; then
            SERVICE=$(grep -E "^$port/tcp" "$OUTPUT_DIR/04_service_versions.txt" | head -1 | awk '{print $3, $4, $5}')
            echo "  - $port/tcp : $SERVICE"
        fi
    done
    echo ""
    echo "Files Generated:"
    ls -la "$OUTPUT_DIR" | awk '{print "  - " $9}' | grep -v "^$"
    echo ""
    echo "========================================="
    echo "Next Steps:"
    echo "1. Review service versions for known vulnerabilities"
    echo "2. Check exploit-db.com for matching exploits"
    echo "3. Start Metasploit: msfconsole"
    echo "4. Search for exploits: search <service> <version>"
    echo "========================================="
} > "$SUMMARY_FILE"

echo -e "${GREEN}[+] Summary report saved to: $SUMMARY_FILE${NC}"
echo ""

# Display summary
cat "$SUMMARY_FILE"
echo ""

# ============================================================
# Completion
# ============================================================
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ SCAN COMPLETED SUCCESSFULLY${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}[*] Total scan time: $(date)${NC}"
echo -e "${CYAN}[*] Results saved in: $OUTPUT_DIR${NC}"
echo -e "${YELLOW}[*] Next: Review $OUTPUT_DIR/99_scan_summary.txt${NC}"
echo ""

# Option to compress results
read -p "Do you want to compress the results? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    tar -czf "$OUTPUT_DIR.tar.gz" "$OUTPUT_DIR"
    echo -e "${GREEN}[+] Results compressed to: $OUTPUT_DIR.tar.gz${NC}"
fi

echo -e "${GREEN}[+] Happy hacking! Stay legal and ethical.${NC}"