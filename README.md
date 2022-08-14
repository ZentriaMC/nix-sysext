# nix-sysext

Create [systemd-sysext](https://www.freedesktop.org/software/systemd/man/systemd-sysext.html) system extensions using Nix

## Example

This works on Ubuntu 22.04 LTS

```shell
$ nix --extra-experimental-features 'nix-command flakes' build -L .#exampleExtUbuntu
$ sudo mkdir -p /run/extensions
$ sudo ln -vsT $(readlink result) /run/extensions/ubuntu-utils
$ sudo systemd-sysext list
$ sudo systemd-sysext merge
$ readlink /usr/bin/age
```
