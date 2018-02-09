require 'spec_helper'
require_relative '../../../app/lib/engblog/text_to_search_words'

RSpec.describe Engblog::TextToSearchWords do
  subject { described_class.new(text: text).call }

  context "when text is 'dox loves rails'" do
    let(:text) { 'dox loves rails' }

    it "splits on whitespace" do
      expect(subject).to eq %w(dox loves rails)
    end
  end

  context "when text is 'dox, my1 friend!'" do
    let(:text) { 'dox, my1 friend!' }

    it "strips non-alpha characters from words" do
      expect(subject).to eq %w(dox my friend)
    end
  end

  context "when text is 'dox,  my 1 friend!'" do
    let(:text) { 'dox,  my 1 friend!' }

    it "only returns words" do
      expect(subject).to eq %w(dox my friend)
    end
  end

  context "when text is 'DoX" do
    let(:text) { 'DoX' }

    it "downcases" do
      expect(subject).to eq %w(dox)
    end
  end
end
