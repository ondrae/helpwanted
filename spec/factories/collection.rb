FactoryGirl.define do
  sequence(:name) { |n| "TEST-PROJECT#{n}" }

  factory :collection do
    name
    description "TEST COLLECTION DESCRIPTION"

    user
  end
end
