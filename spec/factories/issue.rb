FactoryGirl.define do
  factory :issue do
    title "TEST TITLE"
    labels ["TEST BUG", "TEST ENHANCEMENT", "TEST HELP WANTED"]
    url "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT/issues/1"
    project
  end
end
