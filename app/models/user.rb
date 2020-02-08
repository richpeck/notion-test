############################################################
############################################################
##                __  __                                  ##
##               / / / /_______  __________               ##
##              / / / / ___/ _ \/ ___/ ___/               ##
##             / /_/ (__  )  __/ /  (__  )                ##
##             \____/____/\___/_/  /____/                 ##
##                                                        ##
############################################################
############################################################
## Gives us the ability to create & manage "users"
## EG @user.pages.x
##############################################################
##############################################################

## User ##
## This only stores "user" data (we have "profile" for extras)
## id | email | password (encrypted) | created_at | updated_at ##
class User < ActiveRecord::Base

  # => Associations
  # => Give us the ability to connect with other models
  has_one :profile, dependent: :destroy, inverse_of: :user
  before_create :build_profile, unless: :profile

  # => Delegations
  # => @user.name (no prefix)
  delegate :name, :first_name, to: :profile # => @user.name
  accepts_nested_attributes_for :profile

  # => Favorites
  # => Uses the "associations" model to provide us with the ability to "favourite" posts
  has_many :associations, as: :associated, dependent: :destroy
  has_many :favorites, through: :associations, source: :associatiable, source_type: "Page" # => User 1 | Page 15

  # => Validations
  validates :email, presence: true

  # => Password
  # => This allows us to create a password + send it to email if the created user does not have a password (seed)
  attr_accessor :update_email # => Used to determine if a user needs to be emailed once they get registered
  after_create  :send_email, unless: Proc.new { attribute_present?(:update_email) }
  before_create Proc.new { |u| u.password = "test" }, unless: Proc.new { attribute_present?(:password) } # => https://apidock.com/rails/ActiveRecord/AttributeMethods/attribute_present%3F

  ###################################
  ###################################

  # => Authenticate
  # => Determines if the user is authenticated or not
  # => https://github.com/sklise/sinatra-warden-example#modelrb-reopened
  def authenticate(attempted_password)
    self.password == attempted_password
  end

  ###################################
  ###################################

  private

  # => Send Email
  # => This sends an email to the account's owner, with their password
  def send_email

    # => Build Email
    # => This gives us the ability to send the email
    from    = SendGrid::Email.new(email: 'Notion Test <support@pcfixes.com>')
    to      = SendGrid::Email.new(email: self[:email])
    content = SendGrid::Content.new(type: 'text/plain', value: "Email: #{self[:email]}\nPassword: #{self[:password]}")
    mail    = SendGrid::Mail.new(from, 'Password', to, content)

    # => Send Email
    email = SendGrid::API.new api_key: ENV.fetch("SENDGRID")
    email = email.client.mail._('send').post(request_body: mail.to_json)

  end

end

############################################
############################################
