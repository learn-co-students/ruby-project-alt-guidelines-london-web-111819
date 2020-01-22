class Reviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :dental_hygienist_id
      t.integer :user_id
      t.integer :star_review #ask how to delete old table on db browser for new info
      t.string :comment_review
    end
  end
end
