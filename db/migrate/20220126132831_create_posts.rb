class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string      :title,    null: false
      t.text        :text,     null: false
      t.integer     :theme_id
      t.string      :action,   default: '', null: false
      t.references  :user,     null: false, foreign_key: true
      t.timestamps
    end
  end
end
