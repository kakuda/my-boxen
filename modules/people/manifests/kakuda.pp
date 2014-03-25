class people::kakuda {
  include iterm2::stable
  include dropbox
  include eclipse::java
  include chrome
  include clipmenu
  include emacs::formacosx
  include unarchiver
  include java
  include r

  osx_login_item { 'ClipMenu':
    name    => 'ClipMenu',
    path    => '/Applications/ClipMenu.app',
    hidden  => true,
    require => Class['clipmenu'],
  }

  # homebrew
  package {
    [
      'cscope',
      'leiningen',
      'python',
      'python3',
      'reattach-to-user-namespace',
      'redis',
      'sbcl',
      'ssh-copy-id',
      'tmux',
    ]:
    ensure => latest,
  }

  # Python packages
  # package {
  #   [
  #     'virtualenv',
  #     'virtualenvwrapper',
  #   ]:
  #   ensure   => latest,
  #   provider => pip,
  # }

  package {
    'GoogleJapaneseInput':
      source   => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;

    'LightTable':
      source   => "http://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.6.4/LightTableMac.zip",
      provider => compressed_app;

    'CotEditor':
      source   => "http://jaist.dl.sourceforge.jp/coteditor/54872/CotEditor_1.3.1_For10.7.dmg",
      provider => appdmg;

    'Dash':
      source   => "http://tokyo.kapeli.com/Dash.zip",
      provider => compressed_app;
  }

  package { 'zsh':
    install_options => [
      '--disable-etcdir'
    ]
  }

  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before  => Osx_chsh[$::luser];
  }
  
  osx_chsh { $::luser:
    shell => "${boxen::config::homebrewdir}/bin/zsh";
  }

  include osx::finder::show_all_on_desktop
  include osx::finder::unhide_library
  include osx::disable_app_quarantine
  include osx::dock::autohide
  include osx::no_network_dsstores
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::natural_mouse_scrolling
  
  class { 'osx::dock::position':
    position => 'left'
  }
  class { 'osx::global::key_repeat_delay':
    delay => 10
  }
  class { 'osx::global::key_repeat_rate':
    rate => 1
  }
}