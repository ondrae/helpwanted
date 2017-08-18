FactoryGirl.define do
  factory :project do
    sequence(:url) { |n| "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT#{n}" }
    collection
  end
end
