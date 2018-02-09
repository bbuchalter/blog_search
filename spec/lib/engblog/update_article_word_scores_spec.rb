require 'rails_helper'

RSpec.describe Engblog::UpdateArticleWordScores do
  let(:article) { FactoryGirl.create(:article) }
  subject { described_class.new(article: article).call }

  context "when an article already has a word score" do
    let!(:existing_word_score) do
      FactoryGirl.create(:word_score, article: article)
    end

    it "is deleted" do
      expect { subject }.to change {
        WordScore.count
      }.from(1).to(0)
    end
  end
end
