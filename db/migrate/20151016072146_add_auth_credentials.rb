class AddAuthCredentials < ActiveRecord::Migration
  def change

    add_column :authorizations, :refresh_token, :string
    add_column :authorizations, :expires_at, :integer
    add_column :authorizations, :expires_in, :integer
    add_column :authorizations, :expires, :boolean

  end
end
