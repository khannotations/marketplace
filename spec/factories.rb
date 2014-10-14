FactoryGirl.define do
  factory :user do
    first_name "Stan"
    last_name "E"
    sequence(:netid) { |n| "netid#{n}" }
    sequence(:email) { |n| "first.last#{n}@yale.edu" }
    is_admin false
  end

  factory :opening do
    sequence(:name) { |n| "opening#{n}" }
    description "This is the opening description"
    pay_amount 20
    pay_type "hourly"
    timeframe "term"
    association :project
  end

  factory :project do
    sequence(:name) { |n| "project#{n}" }
    description "This is the project description"
  end

  factory :skill do
    sequence(:name) { |n| "skill#{n}" }
  end
end
