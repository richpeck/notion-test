##########################################################
##########################################################
##         _       __               __                  ##
##        | |     / /___ __________/ /__  ____          ##
##        | | /| / / __ `/ ___/ __  / _ \/ __ \         ##
##        | |/ |/ / /_/ / /  / /_/ /  __/ / / /         ##
##        |__/|__/\__,_/_/   \__,_/\___/_/ /_/          ##
##                                                      ##
##########################################################
##########################################################
## This is directly added to the "app.rb" file -- could be put in either /lib or /auth
## In order to get it working properly, we need to ensure we have included the file appropriately
## --
## Think of this as a means to extract functionality from the base app.rb
## https://github.com/sklise/sinatra-warden-example
##########################################################
##########################################################

# => Included
# => May need to change the name of the file
module Auth

  # => Vars
  # => Used for login/logout routes etc
  @@login    = 'login'
  @@logout   = 'logout'
  @@register = 'register'
  @@unauth   = 'unauthenticated'

  # => Included
  # => https://stackoverflow.com/a/28009954/1143732
  def self.included(base)
    base.class_eval do

      # => Warden
      # => This allows us to manage authentication within the app
      # => https://github.com/sklise/sinatra-warden-example#apprb-cont
      use Warden::Manager do |config|

        # Tell Warden how to save our User info into a session.
        # Sessions can only take strings, not Ruby code, we'll store
        # the User's `id`
        config.serialize_into_session{|user| user.id }
        # Now tell Warden how to take what we've stored in the session
        # and get a User from that information.
        config.serialize_from_session{|id| User.find(id) }

        config.scope_defaults :default,
          # "strategies" is an array of named methods with which to
          # attempt authentication. We have to define this later.
          strategies: [:password],
          # The action is a route to send the user to when
          # warden.authenticate! returns a false answer. We'll show
          # this route below.
          action: @@unauth
        # When a user tries to log in and cannot, this specifies the
        # app to send the user to.
        config.failure_app = self

      end

      # => Failure Manager
      # => Allows us to consider how the system should work
      Warden::Manager.before_failure do |env,opts|
        # Because authentication failure can happen on any request but
        # we handle it only under "post '/auth/unauthenticated'", we need
        # to change request to POST
        env['REQUEST_METHOD'] = 'POST'
        # And we need to do the following to work with  Rack::MethodOverride
        env.each do |key, value|
          env[key]['_method'] = 'post' if key == 'rack.request.form_hash'
        end
      end

      # => Strategies
      # => Password allows us to manage the system
      Warden::Strategies.add(:password) do
        def valid?
          params['user'] && params['user']['email'] && params['user']['password']
        end

        def authenticate!
          user = User.find_by email: params['user']['email'] # => email is unique, so any records will be the only record

          if user.nil?
            throw(:warden, message: "Email does not exist.")
          elsif user.authenticate(params['user']['password'])
            success!(user)
          else
            throw(:warden, message: "Bad password.")
          end
        end
      end

      ##########################################################
      ##########################################################
      ##             ____              __                     ##
      ##            / __ \____  __  __/ /____  _____          ##
      ##           / /_/ / __ \/ / / / __/ _ \/ ___/          ##
      ##          / _, _/ /_/ / /_/ / /_/  __(__  )           ##
      ##         /_/ |_|\____/\__,_/\__/\___/____/            ##
      ##                                                      ##
      ##########################################################
      ##########################################################

      # => Login (GET)
      # => Standard login form (no need to set anything except the HTML elements)
      # => Need to ensure users are redirected to index if they are logged in
      get "/#{@@login}" do
        haml :'auth/login'
      end

      # => Login (POST)
      # => Where the login form submits to (allows us to process the request)
      post "/#{@@login}" do
        env['warden'].authenticate!
        redirect (session[:return_to].nil? ? '/' : session[:return_to]), success: "Successfully Logged In"
      end

      # => Logout (GET)
      # => Request to log out of the system (allows us to perform session destroy)
      get "/#{@@logout}" do
        env['warden'].raw_session.inspect
        env['warden'].logout
        redirect '/', success: "Successfully Logged Out"
      end

      # => Unauthenticated (POST)
      # => Where to send the user if they are not authorized to view a page (IE they hit a page, and it redirects them to the unauthorized page)
      post "/#{@@unauth}" do
        session[:return_to] ||= env['warden.options'][:attempted_path]
        redirect "/#{@@login}", error: env['warden.options'][:message] || "You must log in"
      end

      #############################################
      #############################################

      # => Register
      # => Allows us to accept users into the application
      get "/#{@@register}" do
        @user = User.new
        haml :'auth/register'
      end

      # => Register (POST)
      # => Create the user from the sent items
      post "/#{@@register}" do
        required_params :user # => ensure we have the :user param set
        @user = User.new params.dig("user")
        if @user.save
          redirect "/"
        else
          haml :'auth/register'
        end
      end

      #############################################
      #############################################

    end #class_eval
  end #included
end #module
