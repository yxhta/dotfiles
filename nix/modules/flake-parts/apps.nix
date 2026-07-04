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
            is_dotfiles_repo() {
              candidate=$1
              [ -n "$candidate" ] || return 1
              [ -f "$candidate/nix/flake.nix" ] || return 1
              [ -f "$candidate/bin/dotlink" ] || return 1
            }

            discovered_repo_root=
            if discovered_repo_root="$(${pkgs.git}/bin/git rev-parse --show-toplevel 2>/dev/null)" && is_dotfiles_repo "$discovered_repo_root"; then
              repo_root=$discovered_repo_root
            elif is_dotfiles_repo "${identity.dotfilesDir}"; then
              repo_root="${identity.dotfilesDir}"
            else
              echo "error: cannot locate the dotfiles repository for install-hooks." >&2
              if [ -n "$discovered_repo_root" ]; then
                echo "git discovered: $discovered_repo_root" >&2
              else
                echo "git discovered: <none; not inside a git worktree>" >&2
              fi
              echo "fallback dotfilesDir: ${identity.dotfilesDir}" >&2
              echo "expected both nix/flake.nix and bin/dotlink under a valid repository root." >&2
              echo "run this app from the dotfiles repository or update identity.dotfilesDir in nix/modules/flake-parts/identity.nix." >&2
              exit 1
            fi
            cd "$repo_root"
            if [ ! -d .git ]; then
              echo "no .git directory at $(pwd); skipping" >&2
              exit 1
            fi
            ${config.checks.pre-commit.shellHook}
            echo "pre-commit hook installed at $(pwd)/.git/hooks/pre-commit"
          ''
        );
      };
    };
}
