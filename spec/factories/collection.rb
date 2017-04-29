FactoryGirl.define do
  factory :collection do
    sequence(:name) { |n| "TEST COLLECTION NAME #{n}" }
    description "TEST COLLECTION DESCRIPTION"

    user
  end
end
