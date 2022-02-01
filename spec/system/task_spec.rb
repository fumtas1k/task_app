require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    before do
      visit new_task_path
      fill_in "task_name", with: task_name
      fill_in "task_description", with: task_description
      click_on "登録"
    end
    context 'タスクを新規作成した場合' do
      let(:task_name) { "最初のタスク" }
      let(:task_description) { "晩御飯の買い物" }
      it "詳細画面のurlにリダイレクトする" do
        expect(current_path).to eq task_path(Task.last)
      end
      it '作成したタスクが表示される' do
        # alertでもtask_nameが表示されるため合計2つ
        expect(page).to have_content "最初のタスク", count:2
      end
    end
    context "タスク名、タスク詳細を空白文字にしてタスクを新規作成した場合" do
      let(:task_name) { " " }
      let(:task_description) { " " }
      it "新規作成画面が表示される" do
        expect(page).to have_content "新規登録"
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
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        task = FactoryBot.create(:task, name: "2つ目のタスク", description: "晩御飯の買い物")
        visit tasks_path
        expect(page).to have_content "2つ目のタスク"
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, name: "3つ目タスク", description: "晩御飯の買い物")
        visit task_path(task)
        expect(page).to have_content task.name
        expect(page).to have_content task.description
      end
    end
  end
  describe "編集機能" do
    before do
      visit edit_task_path(task)
      fill_in "task_name", with: "修正のタスク"
      fill_in "task_description", with: "朝食の買い物"
      click_on "編集"
    end
    context "タスクを編集した場合" do
      let(:task) {FactoryBot.create(:task, name: "4つ目のタスク", description: "晩御飯の買い物")}
      it "詳細画面にリダイレクトする" do
        expect(current_path).to eq task_path(task)
      end
      it "元の情報は表示されない" do
        expect(page).to_not have_content "4つ目のタスク"
        expect(page).to_not have_content "晩御飯の買い物"
      end
      it "変更が反映される" do
        expect(page).to have_content "修正のタスク", count: 2
        expect(page).to have_content "朝食の買い物"
      end
    end
  end
  describe "削除機能" do
    context "一覧画面でタスクを削除した場合" do
      it "削除しましたと表示され、taskの数が1つ減る" do
        task = FactoryBot.create(:task, name: "5つ目のタスク", description: "晩御飯の買い物")
        visit tasks_path
        expect {
          page.accept_confirm do
            find_link("削除", href: task_path(task)).click
          end
          expect(page).to have_content "5つ目のタスク を削除しました"
        }.to change { Task.count }.by(-1)
      end
    end
  end
end