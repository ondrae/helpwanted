FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "TEST PROJECT NAME #{n}" }
    description "TEST DESCRIPTION"
    url "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT"
    collection
  end
end
