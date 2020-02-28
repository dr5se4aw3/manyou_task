# 万葉課題
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
