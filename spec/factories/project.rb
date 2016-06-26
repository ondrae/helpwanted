FactoryGirl.define do
  factory :project do
    name "TEST NAME"
    description "TEST DESCRIPTION"
    url "https://api.github.com/repos/TEST_GITHUB_ACCOUNT/TEST_PROJECT"
    collection
  end
end
