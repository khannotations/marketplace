FactoryGirl.define do
  factory :user do
    sequence(:netid) { |n| "netid#{n}" }
    sequence(:email) { |n| "first.last#{n}@yale.edu" }
    is_admin false
  end
end