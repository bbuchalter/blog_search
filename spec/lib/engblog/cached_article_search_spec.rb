require 'rails_helper'

RSpec.describe Engblog::CachedArticleSearch do
  describe "#results" do
    subject do
      described_class.new(
        query: query,
        page: page,
        per_page: per_page
      ).results
    end

    context "given a query 'dox'" do
      let(:query) { 'dox' }

      context "given an article with the title 'dox'" do
        let!(:title_match_article) { FactoryGirl.create :article, title: 'dox' }

        context "given an article with the body 'dox'" do
          let!(:body_match_article) { FactoryGirl.create :article, body: 'dox' }

          context "given those articles have been WordScored" do

            context "given we ask for the first page of results" do
              let(:page) { 1 }

              context "given we ask for one article per page" do
                let(:per_page) { 1 }

                context "given the articles word scores are calculated" do
                  before do
                    Article.all.each do |article|
                      Engblog::UpdateArticleWordScores.new(article: article).call
                    end
                  end

                  it "returns the articles for that page" do
                    expect(subject).to eq([title_match_article])
                  end

                  it "records the search results for that page" do
                    expect { subject }.to change {
                      CachedArticleSearchScore.count
                    }.from(0).to(1)
                  end

                  context "when it is called again with the same query and page" do
                    before do
                      described_class.new(
                        query: query,
                        page: page,
                        per_page: per_page
                      ).results
                    end

                    it "returns the same results" do
                      expect(subject).to eq([title_match_article])
                    end

                    it "does not records any new results" do
                      expect { subject }.to_not change {
                        CachedArticleSearchScore.count
                      }.from(1)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
