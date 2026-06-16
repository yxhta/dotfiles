{ username, ... }:
{
  # nix-darwin requires primaryUser when any user-scoped default is set.
  system.primaryUser = username;

  # Declarative `defaults write` equivalents. Picked as opinionated-but-safe
  # starting values; tweak any line, then `darwin-rebuild switch` to apply.
  # `activateSettings -u` in postActivation reloads them without a logout.
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      mru-spaces = false;
      show-recents = false;
      tilesize = 64;
      minimize-to-application = true;
      expose-animation-duration = 0.1;
      launchanim = false;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };

    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      # Disable the press-and-hold accent menu so vim-style key repeat works.
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSWindowResizeTime = 0.001;
    };

  };

  # Modifier-key remap, scoped to the built-in Apple Internal Keyboard
  # (VendorID 0x05ac / ProductID 0x0343) so external keyboards (HHKB etc.)
  # keep their native layout. `system.keyboard.userKeyMapping` applies
  # hidutil globally and can't target a single device, so use a launchd
  # user agent with `hidutil --matching` instead.
  # HID usage codes:
  #   0x700000039 = Caps Lock
  #   0x7000000E0 = Left Control
  # Two-step apply: first clear any globally-set UserKeyMapping that may
  # linger from a prior `system.keyboard.userKeyMapping`-style global hidutil
  # call (which would otherwise be inherited by externally connected
  # keyboards like the HHKB), then apply the swap scoped to the internal
  # keyboard only.
  launchd.user.agents.internal-keyboard-keymapping.serviceConfig = {
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        /usr/bin/hidutil property --set '{"UserKeyMapping":[]}' > /dev/null
        /usr/bin/hidutil property --matching '{"VendorID":0x05ac,"ProductID":0x0343}' --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039}]}' > /dev/null
      ''
    ];
    RunAtLoad = true;
  };

  system.activationScripts.postActivation.text = ''
    # Reload preferences so `system.defaults` changes apply without a logout.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    # Mirror the launchd agent so `darwin-rebuild switch` takes effect
    # without waiting for the next login: clear any global UserKeyMapping
    # (including ones set by a previous `system.keyboard.userKeyMapping`),
    # then apply the per-device mapping to the internal keyboard.
    launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
      /usr/bin/hidutil property --set '{"UserKeyMapping":[]}' > /dev/null
    launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
      /usr/bin/hidutil property \
        --matching '{"VendorID":0x05ac,"ProductID":0x0343}' \
        --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0},{"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x700000039}]}' \
      > /dev/null
  '';
}
