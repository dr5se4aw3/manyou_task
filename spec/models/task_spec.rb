require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '入力が空白の場合' do
    it 'titleが空ならバリデーションが通らない' do
      task = FactoryBot.build(:task, title:'')
      expect(task).not_to be_valid
    end
    it 'detailが空ならバリデーションが通らない' do
      # ここに内容を記載する
      task = FactoryBot.build(:task, detail:'')
      expect(task).not_to be_valid
    end
    it "deadlineが空ならバリデーションが通らない" do
      task = FactoryBot.build(:task, deadline:'')
    expect(task).not_to be_valid
    end
    it "priorityが空ならバリデーションが通らない" do
      task = FactoryBot.build(:task, priority:'')
    expect(task).not_to be_valid
    end
    it 'titleとcontentに内容が記載されていればバリデーションが通る' do
      # ここに内容を記載する
      task = FactoryBot.build(:task)
      expect(task).to be_valid
    end
  end
  context '入力が文字数制限を上回る場合' do
    it "titleが文字数を制限を上回るならバリデーションが通らない" do
      title_31character = ''
      (0...31).each do
        title_31character << 'a'
      end
      task = Task.new(title: title_31character, detail: '失敗テスト')
      expect(task).not_to be_valid
    end
    it "detailが文字数を制限を上回るならバリデーションが通らない" do
      detail_256character = ''
      (0...256).each do
        detail_256character << 'a'
      end
      task = Task.new(title: '失敗テスト', detail: detail_256character)
      expect(task).not_to be_valid
    end
    it "titleとdetailの文字数が制限以下ならバリデーションが通る" do
      title_31character = ''
      (0...30).each do
        title_31character << 'a'
      end
      detail_256character = ''
      (0...255).each do
        detail_256character << 'a'
      end
      task = Task.new(title: title_31character, detail: detail_256character)
      expect(task).to be_valid
    end
  end

  describe 'scopeの挙動確認' do
    before do
      @taskA1 = FactoryBot.create(:task, title:'aaaa', status: '未着手')
      @taskA2 = FactoryBot.create(:task, title:'aaaa', status: '着手中')
      @taskB1 = FactoryBot.create(:task, title:'BBBB', status: '未着手')
      @taskB2 = FactoryBot.create(:task, title:'BBBB', status: '着手中')
    end
    it "titleとstatusによる絞り込み検索が通る" do
      task = Task.search_with_title_status('aaaa', '未着手')
      #task = Task.search_with_title('aaaa').search_with_status('未着手')
      expect(task).to include(@taskA1)
    end
    it "titleによる絞り込み検索が通る" do
      task = Task.search_with_title("BBBB")
      expect(task).to include(@taskB1)
      expect(task).to include(@taskB2)
    end
    it "titleとstatusによる絞り込み検索が通る" do
      task = Task.search_with_status("未着手")
      expect(task).to include(@taskA1)
      expect(task).to include(@taskB1)
    end
  end
end
