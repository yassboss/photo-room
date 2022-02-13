class CreateGroupPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :group_posts do |t|
      t.string      :group_title,   null: false
      t.text        :group_text,    null: false
      t.integer     :group_id,      null: false, foreign_key: true
      t.timestamps
    end
  end
end
