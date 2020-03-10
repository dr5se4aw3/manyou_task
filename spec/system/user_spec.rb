require 'rails_helper'
require 'byebug'

RSpec.describe 'ユーザー・ログイン管理機能', type: :system do
  describe 'ユーザー管理機能' do
    context '必要項目を入力して登録ボタンを押した場合' do
      before do
        visit new_user_path
        fill_in User.human_attribute_name(:name), with: 'sample01'
        fill_in User.human_attribute_name(:email), with: 'sample_mail01@sample.com'
        fill_in User.human_attribute_name(:password), with: 'sample'
        fill_in User.human_attribute_name(:password_confirmation), with: 'sample'
        click_button '登録する'
      end
      it "データが保存され、該当ユーザーの内容が表示されたページに遷移すること" do
        expect(first('#name')).to have_content 'sample01'
        expect(first('#email')).to have_content 'sample_mail01@sample.com'
      end
    end
  end
  describe 'ログイン管理機能' do
    before do
      @user1 = FactoryBot.create(:user, name: 'sample01', email: 'sample_mail01@sample.com')
      #user_id: 1
      @user2 = FactoryBot.create(:user, name: 'sample02', email: 'sample_mail02@sample.com')
      #user_id: 2
    end
    context 'ログインしていない場合' do
      it "ログイン画面で必要情報を入力しログインボタンを押すと、該当ユーザーの内容が表示されたページに遷移すること" do
        visit new_session_path
        fill_in :Email, with: 'sample_mail01@sample.com'
        fill_in :Password, with: 'sample'
        click_button 'ログイン'
        expect(first('#name')).to have_content 'sample01'
        expect(first('#email')).to have_content 'sample_mail01@sample.com'
      end
      it "タスク管理機能にアクセスできないこと" do
        visit tasks_path
        expect(first('#notice')).to have_content 'ログインしてください'
        expect(first('h1')).to have_content 'ログインフォーム'
      end
    end
    context '既にログインをしている場合' do
      before do
        visit new_session_path
        fill_in :Email, with: 'sample_mail01@sample.com'
        fill_in :Password, with: 'sample'
        #user_id
        click_button 'ログイン'
      end
      it "ユーザー登録画面に遷移できないこと" do
        visit new_user_path
        expect(first('#notice')).to have_content '既にログインしています。'
        expect(first('#name')).to have_content 'sample01'
      end
      it "自身以外のユーザーのマイページ（ユーザー情報確認画面）に遷移できないこと" do
        visit user_path(@user2.id)
        expect(first('#notice')).to have_content '他ユーザーの情報は閲覧できません。'
        expect(first('#name')).to have_content 'sample01'
        expect(first('#email')).to have_content 'sample_mail01@sample.com'
      end
      it "自身以外のユーザーのタスクがタスク一覧に表示されないこと" do
        task = FactoryBot.create(:task, title: "user1のタスク", user_id: '10')
        task = FactoryBot.create(:task, title: "user2のタスク", user_id: '11')
        visit tasks_path
        expect(page).not_to have_content 'user2のタスク'
        expect(page).to have_content 'user1のタスク'
      end
      it "ログアウトが可能なこと" do
        click_on 'ログアウト'
        expect(first('#notice')).to have_content 'ろぐあうとしました'
        expect(first('h1')).to have_content 'ログインフォーム'
      end
    end
  end
  describe '管理者機能' do
    before do
      @admin = FactoryBot.create(:user, name: 'admin01', email: 'admin_mail01@sample.com', admin: true)
      #user_id: 19
      @user = FactoryBot.create(:user, name: 'sample01', email: 'sample_mail01@sample.com')
      #user_id: 20
      visit new_session_path
      fill_in :Email, with: 'admin_mail01@sample.com'
      fill_in :Password, with: 'sample'
      click_on 'ログイン'
    end
    context '管理者メニュー' do
      it "管理者としてログインした場合、管理者用メニューが表示されること" do
        expect(page).to have_content '管理者用メニュー'
      end
    end
    context 'ユーザー登録' do
      before do
        visit new_admin_user_path
      end
      it "管理者ユーザーが、一般ユーザーを作成できること" do
        fill_in User.human_attribute_name(:name), with: 'sample02'
        fill_in User.human_attribute_name(:email), with: 'sample_mail02@sample.com'
        fill_in User.human_attribute_name(:password), with: 'sample'
        fill_in User.human_attribute_name(:password_confirmation), with: 'sample'
        select '一般', from: User.human_attribute_name(:admin)
        click_button '登録する'
        sleep 0.3
        properties = all('#sample02')
        expect(properties[3]).to have_content 'sample_mail02@sample.com'
        expect(properties[1]).to have_content 'false'
      end
      it "管理者ユーザーが、管理者ユーザーを作成できること" do
        fill_in User.human_attribute_name(:name), with: 'admin02'
        fill_in User.human_attribute_name(:email), with: 'admin_mail02@sample.com'
        fill_in User.human_attribute_name(:password), with: 'sample'
        fill_in User.human_attribute_name(:password_confirmation), with: 'sample'
        select '管理者', from: User.human_attribute_name(:admin)
        click_button '登録する'
        sleep 0.3
        properties = all('#admin02')
        expect(properties[3]).to have_content 'admin_mail02@sample.com'
        expect(properties[1]).to have_content 'true'
      end
    end
    context 'ユーザー一覧画面' do
      before do
        FactoryBot.create(:task, title: 'admin01のタスク', user_id: @admin.id)
        FactoryBot.create(:task, title: 'admin01のタスク', user_id: @admin.id)
        FactoryBot.create(:task, title: 'sample01のタスク', user_id: @user.id)
        FactoryBot.create(:task, title: 'sample01のタスク', user_id: @user.id)
        FactoryBot.create(:task, title: 'sample01のタスク', user_id: @user.id)
        visit admin_users_path
      end
      it "各ユーザーのタスクの数が表示されていること" do
        properties = all('#admin01')
        expect(properties[4]).to have_content '2'

        properties = all('#sample01')
        expect(properties[4]).to have_content '3'
      end
    end
    context 'ユーザー詳細' do
      before do
        FactoryBot.create(:task, title: 'admin01のタスク第一', user_id: @admin.id)
        FactoryBot.create(:task, title: 'admin01のタスク２つめ', user_id: @admin.id)
        FactoryBot.create(:task, title: 'sample01のタスク０１', user_id: @user.id)
        FactoryBot.create(:task, title: 'sample01のタスクセカンド', user_id: @user.id)
        FactoryBot.create(:task, title: 'sample01のtask drei', user_id: @user.id)
      end
      it "ユーザーに紐づいたタスク一覧が表示されること" do
        visit admin_user_path(@admin.id)
        expect(page).to have_content 'admin01のタスク第一'
        expect(page).to have_content 'admin01のタスク２つめ'

        visit admin_user_path(@user.id)
        expect(page).to have_content 'sample01のタスク０１'
        expect(page).to have_content 'sample01のタスクセカンド'
        expect(page).to have_content 'sample01のtask drei'
      end
    end
    context 'ユーザー削除' do
      before do
        @admin2 = FactoryBot.create(:user, name: 'admin02', email: 'admin_mail02@sample.com', admin: true)
        #user_id: 19
        @user2 = FactoryBot.create(:user, name: 'sample02', email: 'sample_mail02@sample.com')
        #user_id: 20
        visit admin_users_path
      end
      it "一般ユーザーを削除できること" do
        find("#destroy_#{@user2.name}").click
        page.accept_confirm "Are you sure?"
        expect(page).to have_content 'ユーザーの削除が完了しました'
      end
      it "管理者を削除できること" do
        find("#destroy_#{@admin2.name}").click
        page.accept_confirm "Are you sure?"
        expect(page).to have_content 'ユーザーの削除が完了しました'
      end
    end
  end
end
