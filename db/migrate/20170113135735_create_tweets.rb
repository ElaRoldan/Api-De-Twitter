class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.belongs_to :twitter_user, index: true
      t.string :body
      t.datetime :user_creation_time
      t.timestamps
    end
  end
end
