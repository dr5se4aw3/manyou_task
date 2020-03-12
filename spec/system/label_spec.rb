require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  before do
    @admin = FactoryBot.create(:user, name: 'admin01', email: 'admin_mail01@sample.com', admin: true)
    #user_id: 19
    @user = FactoryBot.create(:user, name: 'sample01', email: 'sample_mail01@sample.com')
    #user_id: 20

    @label1 = FactoryBot.create(:label, title: "ラベルテスト1-1")
    @label2 = FactoryBot.create(:label, title: "ラベルテスト1-2")
    @label3 = FactoryBot.create(:label, title: "ラベルテスト1-3")
  end
  describe 'ラベル作成画面' do
    context '一般ユーザーでログイン' do
      it 'ラベル作成機能にアクセスできないこと' do
        visit new_session_path
        fill_in :Email, with: 'sample_mail01@sample.com'
        fill_in :Password, with: 'sample'
        click_on 'ログイン'
        visit new_admin_label_path
        expect(page).to have_content '権限が無い'
      end
    end
    context '管理ユーザーでログイン' do
      it "ラベル作成が可能なこと" do
        visit new_session_path
        fill_in :Email, with: 'admin_mail01@sample.com'
        fill_in :Password, with: 'sample'
        click_on 'ログイン'
        visit new_admin_label_path
        fill_in Label.human_attribute_name(:title), with: '細川さん担当'
        click_button '登録する'
        expect(page).to have_content '細川さん担当'
      end
    end
  end
  describe 'タスク登録画面' do
    before do
      visit new_session_path
      fill_in :Email, with: 'sample_mail01@sample.com'
      fill_in :Password, with: 'sample'
      click_on 'ログイン'
    end
    context 'タスク登録' do
      it "タスク登録時に既存のラベルを選択し、作成タスクに紐づけることができること" do
        visit new_task_path
        fill_in Task.human_attribute_name(:title), with: '架空案件１−１'
        fill_in Task.human_attribute_name(:detail), with: '要件定義を終えること'
        fill_in Task.human_attribute_name(:deadline), with: "2020\t0601"
        select '未着手', from: Task.human_attribute_name(:status)
        select '低', from: Task.human_attribute_name(:priority)
        check "task_label_ids_#{@label1.id}"
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content 'ラベルテスト1-1'
      end
      it "タスク詳細画面で関連づけたラベルが一覧で表示されること" do
        visit new_task_path
        fill_in Task.human_attribute_name(:title), with: '架空案件１−１'
        fill_in Task.human_attribute_name(:detail), with: '要件定義を終えること'
        fill_in Task.human_attribute_name(:deadline), with: "2020\t0601"
        select '未着手', from: Task.human_attribute_name(:status)
        select '低', from: Task.human_attribute_name(:priority)
        check "task_label_ids_#{@label1.id}"
        check "task_label_ids_#{@label3.id}"
        click_button '登録する'
        visit tasks_path
        click_link '詳細'
        expect(page).to have_content 'ラベルテスト1-1'
        expect(page).not_to have_content 'ラベルテスト1-2'
        expect(page).to have_content 'ラベルテスト1-3'
      end
    end
  end
  describe 'タスク一覧画面' do
    before do
      visit new_session_path
      fill_in :Email, with: @user.email
      fill_in :Password, with: @user.password
      click_on 'ログイン'
      visit tasks_path
    end
    context 'ラベルによる絞り込み検索' do
      before do

        @task1 = FactoryBot.create(:task, title:'ラベルテスト壱', user: @user)
        @labeled1 = FactoryBot.create(:label_on_task, label:@label1, task:@task1 )
        @task2 = FactoryBot.create(:task, title:'ラベルテスト弐', user: @user)
        @labeled2 = FactoryBot.create(:label_on_task, label:@label2, task:@task2 )
        @task3 = FactoryBot.create(:task, title:'ラベルテスト参', user: @user)
        @labeled3 = FactoryBot.create(:label_on_task, label:@label3, task:@task3 )
      end
      it "ラベルを選択し、そのラベルに紐づけられたタスクを検索できること" do
        visit tasks_path
        select 'ラベルテスト1-1', from: 'ラベル検索'
        click_button '絞り込み検索'
        expect(page).to have_content 'ラベルテスト壱'
        expect(page).not_to have_content 'ラベルテスト弐'
        expect(page).not_to have_content 'ラベルテスト参'
      end
      it "ラベルを選択し、タイトルとステータスも指定して、タスクを検索できること" do

        @task4 = FactoryBot.create(:task, title:'ラベルテスト壱', detail:'検索テスト１',  status: '着手中', user: @user)
        @labeled4 = FactoryBot.create(:label_on_task, label:@label1, task:@task4 )
        @task5 = FactoryBot.create(:task, title:'ラベルテスト壱', detail:'検索テスト２', status: '完了', user: @user)
        @labeled5 = FactoryBot.create(:label_on_task, label:@label2, task:@task5 )
        @task6 = FactoryBot.create(:task, title:'ラベルテスト壱', detail:'検索テスト３', user: @user)
        @labeled6 = FactoryBot.create(:label_on_task, label:@label1, task:@task6 )

        visit tasks_path
        select 'ラベルテスト1-1', from: 'ラベル検索'
        fill_in :title, with: 'ラベルテスト壱'
        select '未着手', from: :status
        click_button '絞り込み検索'
        byebug
        expect(page).to have_content '検索テスト３'
        expect(page).not_to have_content '検索テスト２'
        expect(page).not_to have_content '検索テスト１'
      end
    end
  end
end
