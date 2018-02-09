require 'rails_helper'

describe Engblog::ArticleSearch do
  subject { described_class.new(query: query).call }

  context "when searching 'dox'" do
    let(:query) { 'dox' }

    context "when many articles exist" do
      before { 2.times { FactoryGirl.create(:article) } }

      context "when an article exists with the title 'Dox is the next big thing'" do
        let!(:article) do
          FactoryGirl.create(
            :article,
            title: 'Dox is the next big thing'
          )
        end

        it "returns the ID of that article" do
          expect(subject).to include(article.id)
        end
      end

      context "when an article exists with the body 'Dox is the next big thing'" do
        let!(:article) do
          FactoryGirl.create(
            :article,
            body: 'Dox is the next big thing'
          )
        end

        it "returns the ID of that article" do
          expect(subject).to include(article.id)
        end
      end
    end
  end
end