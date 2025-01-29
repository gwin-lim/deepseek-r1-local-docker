#!/usr/bin/env python3
import sys
import re
from datetime import datetime
import argparse
from collections import defaultdict
import ipaddress

class ColorOutput:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

def is_docker_internal(ip):
    # Common Docker network ranges
    docker_networks = [
        '172.16.0.0/12',    # Default bridge network
        '192.168.0.0/16',   # Custom networks
        '10.0.0.0/8',       # Custom networks
        '127.0.0.0/8'       # Localhost
    ]

    try:
        ip_obj = ipaddress.ip_address(ip)
        return any(ip_obj in ipaddress.ip_network(net) for net in docker_networks)
    except ValueError:
        return False

def parse_iptables_log(line):
    parts = {}
    for part in line.split():
        if '=' in part:
            key, value = part.split('=', 1)
            parts[key] = value
    return parts

def format_connection(parts, external_only=False):
    flags = []
    for flag in ['SYN', 'ACK', 'FIN', 'PSH', 'RST']:
        if flag in parts:
            flags.append(flag)

    if external_only:
        conn_type = 'EXTERNAL'
        color = ColorOutput.RED
    else:
        conn_type = 'UNKNOWN'
        color = ColorOutput.BLUE

        if 'SYN' in flags and 'ACK' not in flags:
            conn_type = 'NEW CONNECTION'
            color = ColorOutput.GREEN
        elif 'FIN' in flags:
            conn_type = 'CONNECTION CLOSE'
            color = ColorOutput.YELLOW
        elif 'PSH' in flags:
            conn_type = 'DATA TRANSFER'
            color = ColorOutput.BLUE

    return (f"{color}[{conn_type}]{ColorOutput.ENDC} "
            f"{parts.get('SRC', '?')}:{parts.get('SPT', '?')} → "
            f"{parts.get('DST', '?')}:{parts.get('DPT', '?')} "
            f"[{' '.join(flags)}] "
            f"Size: {parts.get('LEN', '?')} bytes")

def monitor(external_only=False):
    connections = defaultdict(list)

    for line in sys.stdin:
        if "Model Container:" not in line:
            continue

        parts = parse_iptables_log(line)
        if not parts:
            continue

        if external_only:
            src_ip = parts.get('SRC', '')
            dst_ip = parts.get('DST', '')
            # Only show if either source or destination is external
            if is_docker_internal(src_ip) and is_docker_internal(dst_ip):
                continue

        formatted = format_connection(parts, external_only)
        print(formatted)

def main():
    parser = argparse.ArgumentParser(description='Monitor TCP connections')
    parser.add_argument('--external-only', action='store_true',
                       help='Only show connections involving external IPs')
    args = parser.parse_args()

    try:
        monitor(args.external_only)
    except KeyboardInterrupt:
        sys.exit(0)

if __name__ == "__main__":
    main()