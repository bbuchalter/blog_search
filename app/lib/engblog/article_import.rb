require 'csv'

module Engblog
  # Given a CSV file,
  # create Articles, HeroImages, and Authors
  # and associate them correctly.
  class ArticleImport
    # @param file [Pathname] The path to the article file.
    def initialize(filepath:)
      @filepath = filepath
    end

    def call
      read_rows do |row|
        Author.create!(
          name: row['author name']
        )
      end
    end

    private

    attr_reader :filepath

    def read_rows
      CSV.foreach(filepath, csv_options) do |row|
        yield row
      end
    end

    def csv_options
      {
        headers: true,
        return_headers: false
      }
    end
  end
end
