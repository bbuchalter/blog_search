module Engblog
  class ArticleSearchCacheKey
    def initialize(page:, query:, per_page:)
      @page = page
      @query = query
      @per_page = per_page
    end

    def call
      [
        search_words.sort,
        page,
        per_page,
        count_of_word_scores_for_search_words,
        max_id_of_word_scores_for_search_words,
      ].flatten.join('-')
    end

    private

    attr_reader :page, :query, :per_page

    def search_words
      @search_words ||= TextToSearchWords.new(text: query).call
    end

    def count_of_word_scores_for_search_words
      word_scores_for_search_words["count"]
    end

    def max_id_of_word_scores_for_search_words
      word_scores_for_search_words["max_id"]
    end

    def word_scores_for_search_words
      @word_scores_for_search_words ||= WordScore
        .select("MAX(id) as max_id, COUNT(*) as count")
        .where(word: search_words)
        .first
    end
  end
end
