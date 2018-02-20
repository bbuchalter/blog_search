module Engblog
  # Given some text,
  # parse the text into search words.
  # In this context "Search Words" are best described in the following example:
  # Given Text: "In my opinion, Ruby should stick with Rails!"
  # Search Words: %w(in my opinion ruby should stick with rails)
  # Specifically, we're stripping punctuation and downcasing each word.
  # As time goes on we can pipeline in more parsing and sanitizing of text as
  # needed.
  class TextToSearchWords
    def initialize(text:)
      @text = text
      @search_words = []
    end

    def call
      text.split(" ").each do |token|
        search_word = token.downcase
        search_word = strip_non_alpha(search_word)
        search_words << search_word unless search_word == ""
      end
      search_words
    end

    private

    attr_reader :text
    attr_accessor :search_words

    def strip_non_alpha(token)
      token.gsub(/[^a-z]/, '')
    end
  end
end
