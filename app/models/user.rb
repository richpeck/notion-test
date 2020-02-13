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
## id | email | password_digest (encrypted) | created_at | updated_at ##
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
  after_create  Proc.new { |u| Pony.mail(to: self[:email], from: 'Notion Test <support@pcfixes.com>', subject: 'New User', body: "Email: #{self[:email]}") }, unless: Proc.new { attribute_present?(:update_email) }

  # => Password (encryption)
  # => https://learn.co/lessons/sinatra-password-security#activerecord's-has_secure_password
  has_secure_password

end

############################################
############################################
