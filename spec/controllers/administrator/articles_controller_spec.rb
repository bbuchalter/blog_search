require 'rails_helper'

describe Administrator::ArticlesController do
  before(:each) do
    @article = create(:article)
  end

  it 'should get index' do
    get :index
    expect(response.status).to eq 200
    expect(assigns(:articles)).to match_array(@article)
  end

  it 'should get new' do
    get :new
    expect(response.status).to eq 200
  end

  describe 'create' do
    subject do
      post :create, params: { article: { author_id: Author.first.id, body: @article.body, published: @article.published, title: @article.title } }
    end

    it 'should create article' do
      expect { subject }.to change { Article.count }.by(1)
      expect(response).to redirect_to(article_path(assigns(:article)))
    end

    it 'should queue a job to update the article word scores' do
      expect { subject }.to have_enqueued_job(UpdateArticleWordScoresJob)
    end
  end

  it 'should get edit' do
    get :edit, params: { id: @article }
    expect(response.status).to eq 200
  end

  it 'should update article' do
    patch :update, params: { id: @article, article: { author_id: Author.first.id, body: @article.body, published: @article.published, title: @article.title } }

    expect(response).to redirect_to(article_path(assigns(:article)))
  end

  it 'should destroy article' do
    expect do
      delete :destroy, params: { id: @article }
    end.to change { Article.count }.by(-1)

    expect(response).to redirect_to(administrator_articles_path)
  end
end
