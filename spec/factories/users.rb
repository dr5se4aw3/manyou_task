FactoryBot.define do
  factory :user do
    name{ 'sample_name' }
    email{ 'sample_mail@sample.com' }
    password{ 'sample' }
    #password: sample
  #  $2a$10$APrzTDa9KkKlYqL8ZVTDg.m1D7AzYXPv8mXfdfw9fJVXwbQPmTTQe
    admin{ false }
  end
end
