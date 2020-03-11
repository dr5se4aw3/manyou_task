FactoryBot.define do
  factory :task do
    title { '架空案件１−１' }
    detail { '要件定義終えること' }
    deadline { '2020-06-01' }
    status { '未着手' }
    priority { '低' }
    association :user
  end
end
