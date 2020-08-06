{
  description = "provides an easy way to develop and deploy your Reflex project as web apps and as mobile apps";

  outputs = { self }: let
    systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
    genAttrs = names: f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) names);
    forAllSystems = f: genAttrs systems (system: f system);
  in {

    packages = forAllSystems (system: let
      obelisk = import ./. { inherit system; };
    in {
      inherit (obelisk.obelisk) obelisk-command;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.obelisk-command);

  };
}
