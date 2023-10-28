{pkgs, config, ...};

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = with config.boot.kernelPackages; [ plymouth ];
    kernelParams = [ "quiet" "splash" ];
  };
}
