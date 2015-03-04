FactoryGirl.define do
  factory :user do
    first_name "Stan"
    last_name "E"
    sequence(:netid) { |n| "netid#{n}" }
    sequence(:email) { |n| "first.last#{n}@yale.edu" }
    is_admin false
    has_logged_in false
    show_in_results true
  end

  factory :project do
    sequence(:name) { |n| "project#{n}" }
    overview "This is the overview"
    job_description "This is the job description"
    project_description "This is the project description"
    pay_amount 20
    pay_type "hourly"
    timeframe "term"
    expires_on -> { Date.today + 1.month }
    expire_notified false
    approved false
  end

  factory :skill do
    sequence(:name) { |n| "skill#{n}" }
  end

  factory :skill_link do
    association :skillable, factory: :user # Default to user
    association :skill
  end
end
