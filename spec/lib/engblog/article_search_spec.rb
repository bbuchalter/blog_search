require 'rails_helper'

describe Engblog::ArticleSearch do
  subject do
    Article.all.each do |article|
      Engblog::UpdateArticleWordScores.new(article: article).call
    end
    described_class.new(query: query).call
  end

  context "when searching 'dox'" do
    let(:query) { 'dox' }

    context "when many articles exist" do
      before { 2.times { FactoryGirl.create(:article) } }

      context "when an article exists with the title 'Dox is the next big thing'" do
        let!(:dox_in_title_article) do
          FactoryGirl.create(
            :article,
            title: 'Dox is the next big thing'
          )
        end

        it "returns the matching article and the article's word score" do
          expect(
            subject.map do |article|
              { article.id => article["sum_score"] }
            end
          ).to eq [dox_in_title_article.id => 10]
        end

        context "when an article exists with the body 'Dox' 200 times" do
          let!(:dox_in_body_article) do
            FactoryGirl.create(
              :article,
              body: 'Dox '* 200
            )
          end

          it "returns matching articles, in the right order" do
            expect(
              subject.map do |article|
                { article.id => article["sum_score"] }
              end
            ).to eq([
                { dox_in_body_article.id => 200 },
                { dox_in_title_article.id => 10 }
            ])
          end
        end
      end
    end
  end
end
