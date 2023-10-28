{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: with lib; let
    cfg = config.myOptions.programs.anyrun;
in {
    options.myOptions.programs.anyrun.enable = mkEnableOption "enable anyrun";

    config = mkIf cfg.enable {
        nix.settings = {
            substituters = [ "https://anyrun.cachix.org" ];
            trusted-public-keys = [ "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s=" ];
        };
        home-manager.users.${config'.username} = {
            imports = [ inputs.anyrun.homeManagerModules.default ];

            programs.anyrun = {
                enable = true;
                config = {
                    plugins = with inputs.anyrun.packages.${pkgs.system}; [
                        applications
                        dictionary
                        kidex
                        rink
                        symbols
                        translate
                    ];
                    hideIcons = false;
                    ignoreExclusiveZones = false;
                    layer = "overlay";
                    hidePluginInfo = false;
                    closeOnClick = true;
                    showResultsImmediately = true;
                    maxEntries = 50;
                    width.fraction = 0.3;
                    y.absolute = 15;
                };

                extraCss = ''
                    * {
                        all: unset;
                        font-family: Lexend;
                        font-size: 1.3rem;
                    }

                    #window,
                    #match,
                    #entry,
                    #plugin,
                    #main { background: transparent; }

                    #match.activatable {
                        border-radius: 16px;
                        padding: .3rem .9rem;
                        margin-top: .01rem;
                    }
                    #match.activatable:first-child { margin-top: .7rem; }
                    #match.activatable:last-child { margin-bottom: .6rem; }

                    #plugin:hover #match.activatable {
                        border-radius: 10px;
                        padding: .3rem;
                        margin-top: .01rem;
                        margin-bottom: 0;
                    }

                    #match:selected, #match:hover, #plugin:hover {
                        background: rgba(255, 255, 255, .1);
                    }

                    #entry {
                        background: rgba(255,255,255,.05);
                        border: 1px solid rgba(255,255,255,.1);
                        border-radius: 16px;
                        margin: .3rem;
                        padding: .3rem 1rem;
                    }

                    list > #plugin {
                        border-radius: 16px;
                        margin: 0 .3rem;
                    }
                    list > #plugin:first-child { margin-top: .3rem; }
                    list > #plugin:last-child { margin-bottom: .3rem; }
                    list > #plugin:hover { padding: .6rem; }

                    box#main {
                        background: rgba(0, 0, 0, .5);
                        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .1), 0 0 0 1px rgba(0, 0, 0, .5);
                        border-radius: 24px;
                        padding: .3rem;
                    }
                '';
                extraConfigFiles = {
                    "applications.ron".text = ''
                        Config(
                            desktop_actions: true,
                            terminal: Some("foot"),
                            max_entries: 30,
                        )
                    '';
                    "dictionary.ron".text = ''
                        Config(
                            prefix: ":d",
                        )
                    '';
                    "symbols.ron".text = ''
                        Config(
                            prefix: ":s",
                        )
                    '';
                    "translate.ron".text = ''
                        Config(
                            prefix: ":",
                            language_delimiter: ">",
                        )
                    '';
                };
            };
        };
    };
}
