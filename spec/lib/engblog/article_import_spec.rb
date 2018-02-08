require 'rails_helper'

RSpec.describe Engblog::ArticleImport do
  context "when given a CSV" do
    subject do
      described_class.new(
        filepath: file_fixture("articles.csv")
      ).call
    end

    it "creates an author for each row in the database" do
      expect { subject }.to change {
        Author.count
      }.from(0).to(2)
    end

    it "creates authors with the provided attributes" do
      expect { subject }.to change {
        Author.pluck(:name)
      }.from([]).to(
        [
          'Author of Article 1',
          'Author of Article 2'
        ]
      )
    end
  end
end
