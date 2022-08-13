{ name, packages }:

{ runCommand, lib }:
runCommand "build-sysext-${name}" { } (
  let
    doLink = { drv, prefix ? "usr", path, destpath ? null }:
      "do_link ${prefix} ${drv} ${path}" + lib.optionalString (destpath != null) " ${destpath}";
  in
  ''
    do_link () {
      local prefix="$1"
      local drv="$2"
      local path="$3"
      local destpath="''${4:-$path}"

      local srcfile
      local destdir
      local destfile
      srcfile="$drv/$path"
      destfile="$out/$prefix/$destpath"
      destdir="$(dirname -- "$destfile")"

      install -d -m 755 "$destdir"
      ln -s -T -v "$srcfile" "$destfile"
    }

    ${builtins.concatStringsSep "\n" (map doLink packages)}

    broken=$(cd $out; find . -type l -xtype l)
    if [ -n "$broken" ]; then
      echo "found broken symlinks:"
      echo "$broken"
      exit 1
    fi

    unexpected=$(cd $out; find . -maxdepth 1 -mindepth 1 '!' '(' -type d -name "usr" -o -type d -name "opt" ')')
    if [ -n "$unexpected" ]; then
      echo "found unexpected files in output:"
      echo "$unexpected"
      echo "note that only 'usr' and 'opt' are supported (for now)"
      exit 1
    fi
  ''
)
