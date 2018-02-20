require 'spec_helper'
require_relative '../../../app/lib/engblog/add_word_scores'

RSpec.describe Engblog::AddWordScores do
  context "when given a word score of { 'ruby' => 1, 'first' => 10 }" do
    let(:first) { { 'ruby' => 1, 'first' => 10} }

    context "when also given a word score of { 'ruby' => 2, 'second' => 20 }" do
      let(:second) { { 'ruby' => 2, 'second' => 20 } }

      subject do
        described_class.new(first, second).call
      end

      it "adds the scores together" do
        expect(subject).to eq(
          {
            'ruby' => 3,
            'first' => 10,
            'second' => 20
          }
        )
      end
    end
  end
end
