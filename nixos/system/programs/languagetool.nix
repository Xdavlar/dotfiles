{...}: {
  flake.nixosModules.languagetool = {
    lib,
    config,
    ...
  }: {
    options.languagetool.enable = lib.mkEnableOption "self-hosted LanguageTool server";

    config = lib.mkIf config.languagetool.enable {
      virtualisation.oci-containers.backend = "docker";
      virtualisation.oci-containers.containers.languagetool = {
        image = "erikvl87/languagetool";
        ports = ["127.0.0.1:8010:8010"];
        environment = {
          Java_Xms = "512m";
          Java_Xmx = "2g";
        };
        volumes = ["/var/lib/languagetool/ngrams:/ngrams"];
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/languagetool/ngrams 0755 root root -"
      ];
    };
  };
}
