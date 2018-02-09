require 'rails_helper'

describe ArticleSearchesController do
  describe 'POST create' do
    context 'when an article exists' do
      let!(:article) do
        FactoryGirl.create(:article)
      end

      it 'is assigns the articles successfully' do
        post :create
        expect(response.status).to eq(200)
        expect(assigns(:articles)).to eq [article]
      end

      context 'when query is provided' do
        let(:query) { 'Dox' }
        context 'when a matching article exists' do
          let!(:dox_article) { FactoryGirl.create(:article, title: 'Dox') }

          it 'constrains the articles assigned to only matches' do
            post :create, params: { query: 'Dox' }
            expect(response.status).to eq(200)
            expect(assigns(:articles)).to eq [dox_article]
          end
        end
      end

      context 'when an unpublished article exists' do
        before { FactoryGirl.create(:article, :unpublished) }

        it 'is ignored' do
          post :create
          expect(response.status).to eq(200)
          expect(assigns(:articles)).to eq [article]
        end
      end
    end
  end
end
