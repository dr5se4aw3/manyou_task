# 万葉課題
## Herokuアップロード手順
1. heroku create”を実施、Herokuアドレスを取得。
2. “rails assets:precompile RAILS_ENV=production”を実施。
3. 変更をコミットした後、Herokuへpushする。

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
