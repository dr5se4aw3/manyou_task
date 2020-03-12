FactoryBot.define do
  factory :label_on_task do

    association :task
    association :label
  end
end
