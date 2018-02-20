require 'spec_helper'
require_relative '../../../app/lib/engblog/text_to_search_words'

RSpec.describe Engblog::TextToSearchWords do
  subject { described_class.new(text: text).call }

  context "when text is 'ruby loves rails'" do
    let(:text) { 'ruby loves rails' }

    it "splits on whitespace" do
      expect(subject).to eq %w(ruby loves rails)
    end
  end

  context "when text is 'ruby, my1 friend!'" do
    let(:text) { 'ruby, my1 friend!' }

    it "strips non-alpha characters from words" do
      expect(subject).to eq %w(ruby my friend)
    end
  end

  context "when text is 'ruby,  my 1 friend!'" do
    let(:text) { 'ruby,  my 1 friend!' }

    it "only returns words" do
      expect(subject).to eq %w(ruby my friend)
    end
  end

  context "when text is 'RubY" do
    let(:text) { 'RubY' }

    it "downcases" do
      expect(subject).to eq %w(ruby)
    end
  end
end
