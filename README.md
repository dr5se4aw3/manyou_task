# 万葉課題
- 着手

## ステップ１ CRUD機能 + テスト（フィーチャスペック）
- Rubyは2.6.5をインストールしましょう。
- RubyのバージョンはGemfileに記載しましょう。
- Railsはバージョン5.2.3をインストールしましょう。
- PostgreSQLは最新バージョンをインストールしましょう。
- GitHubのリポジトリを作成しましょう。
- GitHubのリポジトリにプルリクエストをあげた状態で提出しましょう。
- プロジェクトのディレクトリの直下に docs というディレクトリを作成しましょう。
- 最下記の文書ファイルをdocsフォルダに入れましょう。
- ER図を作成して、docsフォルダに入れましょう。
- README.mdファイルのデフォルトの記述を消去して、markdown記法でテーブルとカラム、データ型をそれぞれ記載しましょう。
- データベースはPostgreSQLを使用しましょう。
- タスクの一覧画面、作成画面、詳細画面、編集画面、削除機能を作成しましょう。
- 作成、更新、削除後はそれぞれflashメッセージを画面に表示させましょう。
- routes.rb を編集して、http://localhost:3000/ でタスクの一覧画面が表示されるようにしましょう。
- spec/spec_helper.rb 、 spec/rails_helper.rb を用意しましょう。
- 現状のタスク機能に対して system spec で E2Eテスト を書きましょう。
- 「タスク一覧画面に遷移したら、作成済みのタスクが表示される」ことのテストを成功させましょう。
- 「タスク登録画面で、必要項目を入力してcreateボタンを押したらデータが保存される」ことのテストを成功させましょう。
- 「任意のタスク詳細画面に遷移したら、該当タスクの内容が表示されたページに遷移する」ことのテストを成功させましょう。
- デバック・Rspec関係のgem以外のgemは追加していないこと


## モデル
### Userテーブル
| column name | data |
| --- | --- |
| id | integer |
| name | string |
| email | string |
| password | string |

### Taskテーブル
| column name | data |
| --- | --- |
| id | integer |
| title | string |
| detail | text |
| deadline | string |
| priority | string |
| status | string |
| user_id | integer |

### Labelテーブル
| column name | data |
| --- | --- |
| id | integer |
| title | string |
| task_id | integer |
