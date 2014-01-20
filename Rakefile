# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

require 'bubble-wrap/reactor'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Mario Kart'

  app.version = '0.0.1'
  app.short_version = '0.0.1'

  app.deployment_target = "7.0"
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]

  app.icons = %w(app_icon_iphone@2x.png)

  app.vendor_project('vendor/static', :static)

  app.development do
    app.info_plist['host'] = "http://192.42.21.140:3000"

    app.codesign_certificate = "iPhone Developer: Torben Toepper (62DJCS8SKP)"
    app.provisioning_profile = "config/provision/59DC8815-1DBE-4B65-AE22-DD21A8C6CAE7.mobileprovision"
    app.entitlements['aps-environment'] = 'development'
  end
end
