FactoryGirl.define do
  factory :issue do
    title "TEST TITLE"
    url "https://github.com/TEST_GITHUB_ACCOUNT/TEST_PROJECT/issues/1"
    featured false
    github_updated_at Time.current
  end
end
