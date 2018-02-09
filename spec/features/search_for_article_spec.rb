require 'rails_helper'

describe 'article search', :type => :feature do
  context "when there articles" do
    before do
      FactoryGirl.create :article, body: "This article is irrelvant"
      FactoryGirl.create :article, :unpublished, body: "Dox Loves Doctors"
      FactoryGirl.create :article, body: "Dox Loves Rails"
    end

    it 'shows only published matches' do
      visit "/"
      within ".search" do
        fill_in "query", with: "Dox"
        click_button "search"
      end

      expect(page.all(".article").count).to eq 1
      expect(page.find(".article").text).to include "Dox Loves Rails"
    end
  end
end
