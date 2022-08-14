# nix-sysext

Create [systemd-sysext](https://www.freedesktop.org/software/systemd/man/systemd-sysext.html) system extensions using Nix

## Example

This works on [Ubuntu 22.04 LTS](https://gist.github.com/mikroskeem/7dcb0b5cccf013edf1501099987c324b)

```shell
$ nix --extra-experimental-features 'nix-command flakes' build -L .#exampleExtUbuntu
$ sudo mkdir -p /run/extensions
$ sudo ln -vsT $(readlink result) /run/extensions/ubuntu-utils
$ sudo systemd-sysext list
$ sudo systemd-sysext merge
$ readlink /usr/bin/age
```
