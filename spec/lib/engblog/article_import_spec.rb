require 'rails_helper'

RSpec.describe Engblog::ArticleImport do
  context "when given a CSV" do
    subject do
      described_class.new(
        file: file_fixture("articles.csv")
      ).call
    end

    it "creates an author" do
      expect { subject }.to change {
        Author.count
      }.from(0).to(1)
    end
  end
end
