require 'rails_helper'

RSpec.describe Engblog::UpdateArticleWordScores do
  let(:article) { FactoryGirl.create(:article) }
  subject { described_class.new(article: article).call }

  context "when an article has a title of 'doctors loves dox'" do
    let(:article) do
      FactoryGirl.create(:article, title: title, body: body)
    end
    let(:title) { 'doctors loves dox' }

    context "with a body of 'dox loves rails'" do
      let(:body) { 'dox loves rails' }

      it "creates a word score for each word" do
        expect { subject }.to change {
          WordScore.order(:word).pluck(:word, :score)
        }.from([]).to(
          [
            ["doctors", 10],
            ["dox", 11],
            ["loves", 11],
            ["rails", 1],
          ]
        )
      end

      context "when the article already had some word scores" do
        before do
          FactoryGirl.create(:word_score, article: article, word: 'deleted')
        end

        it "deletes the old scores before creating new ones" do
          expect { subject }.to change {
            WordScore.order(:word).pluck(:word)
          }.from(['deleted']).to(%w(doctors dox loves rails))
        end
      end
    end
  end
end
