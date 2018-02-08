require 'rails_helper'

RSpec.describe Engblog::ArticleImport do
  context "when given a CSV" do
    subject do
      described_class.new(
        filepath: file_fixture("articles.csv")
      ).call
    end

    it "creates an author" do
      expect { subject }.to change {
        Author.count
      }.from(0).to(1)
    end

    it "creates an author with the provided attributes" do
      expect { subject }.to change {
        Author.first.try!(:attributes).try!(:slice, "name")
      }.from(nil).to(
        {
          "name" => "Author of Article 1"
        }
      )
    end
  end
end
