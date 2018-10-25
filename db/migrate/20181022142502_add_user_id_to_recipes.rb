class AddUserIdToRecipes < ActiveRecord::Migration[5.1]
  def change
    unless column_exists? :recipes, :user_id
      add_reference :recipes, :user, type: :uuid
    end
  end
end
