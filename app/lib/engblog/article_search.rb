module Engblog
  # Given a query,
  # return an ActiveRecord::Relation of Articles
  # which contain that query in the body or title,
  # sorted by their WordScore.
  class ArticleSearch
    # @param query [String] The search term
    def initialize(query:)
      @query = query
    end

    def call
      Article
        .select("articles.*, SUM(score) as sum_score")
        .joins(:word_scores)
        .where(WordScore.arel_table['word'].in(search_words))
        .where(Article.arel_table['published'].eq(true))
        .group(:article_id)
        .order('sum_score DESC')
    end

    private

    attr_reader :query

    def search_words
      TextToSearchWords.new(text: query).call
    end
  end
end
