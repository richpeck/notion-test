##########################################################
##########################################################
##              __  __      __                          ##
##             / | / /___  / /_(_)___  ____             ##
##            /  |/ / __ \/ __/ / __ \/ __ \            ##
##           / /|  / /_/ / /_/ / /_/ / / / /            ##
##          /_/ |_/\____/\__/_/\____/_/ /_/             ##
##                                                      ##
##########################################################
##########################################################
##              Main Sinatra app.rb file                ##
## Allows us to define, manage and serve various routes ##
##########################################################
##########################################################
## Simple test to see if we can replicate the "Notion.so" functionality
## I believe the core aspect of the system (Pages) can be replicated using AR + React frontend
##########################################################
##########################################################

# => Constants
# => Should be loaded by Bundler, but this has to do for now
require_relative '../config/constants'

##########################################################
##########################################################

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENVIRONMENT if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##########################################################
##########################################################

# => Models
# => This allows us to load all the models (which are not loaded by default)
require_all 'app', 'lib'

##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class App < Sinatra::Base

  ##########################################################
  ##########################################################
  ##              ______            _____                 ##
  ##             / ____/___  ____  / __(_)___ _           ##
  ##            / /   / __ \/ __ \/ /_/ / __ `/           ##
  ##           / /___/ /_/ / / / / __/ / /_/ /            ##
  ##           \____/\____/_/ /_/_/ /_/\__, /             ##
  ##                                  /____/              ##
  ##########################################################
  ##########################################################

    # => Sessions
    # => Used by Rack::Flash
    # => https://github.com/nakajima/rack-flash#sinatra
    # => https://github.com/vast/sinatra-redirect-with-flash
    enable :sessions # => used by RedirectWithFlash

    # => Register
    # => This allows us to call the various extensions for the system
    register Sinatra::Cors                # => Protects from unauthorized domain activity
    register Padrino::Helpers             # => number_to_currency (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::RespondWith         # => http://sinatrarb.com/contrib/respond_with
    register Sinatra::MultiRoute          # => Multi Route (allows for route :put, :delete)
    register Sinatra::Namespace           # => Namespace (http://sinatrarb.com/contrib/namespace.html)

    # => Flash
    # => Allows us to use the "flash" object (rack-flash3)
    # => Required to get redirect_with_flash working
    use Rack::Flash, accessorize: [:notice, :error], sweep: true

    # => Helpers
    # => Allows us to manage the system at its core
    helpers Sinatra::RequiredParams     # => Required Parameters (ensures we have certain params for different routes)
    helpers Sinatra::RedirectWithFlash  # => Used to provide "flash" functionality with redirect helper

    # => Includes
    # => Functionality provided by various systems (some my own)
    include Auth # => app/auth.rb (used for Warden)

  ##########################################################
  ##########################################################

    # => Development
    # => Ensures we're only loading in development environment
    configure :development do
      register Sinatra::Reloader  # => http://sinatrarb.com/contrib/reloader
    end

  ##########################################################
  ##########################################################

    # => General
    # => Allows us to determine various specifications inside the app
    set :haml, { layout: :'layouts/application' } # https://stackoverflow.com/a/18303130/1143732
    set :views, Proc.new { File.join(root, "views") } # required to get views working (defaulted to ./views)
    set :public_folder, File.join(root, "..", "public") # Root dir fucks up (public_folder defaults to root) http://sinatrarb.com/configuration.html#root---the-applications-root-directory

    # => Required for CSRF
    # => https://cheeyeo.uk/ruby/sinatra/padrino/2016/05/14/padrino-sinatra-rack-authentication-token/
    set :protect_from_csrf, true

  ##########################################################
  ##########################################################

    # => Asset Pipeline
    # => Allows us to precompile assets as you would in Rails
    # => https://github.com/kalasjocke/sinatra-asset-pipeline#customization
    set :assets_prefix, '/dist' # => Needed to access assets in frontend
    set :assets_public_path, File.join(public_folder, assets_prefix.strip) # => Needed to tell Sprockets where to put assets
    set :assets_css_compressor, :sass
    set :assets_js_compressor,  :uglifier
    set :assets_precompile, %w[javascripts/app.js stylesheets/app.sass *.png *.jpg *.gif *.svg] # *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2
    set :precompiled_environments, %i(staging production) # => Only precompile in staging & production

    # => Register
    # => Needs to be below definitions
    register Sinatra::AssetPipeline

  ##########################################################
  ##########################################################

    # => Sprockets
    # => This is for the layout (calling sprockets helpers etc)
    # => https://github.com/petebrowne/sprockets-helpers#setup
    configure do

      # RailsAssets
      # Required to get Rails Assets gems working with Sprockets/Sinatra
      # https://github.com/rails-assets/rails-assets-sinatra#applicationrb
      RailsAssets.load_paths.each { |path| settings.sprockets.append_path(path) } if defined?(RailsAssets)

      # => Paths
      # => Used to add assets to asset pipeline
      %w(stylesheets javascripts images).each do |folder|
        sprockets.append_path File.join(root, 'assets', folder)
        sprockets.append_path File.join(root, '..', 'vendor', 'assets', folder)
      end #paths

      # => Pony
      # => SMTP used to send email to account owner
      # => https://github.com/benprew/pony#default-options
      Pony.options = {
        via: :smtp,
        via_options: {
          address:  'smtp.sendgrid.net',
          port:     '587',
          domain:    DOMAIN,
          user_name: 'apikey',
          password:  ENV.fetch('SENDGRID'),
          authentication: :plain,
          enable_starttls_auto: true
        }
      } #pony

    end

  ##########################################################
  ##########################################################

    ## CORS ##
    ## Only allow requests from domain ##
    set :allow_origin,   URI::HTTPS.build(host: DOMAIN).to_s
    set :allow_methods,  "GET,POST,PUT,DELETE"
    set :allow_headers,  "accept,content-type,if-modified-since"
    set :expose_headers, "location,link"

  ##############################################################
  ##############################################################
  ##     ____             __    __                         __ ##
  ##    / __ \____ ______/ /_  / /_  ____  ____ __________/ / ##
  ##   / / / / __ `/ ___/ __ \/ __ \/ __ \/ __ `/ ___/ __  /  ##
  ##  / /_/ / /_/ (__  ) / / / /_/ / /_/ / /_/ / /  / /_/ /   ##
  ## /_____/\__,_/____/_/ /_/_.___/\____/\__,_/_/   \__,_/    ##
  ##                                                          ##
  ##############################################################
  ##############################################################
  ## This is the central "management" page that is shown to the user
  ## It needs to include authentication to give them the ability to access it
  ##############################################################
  ##############################################################

  # => Dash
  # => Shows Pages/Databases the user has created
  # => Required authentication
  get '/' do
    Pony.mail(to: "support@pcfixes.com", subject: "Test", body: "test", from: "support@pcfixes.com")
    env['warden'].authenticate! # => required to ensure protection
    haml :index
  end ## get

  ##############################################################
  ##############################################################

end ## app.rb

##########################################################
##########################################################
