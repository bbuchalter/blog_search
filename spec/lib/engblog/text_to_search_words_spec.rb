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
end
