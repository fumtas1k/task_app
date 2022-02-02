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

# Herokuデプロイ手順

# 前提条件

ローカル環境：Herokuのインストールと紐付けは終わっている。

- ruby 3.0.1
- rails 6.0.3
- bundler 2.2.33
- yarn 1.22.17
- node.js 16.13.1

Heroku環境：rubyとnode.jsのbuildpackがインストールされている。

# 手順

## 1. Herokuに新しいアプリケーションを作成

ターミナルにて、Herokuにログインし、新しいアプリケーションを作成

```ruby
heroku login
heroku create
```

## 2. SSL強制設定

HerokuのSSL証明書に便乗して使用できる（Herokuのサブドメインでのみ有効）

config/enviroments/production.rbファイルでコメントアウトされている以下のコードをアクティブに変更

```ruby
config.force_ssl = true
```

## 3.  画像ファイル、bootstrap等使用する場合は設定

### 3.1. app/assets/images内のファイルを使用する予定の場合は、以下を設定

デフォルトでは、本番環境でimagesファイルは使えない設定のため。

config/enviroment/production.rb ファイルの記述の一部を以下のように変更（falseをtrueにする）

```ruby
config.assets.compile = true
```

### 3.2. bootstrapを使用する場合、以下を設定

config.webpacker.ymlには、extract_cssの設定が記述されており、デフォルトではfalseとなっているが、本番環境ではこれがtrueに設定されている。つまり、このため本番環境でもbootstrapを使用する場合は、以下の記述が必要。

app/views/layouts/application.html.erbのheader部分にstylesheet_pack_tagの記載を追加。

```ruby
<%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```

## 4. メール送信機能を使う場合（sendgrid）

### 4.1. 前提条件

sendgridのアカウントを作成し、api keyも入手している状態

### 4.2. Herokuにsendgridのプラグインを導入

ターミナルにて、以下を実行

```ruby
heroku addons:create sendgrid:starter
```

### 4.3. Heroku上の環境変数にapi keyをセット

ターミナルにて、以下を実行

```ruby
heroku config:set SENDGRID_USERNAME=apikey
heroku config:set SENDGRID_PASSWORD=作成したapi key
```

### 4.4. アプリケーションからapk keyを利用できるよう設定

config/enviroments/production.rbに、以下のコードを追記。

「ここを自分のドメインに変更」と記載された場所は変更すること。

```ruby
Rails.application.configure do
  # 省略

  # 追記
  config.action_mailer.default_url_options = { host: 'ここを自分のドメインに変更.herokuapp.com' }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: "heroku.com",
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }
end
```

## 5. Gemfile.rockを修正

bundleを実行できる環境制限がされており、デプロイ時にエラーとなる。

ターミナルにて、以下を実行

```ruby
bundle lock --add-platform x86_64-linux
```

## 6. アセットプリコンパイル

ターミナルにて、以下を実行

```ruby
rails assets:precompile RAILS_ENV=production
```

## 7. Basic認証設定

### 7.1. controller全体に認証をかける

app/controllers/application_controller.rbに以下を追記

```ruby
class ApplicationController < ActionController::Base
  before_action :basic_auth unless Rails.env.production?

  private
  def basic_auth
		authenticate_or_request_with_http_basic do |name, password|
			name == ENV["BASIC_AUTH_NAME"] && password == ENV["BASIC_AUTH_PASSWORD"]
		end
	end
end
```

### 7.2. ローカル環境でも認証をかけた状態を検証したい場合

- envファイルを準備

アプリケーションのルートディレクトリに.envファイルを作成し、以下を記述（ユーザー名、パスワードは自分で決めて）

```ruby
BASIC_AUTH_NAME = "ユーザー名"
BASIC_AUTH_PASSWORD = "パスワード"
```

.gitignoreファイルに以下を追記

```ruby
.env
```

- dotenv-railsのインストール

Gemfileのtest, developmentに以下を追記しbundle install

```ruby
group :development, :test do

  gem "dotenv-rails"
end
```

ターミナルにて、以下を実行

```ruby
bundle install
```

### 7.3. Herokuに認証をセット

ターミナルにて、以下を実行。

```ruby
heroku config:set BASIC_AUTH_USER=ユーザー名
heroku config:set BASIC_AUTH_PASSWORD=パスワード
```

## 8. 自動でmigrateする設定

アプリケーションのルートディレクトリにProcfile を作成し以下を記述し保存

```ruby
release rails db:migrate
```

## 9. git にコミット

ターミナルにて、以下を実行

```ruby
git add -A
git commit -m "fix:本番環境で動作するよう設定変更"
```

## 10. Herokuにデプロイ

ターミナルにて、以下を実行

```ruby
git push heroku master
heroku run rails db:migrate
```
