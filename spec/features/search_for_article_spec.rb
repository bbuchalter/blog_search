require 'rails_helper'

describe 'article search', :type => :feature do
  context "when there articles" do
    before do
      # Should not appear
      FactoryGirl.create :article, body: "This article is irrelvant" # because no match
      FactoryGirl.create :article, :unpublished, body: "Dox Loves Doctors" # because unpublished

      # Should appear
      6.times{ FactoryGirl.create :article, body: "Dox Loves Rails" }

      # Update Word Scores for search
      Article.all.each do |article|
        Engblog::UpdateArticleWordScores.new(article: article).call
      end
    end

    it 'shows only published matches on all pages' do
      search_for "Dox"

      expect(page.all(".article").count).to eq 5
      expect(page).not_to have_text "irrelevant"
      expect(page).not_to have_text "unpublished"

      find(".next_page").click

      expect(page.all(".article").count).to eq 1
      expect(page).not_to have_text "irrelevant"
      expect(page).not_to have_text "unpublished"
    end

    it 'retains your search query' do
      search_for "Dox"
      expect(page.find("#query").value).to eq "Dox"
    end

    def search_for(query)
      visit "/"
      within ".search" do
        fill_in "query", with: query
        click_button "search"
      end
    end
  end
end
