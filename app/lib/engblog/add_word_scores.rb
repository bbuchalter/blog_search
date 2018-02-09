module Engblog
  # Given two or more word score data structures,
  # "add" them together such that scores accumulate
  # and the final structure has all words.
  class AddWordScores
    def initialize(*word_scores)
      @word_scores = word_scores
      @added_scores = Hash.new(0)
    end

    def call
      word_scores.each do |word_score|
        word_score.each do |word, score|
          added_scores[word] += score
        end
      end
      added_scores
    end

    private

    attr_reader :word_scores
    attr_accessor :added_scores
  end
end
