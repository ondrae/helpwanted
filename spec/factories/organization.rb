FactoryGirl.define do
  factory :organization do
    sequence(:url) { |n| "https://github.com/TEST_GITHUB_ACCOUNT#{n}" }
    collection
  end
end
