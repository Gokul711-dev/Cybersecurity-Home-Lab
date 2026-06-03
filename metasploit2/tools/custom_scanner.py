#!/usr/bin/env python3
"""
Custom Network Scanner for Cybersecurity Home Lab
Performs TCP connect scanning, service detection, and OS fingerprinting.
For educational use in isolated lab environments only.
"""

import socket
import sys
import threading
from datetime import datetime

# Color codes for terminal output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

# Common ports to scan
COMMON_PORTS = {
    21: 'FTP', 22: 'SSH', 23: 'Telnet', 25: 'SMTP', 80: 'HTTP',
    139: 'NetBIOS', 445: 'SMB', 3306: 'MySQL', 5432: 'PostgreSQL',
    5900: 'VNC', 6667: 'IRC', 8080: 'HTTP-Alt', 1524: 'Bindshell'
}

def scan_port(target, port, timeout=1):
    """Attempt to connect to a single port."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((target, port))
        sock.close()
        if result == 0:
            service = COMMON_PORTS.get(port, 'Unknown')
            print(f"{GREEN}[+] Port {port} open - {service}{RESET}")
            return port
    except Exception:
        pass
    return None

def scan_ports(target, ports, threads=50):
    """Scan multiple ports using threading."""
    open_ports = []
    print(f"{BLUE}[*] Scanning {target}...{RESET}")
    
    def worker(port):
        if scan_port(target, port):
            open_ports.append(port)
    
    thread_list = []
    for port in ports:
        t = threading.Thread(target=worker, args=(port,))
        thread_list.append(t)
        t.start()
        # Limit concurrent threads
        if len(thread_list) >= threads:
            for t in thread_list:
                t.join()
            thread_list = []
    
    for t in thread_list:
        t.join()
    
    return open_ports

def banner_grab(target, port, timeout=3):
    """Grab service banner if possible."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        sock.connect((target, port))
        sock.send(b"HEAD / HTTP/1.0\r\n\r\n")
        banner = sock.recv(1024).decode().strip()
        sock.close()
        return banner[:100]  # Truncate long banners
    except:
        return None

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <target_ip> [-p <ports>]")
        print("Example: python3 custom_scanner.py 192.168.56.101")
        print("         python3 custom_scanner.py 192.168.56.101 -p 21,22,80,445")
        sys.exit(1)
    
    target = sys.argv[1]
    
    # Parse ports
    if "-p" in sys.argv:
        port_index = sys.argv.index("-p") + 1
        if port_index < len(sys.argv):
            ports = [int(p.strip()) for p in sys.argv[port_index].split(',')]
        else:
            ports = list(COMMON_PORTS.keys())
    else:
        ports = list(COMMON_PORTS.keys())
    
    start_time = datetime.now()
    open_ports = scan_ports(target, ports)
    end_time = datetime.now()
    
    print(f"\n{BLUE}[*] Scan completed in {end_time - start_time}{RESET}")
    print(f"{YELLOW}[*] Open ports: {sorted(open_ports)}{RESET}")
    
    # Optional banner grabbing
    if open_ports and input("\nPerform banner grab? (y/n): ").lower() == 'y':
        for port in open_ports[:5]:  # Limit to first 5
            banner = banner_grab(target, port)
            if banner:
                print(f"{BLUE}[*] Port {port} banner: {banner[:80]}{RESET}")

if __name__ == "__main__":
    main()