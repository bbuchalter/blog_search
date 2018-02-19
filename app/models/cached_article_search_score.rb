class CachedArticleSearchScore < ActiveRecord::Base
  validates :article_id, :score, :article_search_cache_key, presence: true
end
