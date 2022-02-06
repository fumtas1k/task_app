require 'rails_helper'
RSpec.describe :Session, type: :system do
  let!(:first_user) { FactoryBot.create(:user, name: "最初のユーザー", email: "example01@diver.com", password: "password", password_confirmation: "password") }
  describe "ログイン機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: first_user_email
      fill_in "session_password", with: first_user_password
      click_on I18n.t("sessions.new.title")
    end
    context "正しいメールアドレスとパスワードでログインしようとした場合" do
      let(:first_user_email) { first_user.email }
      let(:first_user_password) { first_user.password }
      it "マイページにメッセージが表示される" do
        expect(current_path).to eq user_path(first_user)
        within ".alert" do
          expect(page).to have_content I18n.t("sessions.create.message")
        end
      end
    end
    context "不正な入力でログインしようとした場合" do
      let(:first_user_email) { first_user.email }
      let(:first_user_password) { "  " }
      it "ログインページでメッセージが表示される" do
        expect(page).to have_content I18n.t("sessions.new.title")
        within ".alert" do
          expect(page).to have_content I18n.t("sessions.create.caution")
        end
      end
    end
    context "ログインせずにタスク一覧を表示しようとした場合" do
      let(:first_user_email) { first_user.email }
      let(:first_user_password) { "  " }
      it "ログインページが表示される" do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content I18n.t("sessions.new.title")
      end
    end
  end
  describe "ログアウト機能" do

    before do
      visit new_session_path
      fill_in "session_email", with: first_user.email
      fill_in "session_password", with: first_user.password
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