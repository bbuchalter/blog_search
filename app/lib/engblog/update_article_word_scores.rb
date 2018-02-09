module Engblog
  # Given an Article,
  # remove any existing word scores for the article,
  # calculate new word scores and record them.
  class UpdateArticleWordScores
    def initialize(article:)
      @article = article
    end

    def call
      WordScore.where(article_id: article.id).destroy_all
    end

    private

    attr_reader :article
  end
end
