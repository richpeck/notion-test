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

## Users ##
## id | email | password (encrypted) | last_signed_in_ip | last_signed_in_at | created_at | updated_at ##
class CreateUsers < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb
  def up
    create_table table, options do |t|
      t.string :email                                                            # => email
      t.string :password                                                         # => password
      t.send (adapter.to_sym == :SQLite ? :string : :inet), :last_signed_in_ip # => last_signed_in_ip
      t.datetime :last_signed_in_at                                              # => last_signed_in_at
      t.timestamps                                                               # => created_at, updated_at
      t.index :email, unique: true, name: 'email_unique' # => one email per user
    end
  end
end

####################################################################
####################################################################
