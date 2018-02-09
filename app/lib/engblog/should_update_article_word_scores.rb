module Engblog
  class ShouldUpdateArticleWordScores
    def initialize(article:)
      @article = article
    end

    def call
      !(article.changed & ["title", "body"]).empty?
    end

    private

    attr_reader :article
  end
end
