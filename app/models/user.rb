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
  # => @user.profile_name
  delegate :name, :first_name, :slug, :avatar, to: :profile
  accepts_nested_attributes_for :profile

end

############################################
############################################
