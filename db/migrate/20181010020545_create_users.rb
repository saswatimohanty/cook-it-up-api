class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    unless ActiveRecord::Base.connection.table_exists? 'users'
      create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
        t.string :first_name
        t.string :last_name
        t.string :email, null: false
        t.string :password_digest, null: false
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at

        t.timestamps
      end
    end
  end
end
