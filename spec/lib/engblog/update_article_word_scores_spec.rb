require 'rails_helper'

RSpec.describe Engblog::UpdateArticleWordScores do
  let(:article) { FactoryGirl.create(:article) }
  subject { described_class.new(article: article).call }

  context "when an article has a title of 'everybody loves ruby'" do
    let(:article) do
      FactoryGirl.create(:article, title: title, body: body)
    end
    let(:title) { 'everybody loves ruby' }

    context "with a body of 'ruby loves rails'" do
      let(:body) { 'ruby loves rails' }

      it "creates a word score for each word" do
        expect { subject }.to change {
          WordScore.order(:word).pluck(:word, :score)
        }.from([]).to(
          [
            ["everybody", 10],
            ["loves", 11],
            ["rails", 1],
            ["ruby", 11],
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
          }.from(['deleted']).to(%w(everybody loves rails ruby))
        end
      end
    end
  end
end
