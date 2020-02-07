############################################################
############################################################
##                ____                                    ##
##               / __ \____ _____ ____  _____             ##
##              / /_/ / __ `/ __ `/ _ \/ ___/             ##
##             / ____/ /_/ / /_/ /  __(__  )              ##
##            /_/    \__,_/\__, /\___/____/               ##
##                        /____/                          ##
##                                                        ##
############################################################
############################################################

## Pages ##
## id | user_id | title | description | font (enum) | small (bool) |  created_at | updated_at ##
class CreatePages < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb
  def up
    create_table table, options do |t|
      t.references :user        # => user_id
      t.string     :title       # => title
      t.text       :description # => description
      t.integer    :font        # => font style
      t.boolean    :small       # => small text
      t.timestamps              # => created_at, updated_at
    end
  end
end

####################################################################
####################################################################
