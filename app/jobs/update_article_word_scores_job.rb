class UpdateArticleWordScoresJob < ApplicationJob
  queue_as :default

  def perform(article:)
    Engblog::UpdateArticleWordScores.new(article: article).call
  end
end
