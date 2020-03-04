FactoryBot.define do
  factory :task do
    title { 'title' }
    detail { 'detail' }
    deadline { '2020-06-01' }
    status { '未着手' }
  end
end
