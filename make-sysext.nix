{ name, packages, osId, osVersion ? null }:

{ runCommand, lib }:

let
  metadata = {
    SYSEXT_LEVEL = "1.0";
    ID = osId;
    VERSION_ID = osVersion;
  };

  metadataFile = lib.concatStringsSep "\n"
    (lib.mapAttrsToList (k: v: "${k}=${v}")
      (lib.filterAttrs (_: v: v != null)
        metadata));

  doLink = { drv, prefix ? "usr", path, destpath ? null }:
    "do_link ${prefix} ${drv} ${path}" + lib.optionalString (destpath != null) " ${destpath}";

  supportedPaths = [ "usr" "opt" ];
in

runCommand "build-sysext-${name}"
{
  passthru.name = name;
  inherit metadataFile;
  passAsFile = [ "metadataFile" ];
}
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

      mkdir -pv "$destdir"
      ln -s -T -v "$srcfile" "$destfile"
    }

    ${lib.concatStringsSep "\n" (map doLink packages)}

    # bake metadata into the structure
    if ! [ -f $out/usr/lib/extension-release.d/extension-release."${name}" ]; then
      mkdir -p $out/usr/lib/extension-release.d
      cat "$metadataFilePath" > $out/usr/lib/extension-release.d/extension-release."${name}"
    fi

    broken=$(cd $out; find . -type l -xtype l)
    if [ -n "$broken" ]; then
      echo "found broken symlinks:"
      echo "$broken"
      exit 1
    fi

    unexpected=$(cd $out; find . -maxdepth 1 -mindepth 1 '!' '(' ${lib.concatStringsSep " -o " (map (p: "-type d -name \"${p}\"") supportedPaths)} ')')
    if [ -n "$unexpected" ]; then
      echo "found unexpected files in output:"
      echo "$unexpected"
      echo "note that only ${lib.concatStringsSep ", " (map (p: "'${p}'" supportedPaths))} are supported (for now)"
      exit 1
    fi

    if [ -f $out/usr/lib/os-release ]; then
      echo "output cannot contain /usr/lib/os-release"
      exit 1
    fi
  ''
