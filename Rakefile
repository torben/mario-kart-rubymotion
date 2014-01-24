# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'bubble-wrap/reactor'
# require 'YAML'

APP_CONFIG = YAML.load_file('config/config.yml').freeze

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Mario Kart'
  app.seed_id = "RC9R3JH5YP"
  app.identifier = 'com.redpeppix.mariokart'

  app.version = '0.1.0'
  app.short_version = '0.1.0'

  app.deployment_target = "7.0"
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]

  app.frameworks += %w(AVFoundation AudioToolbox)

  app.icons = %w(app_icon_iphone@2x.png)

  app.vendor_project('vendor/static', :static)

  app.development do
    app.codesign_certificate = APP_CONFIG['development']['codesign_certificate']
    app.provisioning_profile = APP_CONFIG['development']['provisioning_profile']
    app.entitlements['aps-environment'] = APP_CONFIG['development']['entitlements']['aps-environment']

    app.info_plist.merge! APP_CONFIG['development']['info_plist']
  end

  app.release do
    app.codesign_certificate = APP_CONFIG['release']['codesign_certificate']
    app.provisioning_profile = APP_CONFIG['release']['provisioning_profile']
    app.entitlements['aps-environment'] = APP_CONFIG['release']['entitlements']['aps-environment']

    app.info_plist.merge! APP_CONFIG['release']['info_plist']
  end
end
