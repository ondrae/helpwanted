FactoryGirl.define do
  factory :github_project do
    skip_create

    url "https://github.com/ondrae/allgiteverything"
    name "TEST NAME"
    description "TEST DESCRIPTION"
    owner_login "TEST_GITHUB_ACCOUNT"
    owner_html_url "https://github.com/TEST_GITHUB_ACCOUNT"
    owner_avatar_url "https://avatars2.githubusercontent.com/u/595778"

    [issue]

    initialize_with do
      new(url)
    end

  end
end
