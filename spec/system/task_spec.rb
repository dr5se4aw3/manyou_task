require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク一覧画面' do
    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示されること' do
      # テストで使用するためのタスクを作成
      task = FactoryBot.create(:task, title: 'task')
      # タスク一覧ページに遷移
      visit tasks_path
      # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
      # have_contentされているか。（含まれているか。）ということをexpectする（確認・期待する）
      expect(page).to have_content 'task'
      # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
      end
    end
    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいること' do
        # 省略
        task = FactoryBot.create(:task, title: 'task')
        new_task = FactoryBot.create(:task, title: 'new_task')
        visit tasks_path
        task_list = all('.title') # タスク一覧を配列として取得するため、View側でidを振っておく
        expect(task_list[0]).to have_content 'new_task'
        expect(task_list[1]).to have_content 'task'
      end
      it "タスクがdeadlineの降順に並べ替えられること" do
        task = FactoryBot.create(:task, title: 'aaa', deadline: '2020-01-01')
        task = FactoryBot.create(:task, title: 'bbb', deadline: '2020-02-01')
        task = FactoryBot.create(:task, title: 'ccc', deadline: '2020-05-01')
        task = FactoryBot.create(:task, title: 'ddd', deadline: '2020-04-01')
        visit tasks_path
        click_link '終了期限(降順)でソートする'
        task_list = all('.deadline')
        expect(task_list[0]).to have_content '2020-05-01'
        expect(task_list[3]).to have_content '2020-01-01'
      end
    end
    context '優先順位によるソートのリンクを押した場合' do
      it "優先順位の降順でソートされた一覧画面が表示されること" do
        tasks = FactoryBot.create(:task, title:'a_mid', priority: '中')
        tasks = FactoryBot.create(:task, title:'a_low', priority: '低')
        tasks = FactoryBot.create(:task, title:'a_hig', priority: '高')
        visit tasks_path
        click_link '優先順位でソートする'
        task_list = all('.priority')
        expect(task_list[0]).to have_content '高'
        expect(task_list[2]).to have_content '低'
      end
    end
    context 'タスクを6件以上作成した場合' do
      before do
        task = FactoryBot.create(:task, title: 'aaa')
        task = FactoryBot.create(:task, title: 'bbb')
        task = FactoryBot.create(:task, title: 'ccc')
        task = FactoryBot.create(:task, title: 'ddd')
        task = FactoryBot.create(:task, title: 'eee')
        task = FactoryBot.create(:task, title: 'fff')
        visit tasks_path
      end
      it "ページネーションが行われること" do
        expect(page).to have_selector '.current', text: '1'
        expect(page).to have_link '2'
        expect(page).to have_link 'Next'
        expect(page).to have_link 'Last'
      end
      it "５件目までが１ページ目に表示されていること" do
        task_list = all('.title')
        expect(task_list[0]).to have_content 'fff'
        expect(task_list[4]).to have_content 'bbb'
      end
      it "６件目以降が次のページで表示されていること" do
        click_link 'Next'
        expect(page).to have_link 'First'
        expect(page).to have_link 'Previous'
        expect(page).to have_link '1'
        expect(page).to have_selector '.current', text: '2'
        task_list = all('.title')
        expect(task_list[0]).to have_content 'aaa'
      end
    end
  end
  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        # new_task_pathにvisitする（タスク登録ページに遷移する）
        # 1.ここにnew_task_pathにvisitする処理を書く
        visit new_task_path
        # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
        # タスクのタイトルと内容をそれぞれfill_in（入力）する
        # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in Task.human_attribute_name('title'), with: 'bbbb'
        # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
        fill_in Task.human_attribute_name('detail'), with: 'bbbb'
        fill_in Task.human_attribute_name('deadline'), with: '2020-02-01'
        # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
        # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
        click_button '登録する'
        # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
        # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
        # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
        expect(page).to have_content 'bbbb'
      end
    end
  end
  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移すること' do
         task = FactoryBot.create(:task, title: 'aaaatitle')
         visit tasks_path
         click_link '詳細'
         expect(page).to have_content 'aaaatitle'
       end
     end
  end
end
