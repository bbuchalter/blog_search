class CachedArticleSearchPageCount < ActiveRecord::Base
  validates :article_search_cache_key, :page_count, presence: true
end
