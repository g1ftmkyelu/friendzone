class CreateCommunityMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :community_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending' # pending, accepted

      t.timestamps
      t.index [:user_id, :community_id], unique: true
    end
  end
end