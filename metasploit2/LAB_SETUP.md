
# 🔧 Home Lab Setup Guide

## Complete step-by-step configuration for isolated penetration testing environment

---

## 📋 Requirements

| Component | Specification |
|-----------|---------------|
| **CPU** | 4+ cores (Intel i5/AMD Ryzen 5 or better) |
| **RAM** | 16GB minimum (8GB for host + 8GB for VMs) |
| **Storage** | 100GB free SSD space recommended |
| **Virtualization** | VT-x/AMD-V enabled in BIOS |
| **Software** | VirtualBox 7.0+ or VMware Workstation Player |

---

## 📥 Downloads

| VM | Download Link | Size |
|----|---------------|------|
| **Kali Linux** | [kali.org/get-kali](https://www.kali.org/get-kali/) | ~4GB |
| **Metasploitable 2** | [SourceForge](https://sourceforge.net/projects/metasploitable/) | ~800MB |
| **VirtualBox** | [virtualbox.org](https://www.virtualbox.org/) | ~100MB |

---

## 🏗️ Step 1: Install VirtualBox

### Windows
```powershell
# Download installer from virtualbox.org
# Run as Administrator
# Follow installation wizard
# Reboot if required
Linux (Ubuntu/Debian)
bash
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack
macOS
bash
brew install --cask virtualbox
```
🌐 Step 2: Configure Host-Only Network
```
Open VirtualBox

File → Host Network Manager

Click Create (if none exists)

Configure as follows:

text
Adapter Tab:
- IPv4 Address: 192.168.56.1
- IPv4 Network Mask: 255.255.255.0

DHCP Server Tab:
- Enable Server: ✅ Checked
- Server Address: 192.168.56.100
- Server Mask: 255.255.255.0
- Lower Address Bound: 192.168.56.101
- Upper Address Bound: 192.168.56.254
```
🐉 Step 3: Deploy Kali Linux VM
```
Create VM
text
Name: Kali Linux 2026.1
Type: Linux
Version: Debian (64-bit)
Memory: 4096 MB (4GB minimum, 8GB recommended)
Hard Disk: 40GB (dynamically allocated)
Configure Network
text
Settings → Network → Adapter 1
Attached to: Host-Only Adapter
Name: VirtualBox Host-Only Ethernet Adapter

Installation

bash
# Boot from ISO
# Select "Graphical Install"
# Follow installation prompts:
- Language: English
- Location: United States
- Keyboard: American English
- Hostname: kali
- Domain name: (leave blank)
- Username: kali
- Password: [Choose strong password]
- Partitioning: Guided - use entire disk
- Software selection: (default - Xfce desktop)
- GRUB: Install to /dev/sda

Post-Installation

bash
# Update system
sudo apt update && sudo apt full-upgrade -y

# Verify IP address
ip a
# Should show 192.168.56.x
🎯 Step 4: Deploy Metasploitable 2 VM
Import VM
bash
# Extract downloaded ZIP file
unzip metasploitable-linux-2.0.0.zip

# In VirtualBox: Machine → New
Name: Metasploitable 2
Type: Linux
Version: Ubuntu (32-bit)
Memory: 512 MB
Hard Disk: Use an existing virtual hard disk file
→ Select the extracted .vmdk file
Configure Network
text
Settings → Network → Adapter 1
Attached to: Host-Only Adapter
Name: VirtualBox Host-Only Ethernet Adapter
(Use same network as Kali)
First Boot
bash
# Login credentials:
Username: msfadmin
Password: msfadmin

# Verify IP
ifconfig
# Should show 192.168.56.x (different from Kali)
✅ Step 5: Verify Connectivity
From Kali Terminal
bash
# Find Metasploitable IP (from its ifconfig output)
# Example: 192.168.56.101

# Ping test
ping 192.168.56.101
# Expected: Replies received

# Quick port scan
nmap -sn 192.168.56.0/24
# Should show both Kali and Metasploitable

# Full port scan
nmap -sV 192.168.56.101
# Should show open ports: 21,22,23,25,80,139,445,3306,5432,5900,6667,8180,1524
```
Common Issues & Solutions
Issue	Solution
No IP address on Metasploitable	sudo dhclient eth0
Cannot ping between VMs	Verify both on same Host-Only network
Metasploitable won't boot	Increase RAM to 1024MB
Network slow	Disable host's WiFi during lab
🔒 Security Best Practices
Never enable NAT/internet on target VMs

Take snapshots BEFORE exploitation

Revert snapshots after each session

Keep host firewall enabled

Disable host WiFi when practicing

Never connect Metasploitable to corporate/production network

📸 Take Baseline Snapshots
Before any exploitation, take snapshots of clean configurations:

bash
# In VirtualBox, for each VM:
Machine → Take Snapshot

Kali: "Clean Installation - Post Update"
Metasploitable: "Fresh Install - All Services Default"
🚀 Ready to Hack!
Your lab is now ready! Start with:

bash
# From Kali VM
cd ~/Desktop
mkdir pentest_lab
cd pentest_lab

# Initial reconnaissance
nmap -sV -p- 192.168.56.101 -oA initial_scan

# Check vsftpd backdoor
nc 192.168.56.101 21
Next: Refer to the project-specific READMEs for exploitation guides.