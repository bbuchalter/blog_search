class ArticleSearchesController < ApplicationController
  def show
    if params[:query]
      page = params[:page] || 1

      search = Engblog::CachedArticleSearch.new(
        query: params[:query],
        page: page,
        per_page: 5
      )

      @articles = search.results.includes(:author)
      @results_for_pagination = search.pagination
      # OPTIMIZE: async cache warm for next page of results
    else
      redirect_to root_path
    end
  end
end
