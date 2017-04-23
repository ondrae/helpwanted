FactoryGirl.define do
  sequence(:name) { |n| "TEST-PROJECT#{n}" }

  factory :collection do
    name "TEST COLLECTION NAME"
    description "TEST COLLECTION DESCRIPTION"

    user
  end
end
