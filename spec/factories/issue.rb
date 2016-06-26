FactoryGirl.define do
  factory :issue do
    title "TEST TITLE"
    labels "BUG, ENHANCEMENT, HELP WANTED"
    url "https://api.github.com/repos/TEST_GITHUB_ACCOUNT/TEST_PROJECT"
    project
  end
end
