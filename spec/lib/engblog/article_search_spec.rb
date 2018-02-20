require 'rails_helper'

describe Engblog::ArticleSearch do
  subject do
    Article.all.each do |article|
      Engblog::UpdateArticleWordScores.new(article: article).call
    end
    described_class.new(query: query).call
  end

  context "when searching 'ruby'" do
    let(:query) { 'ruby' }

    context "when many articles exist" do
      before { 2.times { FactoryGirl.create(:article) } }

      context "when an old article exists with the title 'Ruby is the next big thing'" do
        let!(:ruby_in_title_article) do
          FactoryGirl.create(
            :article,
            title: 'Ruby is the next big thing',
            created_at: 1.year.ago
          )
        end

        context "when a new article exists with the body 'Ruby is great'" do
          let!(:ruby_in_body_article) do
            FactoryGirl.create(
              :article,
              body: 'Ruby is great',
            )
          end

          it "returns the matching article and the article's word score" do
            expect(
              subject.map do |article|
                { article.id => article["sum_score"] }
              end
            ).to eq [
              { ruby_in_title_article.id => 10 },
              { ruby_in_body_article.id => 1 }
            ]
          end

          context "when an article exists with the body 'Ruby' 200 times" do
            let!(:ruby_in_body_article) do
              FactoryGirl.create(
                :article,
                body: 'Ruby '* 200
              )
            end

            it "returns matching articles, in the right order" do
              expect(
                subject.map do |article|
                  { article.id => article["sum_score"] }
                end
              ).to eq([
                  { ruby_in_body_article.id => 200 },
                  { ruby_in_title_article.id => 10 }
              ])
            end
          end
        end
      end
    end
  end
end
