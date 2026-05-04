{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      identity,
      config,
      ...
    }:
    let
      flakeRef = "${inputs.self}#${identity.hostname}";

      # Detect AI agent shells and skip nix-output-monitor — its TUI
      # output is not useful when consumed by an agent.
      isAgentCheck = ''
        IS_AI_AGENT=false
        for var in CLAUDE_CODE CLAUDECODE CODEX_SANDBOX CODEX_THREAD_ID GEMINI_CLI OPENCODE AI_AGENT; do
          eval "val=\''${!var:-}"
          if [ -n "$val" ]; then
            IS_AI_AGENT=true
            break
          fi
        done
      '';
    in
    {
      apps = {
        build.program = toString (
          pkgs.writeShellScript "darwin-build" ''
            set -eu
            ${isAgentCheck}
            echo "Building darwin configuration..."
            if [ "$IS_AI_AGENT" = true ]; then
              nix build "${inputs.self}#darwinConfigurations.${identity.hostname}.system"
            else
              ${pkgs.nix-output-monitor}/bin/nom build "${inputs.self}#darwinConfigurations.${identity.hostname}.system"
            fi
            echo "Build successful. Run 'nix run .#switch' to apply."
          ''
        );

        switch.program = toString (
          pkgs.writeShellScript "darwin-switch" ''
            set -eo pipefail
            ${isAgentCheck}
            echo "Switching to new darwin configuration..."
            if [ "$IS_AI_AGENT" = true ]; then
              sudo darwin-rebuild switch --flake "${flakeRef}"
            else
              sudo darwin-rebuild switch --flake "${flakeRef}" |& ${pkgs.nix-output-monitor}/bin/nom
            fi
          ''
        );

        # Idempotent: re-run after clone or whenever the hook config changes.
        install-hooks.program = toString (
          pkgs.writeShellScript "install-pre-commit-hooks" ''
            set -eu
            cd "${identity.dotfilesDir}"
            if [ ! -d .git ]; then
              echo "no .git directory at ${identity.dotfilesDir}; skipping" >&2
              exit 1
            fi
            ${config.checks.pre-commit.shellHook}
            echo "pre-commit hook installed at ${identity.dotfilesDir}/.git/hooks/pre-commit"
          ''
        );
      };
    };
}
