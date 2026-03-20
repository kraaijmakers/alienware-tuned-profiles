# Alienware Aurora R12 TuneD Profiles

Custom [tuned](https://tuned-project.org/) profiles for the Alienware Aurora R12, providing fan control via ACPI alongside system performance tuning.

## Profiles

### `powersave`

Extends the stock `desktop-powersave` tuned profile with the Alienware fan set to balanced mode.

- Inherits all default `desktop-powersave` tuning
- Sets fan to **balanced mode** via ACPI

### `balanced`

Extends the stock `balanced` tuned profile with the Alienware fan set to balanced mode.

- Inherits all default `balanced` tuning (conservative CPU governor, moderate power usage)
- Sets fan to **balanced mode** via ACPI

### `performance`

Extends the stock `throughput-performance` profile with gaming-oriented overrides and the Alienware fan at full speed.

- **CPU latency:** `force_latency=1` keeps the CPU out of deep C-states for consistent frame times
- **Memory:** `transparent_hugepages=madvise`
- **NMI watchdog:** disabled to reduce background CPU overhead
- **Fan:** set to **performance mode** via ACPI
- All other tuning inherited from `throughput-performance`

## Fan Control

Fan mode is set by writing to `/proc/acpi/call` (requires `acpi_call` or `acpi_call-dkms`):

| Mode        | ACPI Value |
|-------------|------------|
| Balanced    | `0xa0`     |
| Performance | `0xa1`     |

The fan script (`fan-profile.sh`) issues the ACPI call on profile activation:

```bash
echo "\_SB.AMW1.WMAX 0 0x15 {0x1,<value>,0x0,0x00}" > /proc/acpi/call
```

## GameMode Integration

[GameMode](https://github.com/FeralInteractive/gamemode) is configured to switch to the `performance` profile while a game is running and return to `balanced` when it exits (`/etc/gamemode.ini`):

```ini
[custom]
start=/usr/bin/tuned-adm profile performance
end=/usr/bin/tuned-adm profile balanced
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
- `acpi_call` or `acpi_call-dkms`
- `gamemode`

## Usage

Activate a profile:

```bash
sudo tuned-adm profile performance
sudo tuned-adm profile balanced
sudo tuned-adm profile powersave
```

### KDE Power Management (tuned-ppd)

If using `tuned-ppd` as a `power-profiles-daemon` replacement, copy the provided example config and adjust if needed:

```bash
sudo cp /usr/share/alienware-tuned-profiles/ppd.conf.example /etc/tuned/ppd.conf
```

The example maps PPD presets to these profiles:

```ini
[profiles]
power-saver=powersave
balanced=balanced
performance=performance
```

The KDE **Performance** preset will then activate the `performance` profile.
