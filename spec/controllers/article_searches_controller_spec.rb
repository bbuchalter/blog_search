require 'rails_helper'

describe ArticleSearchesController do
  describe 'POST create' do
    context 'when an article exists' do
      let!(:article) do
        FactoryGirl.create(:article)
      end
      before do
        Engblog::UpdateArticleWordScores.new(article: article).call
      end

      context 'when no query is provided' do
        it 'redirects to homepage' do
          post :create
          expect(response).to redirect_to("/")
        end
      end

      context 'when query is provided' do
        subject { post :create, params: { query: 'Dox' } }

        context 'when a matching article exists' do
          let!(:dox_article) { FactoryGirl.create(:article, title: 'Dox') }
          before do
            Engblog::UpdateArticleWordScores.new(article: dox_article).call
          end

          it 'constrains the articles assigned to only matches' do
            subject
            expect(response.status).to eq(200)
            expect(assigns(:articles)).to eq [dox_article]
          end
        end

        context 'when a matching unpublished article exists' do
          before do
            unpublished_article = FactoryGirl.create(
              :article,
              :unpublished,
              title: 'Dox'
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
