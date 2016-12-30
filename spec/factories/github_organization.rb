FactoryGirl.define do
  factory :github_organization do
    skip_create

    url "https://github.com/mygithuborgname"
    [project]

    initialize_with do
      new(url)
    end

  end
end
