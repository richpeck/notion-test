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

  ## Password ##
  ## Storing passwords requires encryption. Obviously, how this is done is dependent on the technology stack ##
  ## The standard process for doing it is to store the passwords as an unreadable hash, such as MD5 ##
  ## However, there may be more efficient ways of doing it depending on the type of database you're using ##
  ## -- ##
  ## We've used the following to give us the ability to take advantage of the db layer: https://stackoverflow.com/a/36708013/1143732 ##
  def up
    create_table table, options do |t|
      t.string :email                                                            # => email
      t.send (adapter.to_sym == :PostgresSQL ? :chkpass : :string), :password       # => password
      t.send (adapter.to_sym == :SQLite   ? :string : :inet), :last_signed_in_ip # => last_signed_in_ip
      t.datetime :last_signed_in_at                                              # => last_signed_in_at
      t.timestamps                                                               # => created_at, updated_at
      t.index :email, unique: true, name: 'email_unique' # => one email per user
    end
  end #up

end

####################################################################
####################################################################
