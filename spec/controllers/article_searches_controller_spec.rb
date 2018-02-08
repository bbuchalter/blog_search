require 'rails_helper'

describe ArticleSearchesController do
  describe 'POST create' do
    context 'when an article exists' do
      let!(:article) do
        FactoryGirl.create(:article)
      end

      it 'is successful' do
        post :create
        expect(response.status).to eq(200)
        expect(assigns(:articles)).to eq [article]
      end
    end
  end
end
