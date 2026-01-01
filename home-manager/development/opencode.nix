{
  inputs,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;

  rime = inputs.rime.packages.${system}.default;
in
{
  programs.opencode = {
    enable = true;
    package = inputs.opencode.packages.${system}.default;

    # System prompt
    # rules = ''

    # '';

    # agents = {};

    settings = {
      plugin = [
        "opencode-openai-codex-auth@4.2.0"
        "opencode-gemini-auth@1.3.6"
      ];
      provider = {
        google = {
          models = {
            "gemini-3-flash-preview" = {
              name = "Gemini 3 Flash Preview";
              limit = {
                context = 1048576;
                output = 8192;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
            };
          };
        };
      };
      mcp = {
        viro = {
          type = "remote";
          url = "http://localhost:8099/mcp/sse";
          enabled = true;
        };
        rime = {
          type = "local";
          command = [
            "${rime}/bin/rime"
            "stdio"
          ];
          enabled = true;
        };
      };
    };
  };
}
