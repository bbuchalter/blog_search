FactoryGirl.define do
  factory :article do
    title 'Default title'
    body 'Default body'
    published true
    association :author

    trait :unpublished do
      published false
    end
  end

  factory :author do
    name 'McFly'
  end

  factory :cached_article_page_count do
    article_search_cache_key "MyString"
    page_count 1
  end
  factory :word_score do
    association :article
    word 'rails'
    score 42
  end

  factory :page do
    title 'Default title'
    body 'Default body'
    published true
    association :author
  end

  factory :cached_article_search_page_count do
    article_search_cache_key "MyString"
    page_count 1
  end
end
