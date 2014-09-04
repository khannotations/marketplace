FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    netid "xxx"
    email "a@b.com"
    is_admin false
  end
end