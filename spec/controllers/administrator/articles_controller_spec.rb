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

  describe 'update' do
    let(:title) { @article.title }
    let(:body) { @article.body }
    subject do
      patch :update, params: { id: @article, article: { author_id: Author.first.id, body: body, published: @article.published, title: title } }
    end

    it 'should update article' do
      subject
      expect(response).to redirect_to(article_path(assigns(:article)))
    end

    context 'when the title has changed' do
      let(:title) { 'something new!' }

      it 'should queue a job to update the article word scores' do
        expect { subject }.to have_enqueued_job(UpdateArticleWordScoresJob)
      end
    end

    context 'when the body has changed' do
      let(:body) { 'something new!' }

      it 'should queue a job to update the article word scores' do
        expect { subject }.to have_enqueued_job(UpdateArticleWordScoresJob)
      end
    end

    context 'when neither the title nor body has changed' do
      it 'should not queue a job to update the article word scores' do
        expect { subject }.not_to have_enqueued_job(UpdateArticleWordScoresJob)
      end
    end
  end

  it 'should destroy article' do
    expect do
      delete :destroy, params: { id: @article }
    end.to change { Article.count }.by(-1)

    expect(response).to redirect_to(administrator_articles_path)
  end
end
