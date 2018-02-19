module Engblog
  class CachedArticleSearch
    def initialize(cache_key:, search_results:)
      @cache_key = cache_key
      @search_results = search_results
    end

    def call
      store_search_results unless search_results_cached?
      find_articles_by_key_and_sort_by_score
    end

    private

    attr_reader :cache_key, :search_results

    def store_search_results
      search_results.each do |result|
        CachedArticleSearchScore.create!(
          article_search_cache_key: cache_key,
          article_id: result.article_id,
          score: result.score
        )
      end
    end

    def search_results_cached?
      CachedArticleSearchScore.exists?(
        article_search_cache_key: cache_key
      )
    end

    def find_articles_by_key_and_sort_by_score
      Article
        .joins(:cached_article_search_scores)
        .where(CachedArticleSearchScore.arel_table[:article_search_cache_key].eq(cache_key))
        .order(CachedArticleSearchScore.arel_table[:score].desc)
    end
  end
end
