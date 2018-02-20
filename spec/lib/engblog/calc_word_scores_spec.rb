require 'spec_helper'
require_relative '../../../app/lib/engblog/calc_word_scores'

RSpec.describe Engblog::CalcWordScores do
  subject { described_class.new(words: words, weight: weight).call }

  context "when words are %w(ruby loves rails rails love ruby why not)" do
    let(:words) { %w(ruby loves rails rails love ruby why not) }

    context "and the weight is 2" do
      let(:weight) { 2 }

      it "scores each word by multiplying its number of occurances by the weight" do
        expect(subject).to eq(
          {
            "ruby" => 4,
            "loves" => 2,
            "rails" => 4,
            "love" => 2,
            "why" => 2,
            "not" => 2
          }
        )
      end
    end
  end
end
