FactoryGirl.define do
  factory :project do |p|
    p.sequence(:url) { |n| "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT#{n}" }
    p.collection
  end
end
