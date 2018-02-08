module Engblog
  # Given a query,
  # return IDs of Articles which contain that query in the body or title.
  class ArticleSearch
    # @param query [String] The search term
    def initialize(query:)
      @query = query
    end

    def call
      Article.where(title_match).pluck(:id)
    end

    private

    attr_reader :query

    def title_match
      @title_match ||= Article.arel_table[:title].matches(wildcard_query)
    end

    def wildcard_query
      @wildcard_query ||= "%#{query}%"
    end
  end
end
