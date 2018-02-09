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
  end
end
