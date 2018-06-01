require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TemplateProject
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.autoload_paths << Rails.root.join("app").join("lib")
    config.eager_load_paths << Rails.root.join("app").join("lib")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
  # Where the I18n library should search for translation files
  I18n.load_path += Dir[Rails.root.join("lib", "locale", "*.{rb,yml}")]

  # Whitelist locales available for the application
  I18n.available_locales = [:en, :es]

  # Set default locale to something other than :en
  I18n.default_locale = :es
end
