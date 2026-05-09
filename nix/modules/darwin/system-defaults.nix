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

    LaunchServices.LSQuarantine = false;

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    loginwindow.GuestEnabled = false;
  };

  # Reload preferences so changes apply without a logout. Safe to re-run.
  system.activationScripts.postActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
