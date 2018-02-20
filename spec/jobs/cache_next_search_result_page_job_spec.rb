require 'rails_helper'

RSpec.describe CacheNextSearchResultPageJob, type: :job do
  context "when there are 2 pages of results" do
    let(:total_pages) { 2 }

    context "when the last page of results is requested" do
      it "calls CachedArticleSearch for the next page" do
        pagination_double = double('pagination', total_pages: total_pages)
        search_double = double('search', results: nil, pagination: pagination_double)

        allow(Engblog::CachedArticleSearch).to receive(:new)
          .and_return(search_double)

        expect(search_double).to_not receive(:results)

        described_class.perform_now(
          query: 'test',
          page: 2,
          per_page: 5
        )
      end
    end

    context "when the first page of results is requested" do
      it "calls CachedArticleSearch for the next page" do
        pagination_double = double('pagination', total_pages: total_pages)
        search_double = double('search', results: nil, pagination: pagination_double)

        expect(Engblog::CachedArticleSearch).to receive(:new).with(
          query: 'test',
          page: 2,
          per_page: 5
        ).and_return(search_double)

        expect(search_double).to receive(:results)

        described_class.perform_now(
          query: 'test',
          page: 1,
          per_page: 5
        )
      end
    end
  end
end
