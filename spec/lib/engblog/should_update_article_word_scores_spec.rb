require 'rails_helper'

RSpec.describe Engblog::ShouldUpdateArticleWordScores do
  let(:article) { FactoryGirl.create(:article) }
  subject { described_class.new(article: article).call }

  context 'when the title has changed' do
    before { article.title = 'something new!' }
    it { is_expected.to be true }
  end

  context 'when the body has changed' do
    before { article.body = 'something new!' }
    it { is_expected.to be true }
  end

  context 'when neither the title nor the body have changed' do
    it { is_expected.to be false }
  end
end
