# linux-tools

Personal Linux command-line tools for Ubuntu and Debian VPS maintenance.

## Project Summary

`linux-tools` is a small collection of Bash utilities. The current tool is `vpsinfo`, a lightweight status command for quickly checking basic VPS runtime information over SSH.

## Supported Systems

- Ubuntu 20.04, 22.04, 24.04
- Debian-based Linux distributions

## Available Scripts

| Script | Description |
| --- | --- |
| `vpsinfo` | Show hostname, OS version, kernel, uptime, CPU, memory, swap, disk, user, and network information. |

## Install

Install `vpsinfo` to `/usr/local/bin/vpsinfo`:

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/install.sh | sudo bash -s vpsinfo
```

The installer checks the system type, root permission, `curl`, remote script availability, and local command conflicts before installing.

## Usage

```bash
vpsinfo
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/Alice060404/linux-tools/main/uninstall.sh | sudo bash -s vpsinfo
```

This removes:

```text
/usr/local/bin/vpsinfo
```

## Safety Notes

- No background service is installed.
- No cron job or systemd unit is created.
- No SSH, firewall, or kernel parameter configuration is changed.
- No GitHub token, SSH key, private key, or `.env` file should be committed.
- Public IP detection inside `vpsinfo` uses `curl` only when available; missing `curl` does not stop the script.

## Directory Structure

```text
linux-tools/
├── scripts/
│   └── vpsinfo
├── install.sh
├── uninstall.sh
├── README.md
├── LICENSE
└── .gitignore
```

## Development

After editing a script, commit and push the update:

```bash
git add .
git commit -m "Update vpsinfo"
git push
```
