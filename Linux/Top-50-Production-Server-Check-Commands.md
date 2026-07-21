# Top 50 Linux Commands to Check a Production Server

A quick-reference cheat sheet for health-checking a production Linux server —
system info, CPU/memory, disk, processes, network, logs, and services.

## 1. System & Uptime

1. `uptime` — how long the system has been running + load averages
2. `hostnamectl` — hostname, OS, kernel, architecture
3. `uname -a` — kernel name/version/architecture
4. `cat /etc/os-release` — OS distro and version
5. `date` — current system date/time (check for clock drift)
6. `who` / `w` — logged-in users and what they're doing
7. `last -a | head` — recent login history

## 2. CPU & Memory

8. `top` — real-time process, CPU, and memory view
9. `htop` — enhanced interactive version of `top` (if installed)
10. `vmstat 1 5` — CPU, memory, I/O, and process stats over time
11. `mpstat -P ALL 1` — per-core CPU utilization (`sysstat` package)
12. `free -h` — memory and swap usage in human-readable form
13. `nproc` — number of available CPU cores
14. `sar -u 1 5` — historical/real-time CPU usage (`sysstat`)

## 3. Disk & Storage

15. `df -h` — filesystem disk space usage
16. `du -sh /path/*` — directory sizes, sorted to find big consumers
17. `lsblk` — block devices and partitions
18. `mount | column -t` — currently mounted filesystems
19. `iostat -xz 1 5` — disk I/O statistics (`sysstat`)
20. `findmnt` — mounted filesystem tree view
21. `fdisk -l` — partition table details (requires sudo)
22. `smartctl -a /dev/sda` — disk health/SMART status (`smartmontools`)

## 4. Processes

23. `ps aux --sort=-%cpu | head` — top CPU-consuming processes
24. `ps aux --sort=-%mem | head` — top memory-consuming processes
25. `pstree -p` — process tree with PIDs
26. `pgrep -fl <name>` — find PID(s) by process name
27. `kill -0 <pid>` — check if a process is still alive (no signal sent)
28. `nice`/`renice` — check/adjust process priority
29. `lsof -p <pid>` — files/sockets opened by a process
30. `strace -p <pid>` — trace syscalls of a running process (debugging)

## 5. Network

31. `ip a` — network interfaces and IP addresses
32. `ip r` — routing table
33. `ss -tulnp` — listening TCP/UDP ports and owning processes
34. `netstat -tulnp` — legacy alternative to `ss`
35. `ping -c 4 <host>` — basic reachability check
36. `traceroute <host>` / `mtr <host>` — path and latency to a host
37. `curl -I <url>` — quick HTTP header/status check
38. `dig <domain>` / `nslookup <domain>` — DNS resolution check
39. `nc -zv <host> <port>` — test if a port is open
40. `iftop` / `nload` — real-time bandwidth usage per connection/interface
41. `cat /etc/resolv.conf` — DNS servers in use

## 6. Logs & Auditing

42. `journalctl -xe` — recent systemd logs with context (errors)
43. `journalctl -u <service> --since "1 hour ago"` — logs for a specific service
44. `tail -f /var/log/syslog` (or `/var/log/messages`) — live system log stream
45. `dmesg -T | tail -50` — recent kernel messages (hardware/driver issues)
46. `grep -i error /var/log/*.log` — quick scan for errors across logs

## 7. Services & System State

47. `systemctl status <service>` — status of a specific service
48. `systemctl list-units --type=service --state=failed` — all failed services
49. `crontab -l` (and `sudo crontab -l -u <user>`) — scheduled jobs
50. `history | tail -50` — recent shell command history for the session

---

### Suggested quick health-check routine

```bash
uptime; free -h; df -h; ss -tulnp; systemctl list-units --state=failed; journalctl -p err -b
```

This one-liner gives you load, memory, disk, open ports, failed services, and
boot-time errors in a single pass — a good first move when investigating an
incident on a production box.
