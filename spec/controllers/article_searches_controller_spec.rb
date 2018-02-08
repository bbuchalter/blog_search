require 'rails_helper'

describe ArticleSearchesController do
  describe 'POST create' do
    it 'is successful' do
      post :create
      expect(response.status).to eq(200)
    end
  end
end
