module Engblog
  # Given some text,
  # parse the text into search words.
  # In this context "Search Words" are best described in the following example:
  # Given Text: "In my opinion, Dox should stick with Rails!"
  # Search Words: %w(in my opinion dox should stick with rails)
  # Specifically, we're stripping punctuation and downcasing each word.
  # As time goes on we can pipeline in more parsing and sanitizing of text as
  # needed.
  class TextToSearchWords
    def initialize(text:)
      @text = text
      @search_words = []
    end

    def call
      split_on_whitespace
      strip_non_alpha
      remove_blank_string
      search_words
    end

    private

    attr_reader :text
    attr_accessor :search_words

    def split_on_whitespace
      self.search_words = text.split(" ")
    end

    def strip_non_alpha
      search_words.each do |search_word|
        search_word.gsub!(/[^a-z]/, '')
      end
    end

    def remove_blank_string
      search_words.delete_if do |search_word|
        search_word == ""
      end
    end
  end
end
