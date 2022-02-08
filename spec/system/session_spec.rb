require 'rails_helper'
RSpec.describe :Session, type: :system do
  let!(:login_user) { FactoryBot.create(:user, name: "ログインユーザー", email: "example01@diver.com", password: "password", password_confirmation: "password") }
  let!(:other_user) { FactoryBot.create(:user, name: "他のユーザー", email: "other@diver.com", password: "password")}

  describe "ログイン機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: login_user_email
      fill_in "session_password", with: login_user_password
      click_on I18n.t("sessions.new.title")
    end
    context "正しいメールアドレスとパスワードでログインしようとした場合" do
      let(:login_user_email) { login_user.email }
      let(:login_user_password) { login_user.password }
      it "マイページにメッセージが表示される" do
        expect(current_path).to eq user_path(login_user)
        within ".alert" do
          expect(page).to have_content I18n.t("sessions.create.message")
        end
      end
    end
    context "不正な入力でログインしようとした場合" do
      let(:login_user_email) { login_user.email }
      let(:login_user_password) { "  " }
      it "ログインページでメッセージが表示される" do
        expect(page).to have_content I18n.t("sessions.new.title")
        within ".alert" do
          expect(page).to have_content I18n.t("sessions.create.caution")
        end
      end
    end
    context "ログインせずにタスク一覧を表示しようとした場合" do
      let(:login_user_email) { login_user.email }
      let(:login_user_password) { "  " }
      it "ログイン画面に遷移する" do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content I18n.t("sessions.new.title")
      end
    end
    context "他のユーザーのマイページに遷移した場合" do
      let(:login_user_email) { login_user.email }
      let(:login_user_password) { login_user.password }
      it "ログインユーザーのタスク一覧画面が表示される" do
        visit user_path(other_user)
        expect(current_path).to eq tasks_path
        expect(page).to have_content I18n.t("tasks.index.title")
      end
    end
    context "ログインした状態でログイン画面にアクセスしようとした場合" do
      let(:login_user_email) { login_user.email }
      let(:login_user_password) { login_user.password }
      it "root_pathにリダイレクトする" do
        visit new_session_path
        expect(current_path).to eq root_path
        expect(page).to have_content I18n.t("tasks.index.title")
      end
    end
  end

  describe "ログアウト機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: login_user.email
      fill_in "session_password", with: login_user.password
      click_on I18n.t("sessions.new.title")
    end
    context "ログアウトボタンを押した場合" do
      it "ログインページにメッセージが表示される" do
        find("header nav .dropdown-toggle").click
        click_on I18n.t("sessions.destroy.title")
        expect(current_path).to eq new_session_path
        within ".alert" do
          expect(page).to have_content I18n.t("sessions.destroy.message")
        end
      end
    end
  end
end