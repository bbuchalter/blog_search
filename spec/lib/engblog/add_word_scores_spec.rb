require 'spec_helper'
require_relative '../../../app/lib/engblog/add_word_scores'

RSpec.describe Engblog::AddWordScores do
  context "when given a word score of { 'dox' => 1, 'first' => 10 }" do
    let(:first) { { 'dox' => 1, 'first' => 10} }

    context "when also given a word score of { 'dox' => 2, 'second' => 20 }" do
      let(:second) { { 'dox' => 2, 'second' => 20 } }

      subject do
        described_class.new(first, second).call
      end

      it "adds the scores together" do
        expect(subject).to eq(
          {
            'dox' => 3,
            'first' => 10,
            'second' => 20
          }
        )
      end
    end
  end
end
