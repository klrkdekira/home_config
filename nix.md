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

## Update NixOS-WSL

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

### Garbage Collection

```bash
# Remove old generations and free disk space
$ sudo nix-collect-garbage -d

# Remove generations older than 7 days
$ sudo nix-collect-garbage --delete-older-than 7d

# Check disk usage
$ nix-store --gc --print-dead
```

### Options

https://nix-community.github.io/home-manager/options.xhtml
