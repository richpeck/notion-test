############################################################
############################################################
##                ____                                    ##
##               / __ \____ _____  ___  _____             ##
##              / /_/ / __ `/ __ `/ _ \/ ___/             ##
##             / ____/ /_/ / /_/ /  __(__  )              ##
##            /_/    \__,_/\__, /\___/____/               ##
##                        /____/                          ##
##                                                        ##
############################################################
############################################################
## Central data object in system (allows us to store pages + information)
## Allows us to move pages around with content etc @page.contents
############################################################
############################################################

## Page ##
## This only stores "user" data (we have "profile" for extras)
## id | database_id | email | password (encrypted) | created_at | updated_at ##
class Page < ActiveRecord::Base

  # => Associations
  # => Give us the ability to connect with other models
  belongs_to :user, required: true
  belongs_to :database # => allows us to store a page inside a database (one database per page presently)

  # => Databases
  # => A page can belong to a "database", allowing it to inherit a number of properties from it
  has_many :associations, as: :associated, dependent: :destroy
  has_many :properties, through: :associations, source: :associatiable, source_type: "Property"
  has_many :favorites, through: :associations, source: :associatiable, source_type: "User" # => User 1 | Page 15

end

############################################################
############################################################
