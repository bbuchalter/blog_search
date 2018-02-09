require 'spec_helper'
require_relative '../../../app/lib/engblog/calc_word_scores'

RSpec.describe Engblog::CalcWordScores do
  subject { described_class.new(words: words, weight: weight).call }

  context "when words are %w(dox loves doctors doctors love dox why not)" do
    let(:words) { %w(dox loves doctors doctors love dox why not) }

    context "and the weight is 2" do
      let(:weight) { 2 }

      it "scores each word by multiplying its number of occurances by the weight" do
        expect(subject).to eq(
          {
            "dox" => 4,
            "loves" => 2,
            "doctors" => 4,
            "love" => 2,
            "why" => 2,
            "not" => 2
          }
        )
      end
    end
  end
end
