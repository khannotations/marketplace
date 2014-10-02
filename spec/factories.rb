FactoryGirl.define do
  factory :user do
    first_name "Stan"
    last_name "E"
    sequence(:netid) { |n| "netid#{n}" }
    sequence(:email) { |n| "first.last#{n}@yale.edu" }
    is_admin false
  end

  factory :opening do
    name "Opening"
    description "This is a description"
    pay_amount 20
    pay_type "hourly"
    timeframe "term"
  end

  factory :skill do
    sequence(:name) { |n| "skill#{n}" }
  end
end