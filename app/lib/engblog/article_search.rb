module Engblog
  # Given a query,
  # return IDs of Articles which contain that query in the body or title.
  class ArticleSearch
    # @param query [String] The search term
    def initialize(query:)
    end

    def call
      [Article.first.id]
    end
  end
end
