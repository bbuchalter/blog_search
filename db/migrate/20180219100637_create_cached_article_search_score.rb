class CreateCachedArticleSearchScore < ActiveRecord::Migration[5.0]
  def change
    create_table :cached_article_search_scores do |t|
      t.references :article, null: false
      t.integer :score, null: false
      t.string :article_search_cache_key, null: false

      t.timestamps
    end
  end
end
