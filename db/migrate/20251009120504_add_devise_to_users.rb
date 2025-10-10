# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def self.up
    # Database authenticatable
    unless column_exists?(:users, :email)
      add_column :users, :email, :string, null: false, default: ""
    end
    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, null: false, default: ""
    end

    # Recoverable
    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string
    end
    unless column_exists?(:users, :reset_password_sent_at)
      add_column :users, :reset_password_sent_at, :datetime
    end

    # Rememberable
    unless column_exists?(:users, :remember_created_at)
      add_column :users, :remember_created_at, :datetime
    end

    # Migrate old password_digest to encrypted_password, if present
    if column_exists?(:users, :password_digest)
      execute <<~SQL
        UPDATE users
        SET encrypted_password = password_digest
        WHERE password_digest IS NOT NULL AND password_digest <> '';
      SQL
      remove_column :users, :password_digest
    end

    # Indexes
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end

  def self.down
    unless column_exists?(:users, :password_digest)
      add_column :users, :password_digest, :string
    end
    execute "UPDATE users SET password_digest = encrypted_password WHERE encrypted_password IS NOT NULL AND encrypted_password <> '';"
    remove_column :users, :encrypted_password if column_exists?(:users, :encrypted_password)
    raise ActiveRecord::IrreversibleMigration
  end
end