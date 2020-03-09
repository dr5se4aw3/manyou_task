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
end
