class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    unless ActiveRecord::Base.connection.table_exists? 'recipes'
      create_table :recipes, id: :uuid, default: 'gen_random_uuid()' do |t|
        t.string :title
        t.string :body

        t.timestamps
      end
    end
  end
end
