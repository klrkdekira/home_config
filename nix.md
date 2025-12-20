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

### Options

https://nix-community.github.io/home-manager/options.xhtml
