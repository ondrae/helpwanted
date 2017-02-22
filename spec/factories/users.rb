FactoryGirl.define do
  sequence(:email) { |n| "TEST-#{n}@TEST.COM" }

  factory :user do
    email
    github_name "test_github_name"
    image "TEST IMAGE URL"
    password "TEST PASSWORD"
  end
end
