| Homebrew                | Nix (imperative)          | Home Manager (declarative)                      |
| ----------------------- | ------------------------- | ----------------------------------------------- |
| brew install <pkg>      | nix-env -iA nixpkgs.<pkg> | Add to home.packages + home-manager switch      |
| brew uninstall <pkg>    | nix-env -e <pkg>          | Remove from home.packages + home-manager switch |
| brew list / brew leaves | nix-env -q                | Check home.nix                                  |
| brew search <pkg>       | nix-env -qaP <pkg>        | Search at search.nixos.org                      |
| brew upgrade            | nix-env -u                | home-manager switch after channel update        |

## Update nix

```bash
$ sudo nix-channel --update
$ home-manager switch

or

$ sudo nix-channel --update && home-manager switch
```

---

## NixOS-WSL (Flake-based)

### Initial Setup

1. Copy the WSL directory contents to `/etc/nixos/` on your WSL machine:
   ```bash
   # On WSL machine
   sudo cp -r ~/home-config/WSL/* /etc/nixos/
   ```

2. Generate the lock file and rebuild:
   ```bash
   cd /etc/nixos
   sudo nixos-rebuild switch --flake .#nixos
   ```

### Update System

```bash
# Update flake inputs (nixpkgs, home-manager, nixos-wsl)
cd /etc/nixos
sudo nix flake update

# Rebuild with updated inputs
sudo nixos-rebuild switch --flake .#nixos

# Or combined
sudo nix flake update && sudo nixos-rebuild switch --flake .#nixos
```

### Test Before Switching

```bash
# Build without switching (verify it compiles)
sudo nixos-rebuild build --flake .#nixos

# Test configuration (activates but doesn't set as boot default)
sudo nixos-rebuild test --flake .#nixos

# Switch (activates and sets as boot default)
sudo nixos-rebuild switch --flake .#nixos
```

### Check Flake Inputs

```bash
# Show current input versions
nix flake metadata /etc/nixos

# Show what would be updated
nix flake update --dry-run
```

---

## NixOS-WSL (Channel-based, Legacy)

```bash
# Update channels and rebuild
$ sudo nix-channel --update
$ sudo nixos-rebuild switch

# Or combined
$ sudo nix-channel --update && sudo nixos-rebuild switch

# Test configuration before switching (recommended)
$ sudo nixos-rebuild test

# Build without switching (dry run)
$ sudo nixos-rebuild build
```

---

## Garbage Collection

```bash
# Remove old generations and free disk space
$ sudo nix-collect-garbage -d

# Remove generations older than 7 days
$ sudo nix-collect-garbage --delete-older-than 7d

# Check disk usage
$ nix-store --gc --print-dead

# List system generations
$ sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

---

## Resources

- NixOS Options: https://search.nixos.org/options
- Home Manager Options: https://nix-community.github.io/home-manager/options.xhtml
- NixOS-WSL: https://github.com/nix-community/NixOS-WSL
- Nix Flakes: https://nixos.wiki/wiki/Flakes
