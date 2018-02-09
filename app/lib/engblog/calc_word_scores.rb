module Engblog
  # Given an array of words and weight,
  # Calculate a "score" for each word such that
  # score = weight * count(word)
  class CalcWordScores
    def initialize(words:, weight:)
      @words = words
      @weight = weight
    end

    def call
      words.reduce(Hash.new(0)) do |word_scores, word|
        word_scores[word] += weight
        word_scores
      end
    end

    private

    attr_reader :words, :weight
  end
end
