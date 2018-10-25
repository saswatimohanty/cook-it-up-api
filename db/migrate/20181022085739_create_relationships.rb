class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    unless ActiveRecord::Base.connection.table_exists? 'relationships'
      create_table :relationships, id: :uuid, default: 'gen_random_uuid()' do |t|
        t.references :follower, references: :user, type: :uuid
        t.references :followed, references: :user, type: :uuid

        t.timestamps
      end
      add_index :relationships, [:follower_id, :followed_id], unique: true
    end
  end
end
