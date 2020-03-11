FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "task#{n}"}
    sequence(:email) { |n| "sample_mail#{n}@sample.com"}
    password{ 'sample' }
    #password: sample
  #  $2a$10$APrzTDa9KkKlYqL8ZVTDg.m1D7AzYXPv8mXfdfw9fJVXwbQPmTTQe

    admin{ false }
  end
end
