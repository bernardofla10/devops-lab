#!/usr/bin/env bash

set -euo pipefail

echo "System Resource Check"
echo "====================="
echo ""

echo "Date:"
date
echo ""

echo "Current user:"
whoami
echo ""

echo "Hostname:"
hostname
echo ""

echo "Uptime:"
uptime
echo ""

echo "Memory usage:"
free -h
echo ""

echo "Disk usage:"
df -h
echo ""

echo "Repository size:"
du -sh ~/devops-lab 2>/dev/null || echo "Repository not found at ~/devops-lab"
echo ""

echo "Top processes by memory:"
ps aux --sort=-%mem | head -n 6
echo ""

echo "Top processes by CPU:"
ps aux --sort=-%cpu | head -n 6
echo ""

echo "Resource check finished."
