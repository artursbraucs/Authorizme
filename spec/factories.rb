FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "foo#{n}" }
    sequence(:last_name) { |n| "bar#{n}" }
    password "foobar"
    email { "#{first_name}@example.com" }
    role 1
  end
  
  factory :user_provider do
    provider_type "facebook"
    user
  end
end