module Engblog
  class CachedArticleSearch
    def initialize(query:, page:, per_page:)
      @page = page
      @per_page = per_page
      @cache_key = ArticleSearchCacheKey.new(query: query, page: page, per_page: per_page).call
      @search_query = ArticleSearch.new(query: query).call if query
      @search_results = search_query.paginate(page: page, per_page: per_page)
    end

    def results
      store_search_results unless search_results_cached?
      find_articles_by_key_and_sort_by_score
    end

    def pagination
      CachedPagination.new(
        search_query: search_query,
        page: page,
        per_page: per_page,
        cache_key: cache_key
      )
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

    class CachedPagination
      attr_reader :page, :per_page, :total_pages, :current_page

      def initialize(search_query:, page:, per_page:, cache_key:)
        @page = page.to_i
        @current_page = @page
        @per_page = per_page.to_i
        @cache_key = cache_key
        @search_query = search_query
        @total_pages = cached_page_count
      end

      private

      attr_reader :cache_key, :search_query

      def cached_page_count
        store_page_count unless page_count_cached?
        find_page_count_by_cache_key
      end

      def page_count_cached?
        CachedArticleSearchPageCount.exists?(
          article_search_cache_key: cache_key
        )
      end

      def store_page_count
        CachedArticleSearchPageCount.create!(
          article_search_cache_key: cache_key,
          page_count: search_query.paginate(page: page, per_page: per_page).total_pages
        )
      end

      def find_page_count_by_cache_key
        CachedArticleSearchPageCount.find_by!(
          article_search_cache_key: cache_key
        ).page_count
      end
    end
  end
end
