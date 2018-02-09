class WordScore < ActiveRecord::Base
  belongs_to :article
  validates :article, :word, :score, presence: true
end
