require 'rails_helper'

describe ArticleSearchesController do
  describe 'GET show' do
    context 'when an article exists' do
      let!(:article) do
        FactoryGirl.create(:article)
      end
      before do
        Engblog::UpdateArticleWordScores.new(article: article).call
      end

      context 'when no query is provided' do
        it 'redirects to homepage' do
          get :show
          expect(response).to redirect_to("/")
        end
      end

      context 'when query is provided' do
        subject { get :show, params: { query: 'Rails' } }

        context 'when a matching article exists' do
          let!(:rails_article) { FactoryGirl.create(:article, title: 'Rails') }
          before do
            Engblog::UpdateArticleWordScores.new(article: rails_article).call
          end

          it 'constrains the articles assigned to only matches' do
            subject
            expect(response.status).to eq(200)
            expect(assigns(:articles)).to eq [rails_article]
          end
        end

        context 'when a matching unpublished article exists' do
          before do
            unpublished_article = FactoryGirl.create(
              :article,
              :unpublished,
              title: 'Rails'
            )
            Engblog::UpdateArticleWordScores.new(article: unpublished_article).call
          end

          it 'is ignored' do
            subject
            expect(response.status).to eq(200)
            expect(assigns(:articles)).to eq []
          end
        end
      end
    end
  end
end
