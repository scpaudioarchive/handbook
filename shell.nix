let
     nixpkgs = builtins.fetchTarball {
       # Hugo 0.87.0
       url = "https://github.com/NixOS/nixpkgs/archive/d258316fba32587b63f1efa14df1f25a50fd25e3.tar.gz";
     };
in

{ pkgs ? import nixpkgs {} }:

with pkgs;
let
  hugo-theme-techdoc = runCommand "hugo-theme-techdoc" {
    pinned = builtins.fetchGit {
      url = "https://github.com/thingsym/hugo-theme-techdoc";
      ref = "refs/heads/master";
      rev = "5bf9a4d1868fc3f579599f6b6a32280f05024968";
    };

    patches = [ ];
    preferLocalBuild = true;
  }
    ''
cp -r $pinned $out
chmod -R u+w $out

for p in $patches; do
    echo "Applying patch $p"
    patch -d $out -p1 < "$p"
done
'';

in
mkShell {
  buildInputs = [
    hugo
  ];

  shellHook = ''
mkdir -p themes
ln -snf "${hugo-theme-techdoc}" themes/techdoc
'';

  # HUGO_ENV = "production";
}
