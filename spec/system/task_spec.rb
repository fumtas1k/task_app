require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:task01) { FactoryBot.create(:task, name: "1つ目のタスク", description: "1番目の仕事") }
  describe '新規作成機能' do
    before do
      visit new_task_path
      fill_in "task_name", with: task_name
      fill_in "task_description", with: task_description
      click_on I18n.t("helpers.submit.create")
    end
    context 'タスクを新規作成した場合' do
      let(:task_name) { "2つ目のタスク" }
      let(:task_description) { "2番目の仕事" }
      it "詳細画面のurlにリダイレクトする" do
        expect(current_path).to eq task_path(Task.last)
      end
      it '作成したタスクが表示される' do
        # alertでもtask_nameが表示されるため合計2つ
        expect(page).to have_content "2つ目のタスク", count:2
      end
    end
    context "タスク名、タスク詳細を空白文字にしてタスクを新規作成した場合" do
      let(:task_name) { " " }
      let(:task_description) { " " }
      it "新規作成画面が表示される" do
        expect(page).to have_content I18n.t("tasks.new.title")
      end
      it "エラーメッセージが表示される" do
        # エラーカウントは2
        within "#error_explanation" do
          expect(page).to have_content "2"
        end
      end
    end
  end
  describe '一覧表示機能' do
    before do
      2.times do
        FactoryBot.create(:task)
        sleep(1)
      end
      @task03 = FactoryBot.create(:task, name: "3つ目のタスク", description: "3番目の仕事")
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content @task03.name
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        expect(all("tbody tr").first).to have_content @task03.name
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit task_path(task01)
        expect(page).to have_content task01.name
        expect(page).to have_content task01.description
      end
    end
  end
  describe "編集機能" do
    before do
      visit edit_task_path(task01)
      fill_in "task_name", with: "修正のタスク"
      fill_in "task_description", with: "修正の仕事"
      click_on I18n.t("helpers.submit.update")
    end
    context "タスクを編集した場合" do
      it "詳細画面にリダイレクトする" do
        expect(current_path).to eq task_path(task01)
      end
      it "元の情報は表示されない" do
        expect(page).to_not have_content "1つ目のタスク"
        expect(page).to_not have_content "1番目の仕事"
      end
      it "変更が反映される" do
        expect(page).to have_content "修正のタスク", count: 2
        expect(page).to have_content "修正の仕事"
      end
    end
  end
  describe "削除機能" do
    context "一覧画面でタスクを削除した場合" do
      it "削除しましたと表示され、taskの数が1つ減る" do
        visit tasks_path
        expect {
          page.accept_confirm do
            click_link(I18n.t("tasks.delete.title"), href: task_path(task01))
          end
          expect(page).to have_content "#{task01.name} #{I18n.t("tasks.delete.message")}"
        }.to change { Task.count }.by(-1)
      end
    end
  end
end