####################################################################
####################################################################
##     ___                         _       __  _                  ##
##    /   |  ______________  _____(_)___ _/ /_(_)___  ____  _____ ##
##   / /| | / ___/ ___/ __ \/ ___/ / __ `/ __/ / __ \/ __ \/ ___/ ##
##  / ___ |(__  |__  ) /_/ / /__/ / /_/ / /_/ / /_/ / / / (__  )  ##
## /_/  |_/____/____/\____/\___/_/\__,_/\__/_/\____/_/ /_/____/   ##
##                                                                ##
####################################################################
####################################################################

## Associations ##
## id | associatiable_type | associatiable_id | associated_type | associated_id | created_at | updated_at ##
class CreateAssociations < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb

  ###########################################
  ###########################################

  ## Up ##
  def up
    create_table table, options do |t|

      # => References
      t.references  :associatiable, polymorphic: true # => http://stackoverflow.com/a/29257570/1143732
      t.references  :associated, 	  polymorphic: true # => http://stackoverflow.com/a/29257570/1143732

      # => Index
      # => Required for upsert_all (ActiveRecord 6+)
      t.index [:associatiable_type, :associatiable_id, :associated_type, :associated_id], unique: true, name: 'association_index' # => RPECK 24/01/2020 don't need unique relation (limits line_items per order)
    end
  end #up

  ###########################################
  ###########################################

end

####################################################################
####################################################################
