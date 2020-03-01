# 万葉課題
## Herokuアップロード手順
1. Heroku公式サイトにアクセスし、ユーザー登録を行う。ユーザー登録時、言語をRubyに設定する。
2. 自身の端末にHerokuをインストールする。（Mac環境：コンソール上で、`brew tap heroku/brew && brew install heroku`を実行）
3. コンソールにて、Herokuへデプロイしたいアプリケーションのルートディレクトリにカレントディレクトリを移動させる。
4. `heroku login`コマンドを実行しHerokuへログインする。
5. `heroku create`コマンドを実行しHeroku上にアプリケーションを作成する。この際に"https://XXXXX.herokuapp.com/"というURLが表示される。このXXXXXの部分に当たる記述がアプリケーション名となる。
5. `git remote -v` コマンドを実行し、herokuアプリのアドレスが登録されていることを確認する。
6. `rails assets:precompile RAILS_ENV=production`コマンドでアセットプリコンパイルを実行し、本番環境用のアセットファイルを作成する。
7. 以上の手順を踏み、アプリケーションの変更をコミットし、Heroku環境へpushを行なう。
8. データベースの作成自体はHeroku上で自動的に行われるが、データベースを使用する場合は`heroku run rails db:migrate`コマンドでマイグレーションを実行する。


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
