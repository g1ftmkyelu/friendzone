class CreateFriendships < ActiveRecord::Migration[8.0]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: 'pending' # pending, accepted

      t.timestamps
      t.index [:user_id, :friend_id], unique: true
    end
  end
end