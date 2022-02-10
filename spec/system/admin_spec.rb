require 'rails_helper'
RSpec.describe :admin, type: :system do
  let!(:admin) { FactoryBot.create(:user, name: "管理ユーザー", email: "admin@diver.com", password: "password", password_confirmation: "password", admin: true) }
  let!(:other) { FactoryBot.create(:user, name: "一般のユーザー", email: "other@diver.com", password: "password", password_confirmation: "password", admin: false)}
  describe "ユーザー管理機能" do
    context "管理ユーザーが管理画面に遷移した場合" do
      before do
        visit new_session_path
        fill_in "session_email", with: admin.email
        fill_in "session_password", with: admin.password
        click_on I18n.t("sessions.new.btn")
      end
      it "ユーザー一覧が表示される" do
        visit admin_users_path
        expect(page).to have_content admin.email
        expect(page).to have_content other.email
      end
    end
    context "一般ユーザーが管理画面に遷移した場合" do
      before do
        visit new_session_path
        fill_in "session_email", with: other.email
        fill_in "session_password", with: other.password
        click_on I18n.t("sessions.new.btn")
      end
      it "管理画面にアクセスできずタスク一覧にリダイレクトする" do
        visit admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content I18n.t("admin.users.admin_required.caution")
        expect(page).to have_content I18n.t("tasks.index.title")
      end
    end
  end

  describe "ユーザー新規登録機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: admin.email
      fill_in "session_password", with: admin.password
      click_on I18n.t("sessions.new.btn")
    end
    context "ユーザー新規登録した場合" do
      let(:new_email) { "new@dive.com"}
      before do
        visit new_admin_user_path
        fill_in "user_name", with: "新規ユーザー"
        fill_in "user_email", with: new_email
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_on I18n.t("helpers.submit.create")
      end
      it "管理画面にリダイレクト追加されたユーザーが確認できる" do
        expect(current_path).to eq admin_users_path
        expect(page).to have_content new_email
      end
    end
  end

  describe "管理ユーザーの詳細画面表示権限" do
    context "管理ユーザーが他のユーザーの詳細画面に遷移した場合" do
      before do
        visit new_session_path
        fill_in "session_email", with: admin.email
        fill_in "session_password", with: admin.password
        click_on I18n.t("sessions.new.btn")
      end
      it "アクセスできる" do
        visit user_path(other)
        expect(current_path).to eq user_path(other)
        expect(page).to have_content other.email
      end
    end
  end

  describe "管理ユーザーのユーザー編集機能" do
    let(:edit_user) { FactoryBot.create(:user, name: before_name, email: "edit@diver.com", password: "password", password_confirmation: "password", admin: false) }
    before do
      visit new_session_path
      fill_in "session_email", with: admin.email
      fill_in "session_password", with: admin.password
      click_on I18n.t("sessions.new.btn")
    end
    context "一般ユーザーの名前を変更した場合" do
      let(:before_name) { "編集用ユーザー" }
      let(:after_name) { "樋口一葉" }
      before do
        visit edit_admin_user_path(edit_user)
        fill_in "user_name", with: after_name
        click_on I18n.t("helpers.submit.update")
      end
      it "管理画面にリダイレクトし、更新した旨が表示される" do
        expect(current_path).to eq admin_users_path
        expect(page).to have_content I18n.t("admin.users.update.message")
      end
      it "以前の名前は表示されない" do
        expect(page).not_to have_content before_name
      end
      it "変更後の名前が表示される" do
        expect(page).to have_content after_name, count: 2
      end
    end
    context "1人しかいない管理ユーザーのadminをfalseにしようとした場合" do
      before do
        visit edit_admin_user_path(admin)
        uncheck ""
        click_on I18n.t("helpers.submit.update")
      end
      it "変更できず、ユーザー編集画面のままメッセージが表示される" do
        expect(page).to have_content I18n.t("admin.users.edit.title")
        expect(page).to have_content I18n.t("admin.users.update.caution")
        admin.reload
        expect(admin.admin).to eq true
      end
    end
  end

  describe "ユーザー削除機能" do
    before do
      visit new_session_path
      fill_in "session_email", with: admin.email
      fill_in "session_password", with: admin.password
      click_on I18n.t("sessions.new.btn")
    end
    context "非管理ユーザーの削除ボタンを押した場合" do
      it "ユーザーが削除されメッセージが表示される" do
        visit admin_users_path
        expect {
          page.accept_confirm do
            all("tbody tr").last.click_on I18n.t("admin.users.destroy.btn")
          end
          expect(page).to have_content I18n.t("admin.users.destroy.message")
          expect(current_path).not_to have_content other.email
        }.to change { User.count }.by(-1)
      end
    end
    context "1人しかいない管理ユーザーの削除ボタンを押した場合" do
      it "ユーザーは削除されずメッセージが表示される" do
        visit admin_users_path
        expect {
          page.accept_confirm do
            all("tbody tr").first.click_on I18n.t("admin.users.destroy.btn")
          end
          expect(page).to have_content I18n.t("admin.users.destroy.caution")
          expect(page).to have_content admin.email
        }.to change { User.count }.by(0)
      end
    end
  end

  describe "ラベル管理機能" do
    let(:before_name) { "らべるビフォア" }
    let(:after_name) { "らべるアフター"}
    before do
      visit new_session_path
      fill_in "session_email", with: admin.email
      fill_in "session_password", with: admin.password
      click_on I18n.t("sessions.new.btn")
    end
    context "ラベル新規作成画面で新規作成した場合" do
      before do
        visit new_admin_label_path
        fill_in "label_name", with: before_name
        click_on I18n.t("helpers.submit.create")
      end
      it "ラベル管理画面にリダイレクトし登録したラベルが表示される" do
        expect(current_path).to eq admin_labels_path
        expect(page).to have_content before_name
      end
    end
    context "ラベル編集画面で編集した場合" do
      before do
        FactoryBot.create(:label, name: before_name)
        visit admin_labels_path
        click_on before_name
        fill_in "label_name", with: after_name
        click_on I18n.t("helpers.submit.update")
      end
      it "ラベル管理画面にリダイレクトし、変更したラベル名が表示される" do
        expect(current_path).to eq admin_labels_path
        expect(page).not_to have_content before_name
        expect(page).to have_content after_name
      end
    end
    context "ラベル管理画面で削除ボタンを押した場合" do
      before do
        FactoryBot.create(:label, name: before_name)
        visit admin_labels_path
      end
      it "ラベルが削除され数がラベル総数が一つ減る" do
        expect{
          page.accept_confirm do
            find(".delete").click
          end
          expect(page).to have_content I18n.t("admin.labels.destroy.message")
          expect(page).not_to have_content before_name
        }.to change{ Label.count }.by(-1)
      end
    end
  end
end