class CacheNextSearchResultPageJob < ApplicationJob
  queue_as :default

  def perform(query:, page:, per_page:)
    @page = page

    @search = Engblog::CachedArticleSearch.new(
      query: query,
      page: next_page,
      per_page: per_page
    )

    search.results unless no_more_pages?
  end

  private

  attr_reader :page, :search

  def next_page
    Integer(page) + 1
  end

  def no_more_pages?
    next_page > total_pages
  end

  def total_pages
    search.pagination.total_pages
  end
end
