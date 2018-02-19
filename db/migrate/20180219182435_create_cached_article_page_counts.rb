class CreateCachedArticlePageCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :cached_article_search_page_counts do |t|
      t.string :article_search_cache_key, null: false
      t.integer :page_count, null: false

      t.timestamps
    end

    add_index :cached_article_search_page_counts, :article_search_cache_key, name: "cached_article_search_page_counts_cache_key"
  end
end
