class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :name, null: false
      t.text :description
      t.string :category
      t.integer :likes_count, default: 0

      t.timestamps
    end
    add_index :pages, :name, unique: true
  end
end