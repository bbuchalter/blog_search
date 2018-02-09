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
end

FactoryGirl.define do
  factory :author do
    name 'McFly'
  end
end

FactoryGirl.define do
  factory :page do
    title 'Default title'
    body 'Default body'
    published true
    association :author
  end
end
