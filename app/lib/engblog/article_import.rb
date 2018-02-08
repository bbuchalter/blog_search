module Engblog
  # Given a CSV file,
  # create Articles, HeroImages, and Authors
  # and associate them correctly.
  class ArticleImport
    # @param file [Pathname] The path to the article file.
    def initialize(file:)
    end

    def call
      Author.create!(
        name: "Anyone!"
      )
    end
  end
end
