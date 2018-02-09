class CreateWordScores < ActiveRecord::Migration[5.0]
  def change
    create_table :word_scores do |t|
      t.references :article, null: false
      t.string :word, null: false
      t.integer :score, null: false
      t.timestamps
    end

    add_index :word_scores, [:article_id, :word], unique: true
    add_foreign_key :word_scores, :articles
  end
end
