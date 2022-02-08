require 'rails_helper'
RSpec.describe :user, type: :system do
  let!(:login_user) { FactoryBot.create(:user, name: "ログインユーザー", email: "example01@diver.com", password: "password", password_confirmation: "password") }
  describe "Sign up機能" do
    before do
      visit new_user_path
      fill_in "user_name", with: user_new.name
      fill_in "user_email", with: user_new.email
      fill_in "user_password", with: user_new.password
      fill_in "user_password_confirmation", with: user_new.password_confirmation
      click_on I18n.t("helpers.submit.create")
    end
    context "全て入力してsignupした場合" do
      let!(:user_new) { FactoryBot.build(:user) }
      it "新規登録できる" do
        expect(current_path).to eq user_path(User.last)
        expect(page).to have_content user_new.email
      end
    end
    context "パスワード関連を空白にしてsignupしようとした場合" do
      let!(:user_new) { FactoryBot.build(:user, password: "") }
      it "入力フォームでエラーメッセージが表示される" do
        expect(page).to have_content I18n.t("users.new.title")
        within "#error_explanation" do
          expect(page).to have_content I18n.t("users.password")
        end
      end
    end
    context "signup(login)した状態でsignupページにアクセスした場合" do
      let!(:user_new) { FactoryBot.build(:user) }
      it "root_pathにリダイレクトされる" do
        visit new_user_path
        expect(current_path).to eq root_path
        expect(page).to have_content I18n.t("tasks.index.title")
      end
    end
  end
  describe "プロフィール機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: login_user.email
      fill_in "session_password", with: login_user.password
      click_on I18n.t("sessions.new.btn")
    end
    context "マイページに遷移した場合" do
      it "マイページが表示される" do
        visit user_path(login_user)
        expect(page).to have_content login_user.email
      end
    end
  end
end