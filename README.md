# Alienware Aurora R12 TuneD Profiles

Custom [tuned](https://tuned-project.org/) profiles for the Alienware Aurora R12, providing fan control via the kernel `platform-profile` sysfs interface alongside system performance tuning.

## Profiles

### `aw-powersave`

Extends the stock `desktop-powersave` tuned profile with the platform profile set to balanced.

- Inherits all default `desktop-powersave` tuning
- Sets platform profile to **balanced** via `/sys/class/platform-profile/platform-profile-0/profile`

### `aw-balanced`

Extends the stock `balanced` tuned profile with the platform profile set to balanced.

- Inherits all default `balanced` tuning (conservative CPU governor, moderate power usage)
- Sets platform profile to **balanced** via `/sys/class/platform-profile/platform-profile-0/profile`

### `aw-performance`

Extends the stock `throughput-performance` profile with gaming-oriented overrides and the platform profile set to performance.

- **CPU latency:** `force_latency=1` keeps the CPU out of deep C-states for consistent frame times
- **Memory:** `transparent_hugepages=madvise`
- **NMI watchdog:** disabled to reduce background CPU overhead
- **Platform profile:** set to **performance** via `/sys/class/platform-profile/platform-profile-0/profile`
- All other tuning inherited from `throughput-performance`

## Fan / Platform Profile Control

Fan and thermal behaviour is controlled by writing to the kernel `platform-profile` sysfs node:

```
/sys/class/platform-profile/platform-profile-0/profile
```

| TuneD Profile | Platform Profile Value |
|---------------|------------------------|
| `aw-powersave`              | `balanced`   |
| `aw-balanced`               | `balanced`   |
| `aw-performance` | `performance`|

This requires no external kernel modules — the `platform-profile` interface is provided by the `alienware-wmi` driver built into the kernel.

## GameMode Integration

[GameMode](https://github.com/FeralInteractive/gamemode) is configured to switch to the `aw-performance` profile while a game is running and return to `aw-balanced` when it exits (`/etc/gamemode.ini`):

```ini
[custom]
start=/usr/bin/tuned-adm profile aw-performance
end=/usr/bin/tuned-adm profile aw-balanced
```

## Installation

### From source (makepkg)

```bash
git clone <repo>
cd alienware-tuned-profiles
makepkg -si
```

This installs the profiles to `/etc/tuned/profiles/` and the gamemode config to `/etc/gamemode.ini`.

### Manual

Copy the profile directories to `/etc/tuned/profiles/`:

```bash
sudo cp -r etc/tuned/profiles/* /etc/tuned/profiles/
```

### Requirements

- `tuned`
- `gamemode`

## Usage

Activate a profile:

```bash
sudo tuned-adm profile aw-performance
sudo tuned-adm profile aw-balanced
sudo tuned-adm profile aw-powersave
```

### KDE Power Management (tuned-ppd)

If using `tuned-ppd` as a `power-profiles-daemon` replacement, copy the provided example config and adjust if needed:

```bash
sudo cp /usr/share/alienware-tuned-profiles/ppd.conf.example /etc/tuned/ppd.conf
```

The example maps PPD presets to these profiles:

```ini
[profiles]
power-saver=aw-powersave
balanced=aw-balanced
performance=aw-performance

[battery]
balanced=balanced-battery
```

The KDE **Performance** preset will then activate the `aw-performance` profile. When on battery, the `aw-balanced` PPD preset maps to a separate `balanced-battery` tuned profile (if defined).
