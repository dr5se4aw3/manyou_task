require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '入力が空白の場合' do
    it 'titleが空ならバリデーションが通らない' do
      task = Task.new(title: '', detail: '失敗テスト')
      expect(task).not_to be_valid
    end
    it 'contentが空ならバリデーションが通らない' do
      # ここに内容を記載する
      task = Task.new(title: '失敗テスト', detail: '')
      expect(task).not_to be_valid
    end
    it 'titleとcontentに内容が記載されていればバリデーションが通る' do
      # ここに内容を記載する
      task = Task.new(title: '成功テスト', detail: '成功テスト')
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
end
