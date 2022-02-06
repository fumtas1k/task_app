require 'rails_helper'
RSpec.describe User, type: :system do
  let!(:first_user) { FactoryBot.create(:user, name: "最初のユーザー", email: "example01@diver.com", password: "password", password_confirmation: "password") }
  describe "Sign up機能" do
    before do
      visit users_path
      visit new_user_path
      fill_in "user_name", with: user_new.name
      fill_in "user_email", with: user_new.email
      fill_in "user_password", with: user_new.password
      fill_in "user_password_confirmation", with: user_new.password_confirmation
      click_on I18n.t("helpers.submit.create")
    end

    context "全て入力してsignupした場合" do
      let!(:user_new) { FactoryBot.build(:user) }
      it "登録したプロフィール画面のurlにリダイレクトする" do
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

  describe "ユーザー一覧機能" do
    context "ユーザー一覧画面に遷移した場合" do
      before do
        visit new_session_path
        fill_in "session_email", with: first_user.email
        fill_in "session_password", with: first_user.password
        click_on I18n.t("sessions.new.btn")
      end
      it "登録済みのユーザー一覧が表示される" do
        visit users_path
        expect(page).to have_content first_user.email, count: 1
      end
    end
  end

  describe "プロフィール機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: first_user.email
      fill_in "session_password", with: first_user.password
      click_on I18n.t("sessions.new.btn")
    end
    context "任意のユーザー画面に遷移した場合" do
      it "該当のユーザーメールアドレスが表示される" do
        visit user_path(first_user)
        expect(page).to have_content first_user.email
      end
    end
  end

  describe "ユーザー編集機能" do
    let(:edit_user) { FactoryBot.create(:user, name: before_name) }
    before do
      visit new_session_path
      fill_in "session_email", with: edit_user.email
      fill_in "session_password", with: edit_user.password
      click_on I18n.t("sessions.new.btn")
    end
    context "ユーザーの名前を変更した場合" do
      let(:before_name) { "新渡戸稲造" }
      let(:after_name) { "樋口一葉" }
      before do
        visit edit_user_path(edit_user)
        fill_in "user_name", with: after_name
        click_on I18n.t("helpers.submit.update")
      end
      it "プロフィール画面にリダイレクトし、更新した旨が表示される" do
        expect(current_path).to eq user_path(edit_user)
        expect(page).to have_content I18n.t("users.update.message")
      end
      it "以前の名前は表示されない" do
        expect(page).not_to have_content before_name
      end
      it "変更後の名前が表示される" do
        expect(page).to have_content after_name
      end
    end
  end

  describe "ユーザー退会機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: first_user.email
      fill_in "session_password", with: first_user.password
      click_on I18n.t("sessions.new.btn")
    end
    context "ユーザー退会ボタンを押した場合" do
      it "ユーザーが削除されSign Upページにリダイレクトしメッセージが表示される" do
        visit user_path(first_user)
        expect {
          page.accept_confirm do
            click_on I18n.t("users.destroy.btn")
          end
          expect(page).to have_content I18n.t("users.destroy.message")
          expect(current_path).to eq new_user_path
        }.to change { User.count }.by(-1)
      end
    end
  end
end