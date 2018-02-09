class Administrator::ArticlesController < Administrator::BaseController
  before_action :load_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.order("id desc").
      paginate(page: params[:page], per_page: 20)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(permitted_params)

    if @article.save
      UpdateArticleWordScoresJob.perform_later(article: @article)
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
    @article.assign_attributes(permitted_params)
    trigger_word_score_job = Engblog::ShouldUpdateArticleWordScores.new(
      article: @article
    ).call

    if @article.save
      if trigger_word_score_job
        UpdateArticleWordScoresJob.perform_later(article: @article)
      end

      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to administrator_articles_url, notice: 'Article was successfully destroyed.'
  end

  private

  def permitted_params
    params.require(:article).
      permit(:title, :subtitle, :body, :published, :author_id, :hero_image_name, :featured)
  end
end
