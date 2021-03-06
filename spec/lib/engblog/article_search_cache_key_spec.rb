require 'rails_helper'

RSpec.describe Engblog::ArticleSearchCacheKey do
  def subject
    described_class.new(
      page: page,
      query: query,
      per_page: per_page
    ).call
  end

  context 'when requesting 1 result per page' do
    let(:per_page) { 1 }

    context 'when requesting the first page of results' do
      let(:page) { 1 }

      context "when query is 'search cache'" do
        let(:query) { 'search cache' }

        context "when two relevant word scores exist" do
          before do
            FactoryGirl.create :word_score, word: 'search'
            FactoryGirl.create :word_score, word: 'cache'
          end

          context "when a relevant record is mutated" do
            it "DOES NOT change the cache key" do
              expect {
                sleep 1
                WordScore.find_by(word: 'search').update!(score: 32)
              }.to_not change {
                subject
              }
            end
          end

          context "when a relevant record is added" do
            it "changes the cache key" do
              expect {
                FactoryGirl.create :word_score, word: 'cache'
              }.to change {
                subject
              }
            end
          end

          context "when a relevant record is removed" do
            it "changes the cache key" do
              expect {
                WordScore.where(word: 'search').destroy_all
              }.to change {
                subject
              }
            end
          end

          context "when the query changes" do
            before { @query = query }
            it "changes the cache key" do
              expect { @query = 'something new' }.to change {
                described_class.new(
                  page: page,
                  query: @query,
                  per_page: per_page
                ).call
              }
            end
          end

          context "when a new page of results are requested" do
            before { @page = page }
            it "changes the cache key" do
              expect { @page = 2 }.to change {
                described_class.new(
                  page: @page,
                  query: query,
                  per_page: per_page
                ).call
              }
            end
          end

          context "when a number of results per page are requested" do
            before { @per_page = per_page }
            it "changes the cache key" do
              expect { @per_page = 2 }.to change {
                described_class.new(
                  page: page,
                  query: query,
                  per_page: @per_page
                ).call
              }
            end
          end
        end
      end
    end
  end
end
