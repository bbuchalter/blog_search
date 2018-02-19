require 'rails_helper'

RSpec.describe Engblog::CachedArticleSearch do
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

                describe "#pagination" do
                  subject do
                    described_class.new(
                      query: query,
                      page: page,
                      per_page: per_page
                    ).pagination
                  end


                  it "responds to page, per_page, current_page, total_pages" do
                    expect(subject).to have_attributes(
                      page: 1,
                      current_page: 1,
                      per_page: 1,
                      total_pages: 2
                    )
                  end

                  it "records the search's page count" do
                    expect { subject }.to change {
                      CachedArticleSearchPageCount.count
                    }.from(0).to(1)
                  end

                  context "when it is called again with the same query and page" do
                    before do
                      described_class.new(
                        query: query,
                        page: page,
                        per_page: per_page
                      ).pagination
                    end

                    it "returns the same results" do
                      expect(subject).to have_attributes(
                        page: 1,
                        current_page: 1,
                        per_page: 1,
                        total_pages: 2
                      )
                    end

                    it "does not records any new page counts" do
                      expect { subject }.to_not change {
                        CachedArticleSearchPageCount.count
                      }.from(1)
                    end
                  end
                end

                describe "#results" do
                  subject do
                    described_class.new(
                      query: query,
                      page: page,
                      per_page: per_page
                    ).results
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
