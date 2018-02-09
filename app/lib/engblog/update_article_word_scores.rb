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

      article_word_scores.each do |word, score|
        WordScore.create!(
          article: article,
          word: word,
          score: score
        )
      end
    end

    private

    attr_reader :article

    def article_word_scores
      AddWordScores.new(
        title_word_scores,
        body_word_scores
      ).call
    end

    def title_word_scores
      CalcWordScores.new(
        words: title_search_words,
        weight: 10
      ).call
    end

    def title_search_words
      TextToSearchWords.new(text: article.title).call
    end

    def body_word_scores
      CalcWordScores.new(
        words: body_search_words,
        weight: 1
      ).call
    end

    def body_search_words
      TextToSearchWords.new(text: article.body).call
    end
  end
end
