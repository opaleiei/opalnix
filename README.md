# ❄️ OpalNix

A modern, declarative NixOS configuration flake crafted with modularity, aesthetic cohesion, and hardware-tailored performance.

---

## 🖥️ System Architecture & Specs

| Component | Specification |
| :--- | :--- |
| **CPU** | Intel Core i5-4590 (Haswell Quad-Core) |
| **Motherboard** | MSI H97 Gaming 3 (Qualcomm Atheros Killer E2205 / `alx` NIC) |
| **GPU** | NVIDIA GeForce GTX 960 (Maxwell GM206 - Proprietary Production Driver) |
| **Bootloader** | [Limine](https://limine-bootloader.org/) (Modern multiprotocol bootloader) |
| **Compositor** | [Umbriel](https://github.com/noctalia-dev/umbriel) (Scrolling & Tiling Wayland Compositor) |
| **Desktop Shell** | [Noctalia v5](https://github.com/noctalia-dev/noctalia) (Unified Bar, Launcher, Notifications, Control Center) |
| **Greeter** | `greetd` + [Noctalia Greeter](https://github.com/noctalia-dev/noctalia-greeter) |
| **Theming** | [Stylix](https://github.com/nix-community/stylix) with **Kanagawa** base16 palette |
| **Font** | Maple Mono NF (`maple-mono.NF-unhinted`) |
| **Terminal** | [Ghostty](https://ghostty.org) |
| **Shell & Prompt** | Zsh + [Starship](https://starship.rs) (autosuggestions, syntax highlighting, fzf, zoxide) |
| **GUI Editor** | [Zed](https://zed.dev) (the default handler for text/source files) |
| **Terminal Editor**| Neovim ($EDITOR preconfigured with LSP, Treesitter, Telescope, and Kanagawa) |
| **Browser** | [Zen Browser](https://zen-browser.app) (via community flake) |
| **File Manager** | Nautilus (GNOME Files) |
| **Containers** | Docker Engine & Docker Compose (Homelab stack auto-managed) |
| **Wake-on-LAN** | Configured for Atheros Killer E2200 via kernel module options + ethtool service |

---

## 🗂️ Repository Structure

```
opalnix/
├── flake.nix                       # Flake entry point (inputs, outputs & system setup)
├── compose.yaml                    # Your homelab container stack
├── README.md                       # Complete deployment & usage manual
│
├── hosts/
│   └── opalnix/
│       ├── default.nix             # Host-specific settings (user, locale, nix settings)
│       └── hardware-configuration.nix # Hardware mounts & kernel modules
│
├── modules/
│   ├── nixos/                      # System-level modules
│   │   ├── bootloader.nix          # Limine bootloader configuration
│   │   ├── hardware.nix            # Intel Haswell + NVIDIA GTX 960 (open=false, modesetting)
│   │   ├── networking.nix          # Atheros alx Killer E2200 Wake-on-LAN + Firewall
│   │   ├── desktop.nix             # greetd, noctalia-greeter, pipewire, xdg-desktop-portal
│   │   ├── docker.nix              # Docker daemon & systemd homelab-compose service
│   │   └── default.nix             # System module aggregator
│   │
│   └── home/                       # Home Manager user modules (user: op)
│       ├── shell.nix               # Zsh, Starship, modern CLI utilities & aliases
│       ├── terminal.nix            # Ghostty config
│       ├── editors.nix             # Neovim (LSP/Telescope/Kanagawa) + Zed
│       ├── browser.nix             # Zen Browser & mime associations
│       ├── noctalia.nix            # Noctalia shell & Umbriel compositor configuration
│       ├── desktop.nix             # Nautilus, xdg user dirs, GTK dark theme
│       └── default.nix             # Home Manager aggregator
│
└── themes/
    └── stylix.nix                  # Stylix unified theming (Kanagawa + Maple Mono NF)
```

---

## 🚀 Step-by-Step Installation Guide (From Fresh Minimal NixOS ISO)

Follow this guide on your physical machine (i5-4590 + GTX 960 + MSI H97 Gaming 3).

### Step 1: Boot Minimal NixOS ISO & Connect Network
1. Download the [NixOS Minimal ISO (x86_64)](https://nixos.org/download.html) and flash it onto a USB drive (e.g. using Ventoy, Rufus, or `dd`).
2. Boot into the live environment.
3. Verify internet connectivity:
   ```bash
   ping -c 3 1.1.1.1
   ```

---

### Step 2: Disk Partitioning (UEFI + GPT)
Assuming your target SSD is `/dev/sda` (adjust if nvme0n1 or similar):

```bash
# Create GPT partition table
parted /dev/sda -- mklabel gpt

# Partition 1: EFI System Partition (1GB recommended for Limine & kernels)
parted /dev/sda -- mkpart ESP fat32 1MiB 1024MiB
parted /dev/sda -- set 1 esp on

# Partition 2: Root Filesystem (Remaining space)
parted /dev/sda -- mkpart primary ext4 1024MiB 100%

# Format partitions
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

# Mount partitions
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

---

### Step 3: Clone this Configuration Flake
Install `git` in the live session and clone your repo directly to `/mnt/etc/nixos`:

```bash
# Enable flakes & nix-command temporarily
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Clone repository into /mnt/etc/nixos
nix-shell -p git
git clone https://github.com/<your-username>/opalnix.git /mnt/etc/nixos
cd /mnt/etc/nixos
```

*(If you don't have internet git push set up yet, you can copy the files via USB drive or SSH to `/mnt/etc/nixos`)*.

---

### Step 4: Generate Your Specific Hardware Configuration
NixOS provides a tool that inspects your motherboard's exact disk UUIDs and kernel modules:

```bash
# Generate hardware configuration and place into hosts/opalnix
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hosts/opalnix/hardware-configuration.nix
```

---

### Step 5: Install NixOS
Run the installation command using the flake configuration:

```bash
nixos-install --flake .#opalnix
```

During the install, it will prompt you to enter the **root password**.

After completion, set the password for your primary user `op`:
```bash
nixos-enter --root /mnt -c 'passwd op'
```

Now unmount and reboot:
```bash
reboot
```

---

## ⚡ Post-Installation & Daily Usage

### 1. Daily Rebuilding
Once booted into your new system, you have access to `nh` (Nix Helper) and handy aliases:
```bash
# Switch to new configuration
rebuild
# Or manually:
nh os switch /etc/nixos

# Test without adding to bootloader generations
testbuild

# Clean old generations & garbage collection
cleanbuild
```

### 2. Modern CLI Tools & Replacements
All classic Unix tools are aliased to high-performance modern alternatives:
- `ls` / `ll` / `la` → **`lsd`** (with icons and colors)
- `cat` → **`bat`** (syntax highlighting with Kanagawa theme)
- `top` / `htop` → **`btop`** (rich interactive monitor)
- `cd <dir>` → **`z <dir>`** (`zoxide` directory jumping)
- `grep` → **`ripgrep`** (`rg`)
- `find` → **`fd`**
- `df` → **`duf`**
- `du` → **`dust`**
- `ps` → **`procs`**
- `ping` → **`gping`** (graphical terminal ping)
- `lg` → **`lazygit`**
- File management in terminal: **`yazi`**
- Multiplexer: **`zellij`**

### 3. Docker Compose Stack
Your homelab `compose.yaml` is natively integrated:
- The systemd unit `homelab-compose.service` is defined in `modules/nixos/docker.nix` to automatically manage your stack if located in `/etc/nixos/compose.yaml`.
- You can manually run and inspect services anytime:
  ```bash
  cd /etc/nixos
  docker compose ps
  docker compose logs -f caddy
  ```

---

## 🔌 MSI H97 Gaming 3 Wake-On-LAN (WOL) Setup

The MSI H97 Gaming 3 uses the Qualcomm Atheros Killer E2205 NIC governed by the Linux `alx` driver. In Arch Linux, this required `alx-wol-dkms` because upstream kernels disabled WOL by default.

In **OpalNix**, this is natively solved without DKMS:
1. `boot.extraModprobeConfig = "options alx enable_wol=1";` enables WOL support in the kernel module.
2. The custom systemd unit `enable-wol.service` runs `ethtool -s <interface> wol g` on all ethernet interfaces at boot.
3. UDP Ports 7 and 9 are opened in the firewall.

### ⚠️ Required BIOS / UEFI Settings (MSI Click BIOS 4):
1. Press `DEL` during boot to enter MSI BIOS.
2. Go to **Settings** → **Advanced** → **Wake Up Event Setup**:
   - **Resume By PCI-E Device**: Set to **[Enabled]** *(Crucial for the onboard Killer E2200 NIC)*
   - **Resume By PCI Device**: Set to **[Enabled]**
3. Go to **Settings** → **Advanced** → **Power Management Setup**:
   - **EuP 2013**: Set to **[Disabled]** *(If enabled, this cuts power to the NIC during S5 shutdown!)*
4. Save and reboot (`F10`).

### Verifying WOL on NixOS:
Run in your terminal:
```bash
ethtool eth0 | grep Wake-on
```
*(Replace `eth0` with your interface name from `ip link`).*
You should see:
```text
Supports Wake-on: pumbg
Wake-on: g
```
Now you can send magic packets from your phone or router to the PC's MAC address to wake it up!

