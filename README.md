# vpn-rebind

> 🧲🔐 Automatically rebind qBittorrent to your VPN interface (utun) on macOS

A small shell script to ensure that **qBittorrent** binds its network interface to an active **VPN (utun)** interface on macOS, protecting your torrents from leaking through non-VPN interfaces.

---

## 🔧 What It Does

- Detects active VPN interface (`utunX`) with a `10.x.x.x` IP  
- Updates your `qBittorrent.ini` to bind to the VPN interface:
  - `Session\\InterfaceName`
  - `Session\\Interface`
- Shows you the changes as a dry-run  
- Prompts for confirmation before:
  - Backing up the current config
  - Applying the new config
  - Restarting qBittorrent

---

## 🚀 Usage

```bash
~/vpn-rebind.sh
```

You'll see something like:

```
🔒 Detected VPN Interface: utun2  
🌐 IP Address: 10.x.x.x

🕵️ Config changes (dry run):
----------------------------
...
----------------------------

Apply these changes? [y/N]:
```

---

## 📦 Installation

1. Save the script as `vpn-rebind.sh`
2. Make it executable:

```bash
chmod +x ~/vpn-rebind.sh
```

3. Run it whenever you reconnect to a VPN or want to ensure safety.

---

## 📝 Notes

- Only works on **macOS** with VPN interfaces using `utun` (e.g., WireGuard, OpenVPN)
- Only supports **qBittorrent** installed via GUI (not headless/server setups)
- Backs up your config before making changes
- You need to **restart qBittorrent** to apply the changes (script does it automatically)

---

## 📂 Location of Config File

```
~/.config/qBittorrent/qBittorrent.ini
```

---

## ✅ Example Output

```
🔒 Detected VPN Interface: utun1  
🌐 IP Address: 10.7.0.2

🕵️ Config changes (dry run):
----------------------------
- Session\InterfaceName=old_value  
+ Session\InterfaceName=utun1
----------------------------

Apply these changes? [y/N]:
```

---

## 🛡️ License

MIT

