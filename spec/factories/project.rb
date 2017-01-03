FactoryGirl.define do
  factory :project do |p|
    p.sequence(:name) { |n| "TEST PROJECT NAME #{n}" }
    p.description "TEST DESCRIPTION"
    p.url "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT"
    p.owner_login "FAKEGITHUBORG"
    p.owner_avatar_url "https://github.com/fakeavatar_url"
    p.collection
  end
end
