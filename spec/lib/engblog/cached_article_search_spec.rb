require 'rails_helper'

RSpec.describe Engblog::CachedArticleSearch do
  context "given a cache key of 'key1'" do
    let(:cache_key) { 'key1' }

    context "and search results for that key" do
      let(:low_score_article) { FactoryGirl.create :article }
      let(:high_score_article) { FactoryGirl.create :article }
      let(:search_results) do
        [
          double('search_result_1', article_id: low_score_article.id, score: 1),
          double('search_result_2', article_id: high_score_article.id, score: 2),
        ]
      end

      context "the first time it is called" do
        let(:subject) do
          described_class.new(
            cache_key: cache_key,
            search_results: search_results
          ).call
        end

        it "records the search results for the key" do
          expect { subject }.to change {
            CachedArticleSearchScore.count
          }.from(0).to(2)
        end

        it "returns the sorted search results" do
          expect(subject).to eq([high_score_article, low_score_article])
        end

        context "the second time it is called" do
          before do
            described_class.new(
              cache_key: cache_key,
              search_results: search_results
            ).call
          end

          it "does not record existing search results" do
            expect { subject }.to_not change {
              CachedArticleSearchScore.count
            }.from(2)
          end

          it "returns the sorted search results" do
            expect(subject).to eq([high_score_article, low_score_article])
          end
        end
      end
    end
  end
end
