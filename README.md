# README

## Table Schema
### User
| key | column | type |
|-----|--------|------|
| PK | id | integer |
| - | name | string |
| - | email | string |
| - | password_digest | string |
### Task
| key | column | type |
|-----|--------|------|
| PK | id | integer |
| FK1 | user_id | integer |
| FK2 | priority_id | integer |
| FK3 | status_id | integer |
| - | name | string |
| - | description | text |
| - | deadline | date |
### Priority
| key | column | type |
|-----|--------|------|
| PK | id | integer |
| - | name | string |
### Status
| key | column | type |
|-----|--------|------|
| PK | id | integer |
| - | name | string |
### Label
| key | column | type |
|-----|--------|------|
| PK | id | integer |
| - | name | string |
### Labeling
| key | column | type |
|-----|--------|------|
| PK | id | integer |
| FK1 | task_id | integer |
| FK2 | label_id | integer |
