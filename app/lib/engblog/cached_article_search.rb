module Engblog
  class CachedArticleSearch
    def initialize(query:, page:, per_page:)
      @page = page
      @per_page = per_page
      @cache_key = ArticleSearchCacheKey.new(query: query, page: page).call
      @search_query = ArticleSearch.new(query: query).call if query
      @search_results = search_query.paginate(page: page, per_page: per_page)
    end

    def results
      store_search_results unless search_results_cached?
      find_articles_by_key_and_sort_by_score
    end

    def results_for_pagination
      search_query.paginate(page: page, per_page: per_page)
    end

    private

    attr_reader :cache_key, :search_results, :search_query, :page, :per_page

    def store_search_results
      search_results.each do |result|
        CachedArticleSearchScore.create!(
          article_search_cache_key: cache_key,
          article_id: result.id,
          score: result["sum_score"]
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
