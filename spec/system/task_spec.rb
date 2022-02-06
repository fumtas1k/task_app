require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:first_user) { FactoryBot.create(:user, name: "最初のユーザー", email: "example01@diver.com", password: "password", password_confirmation: "password") }
  before do
    visit new_session_path
    fill_in "session_email", with: first_user.email
    fill_in "session_password", with: first_user.password
    click_on I18n.t("sessions.new.btn")
  end
  let!(:task01) { FactoryBot.create(:task, name: "1つ目のタスク", description: "1番目の仕事") }
  describe '新規作成機能' do
    before do
      visit new_task_path
      fill_in "task_name", with: task_name
      fill_in "task_description", with: task_description
      select task_status, from: "task_status"
      select task_priority, from: "task_priority"
      fill_in "task_expired_at", with: task_expired_at
      click_on I18n.t("helpers.submit.create")
    end
    context 'タスクを新規作成した場合' do
      let(:task_name) { "2つ目の@タスク" }
      let(:task_description) { "2番目の仕事" }
      let(:task_expired_at) { 3.days.after }
      let(:task_status) { I18n.t("tasks.status.#{Task.statuses.keys[1]}") }
      let(:task_priority) { I18n.t("tasks.priority.#{Task.priorities.keys[1]}")}
      it "詳細画面のurlにリダイレクトする" do
        expect(current_path).to eq task_path(Task.last)
      end
      it '作成したタスクが表示される' do
        # alertでもtask_nameが表示されるため合計2つ
        expect(page).to have_content "2つ目の@タスク", count: 2
      end
    end
    context "タスク名、タスク詳細を空白文字にしてタスクを新規作成した場合" do
      let(:task_name) { " " }
      let(:task_description) { " " }
      let(:task_status) { I18n.t("tasks.status.#{Task.statuses.keys[1]}") }
      let(:task_priority) { I18n.t("tasks.priority.#{Task.priorities.keys[1]}")}
      let(:task_expired_at) { 3.days.after }
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
    context '一覧画面に遷移した場合' do
      before do
        @task03 = FactoryBot.create(:task, name: "3つ目のタスク", description: "3番目の仕事")
        visit tasks_path
      end
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content @task03.name
      end
    end
    describe "ソート機能" do
      let(:task_priority_low) { Task.priorities.keys[0] }
      let(:task_priority_high) { Task.priorities.keys[-1] }
      let(:task_count) { 5 }
      before do
        # ソートと検索の検証に使用
        task_count.times do |i|
          if i == 1
            # ソート：登録日時ソートの検証に使用
            @task_created_after = FactoryBot.create(:task, created_at: 1.years.after, priority: task_priority_low)
          elsif i == 2
            # ソート：終了期限ソートの検証に使用
            @task_expired_after = FactoryBot.create(:task, expired_at: 1.years.after, priority: task_priority_low)
          elsif i == 3
            @task_priority_high = FactoryBot.create(:task, priority: task_priority_high)
          else
            FactoryBot.create(:task, priority: task_priority_low)
          end
        end
      end
      context 'タスクが作成日時の降順に並んでいる場合' do
        it '新しいタスクが一番上に表示される' do
          visit tasks_path
          expect(all("tbody tr").first).to have_content I18n.l(@task_created_after.created_at, format: :medium)
        end
      end
      context "終了期限ソートリンクをクリックした場合" do
        it "終了期限が最も未来のタスクが一番上に表示される" do
          visit tasks_path
          find("#sort-expired").click_on(I18n.t("tasks.index.sort"))
          sleep(0.1) #遷移が早すぎてdomが読み込まれる前にチェックされてしまうようなので0.1secスリープする
          expect(all("tbody tr").first).to have_content I18n.l(@task_expired_after.expired_at, format: :medium)
        end
      end
      context "優先順位ソートリンクをクリックした場合" do
        it "優先順位が高(high)のタスクが一番上に表示される" do
          visit tasks_path
          find("#sort-priority").click_on(I18n.t("tasks.index.sort"))
          sleep(0.1) #遷移が早すぎてdomが読み込まれる前にチェックされてしまうようなので0.1secスリープする
          expect(all("tbody tr").first).to have_content I18n.t("tasks.priority.#{task_priority_high}")
        end
      end
    end
    describe "検索機能" do
      let(:task_name) { "モブタイトル" }
      let(:test_name) { "テスト" }
      let(:task_status) { Task.statuses.keys[0] }
      let(:test_status) { Task.statuses.keys[-1] }
      let(:task_count) { 5 }
      before do
        task_count.times do |i|
          if i == 1
            # タイトルあいまい検証に使用
            @task_name1 = FactoryBot.create(:task, name: test_name + "タイトル", status: task_status)
          elsif i == 2
            # ステータス一致検証に使用
            @task_expired_after = FactoryBot.create(:task, name: task_name, status: test_status)
          elsif i == 3
            # タイトルあいまい、ステータス一致の検証に使用
            @task_search = FactoryBot.create(:task, name: test_name, status: test_status)
          else
            FactoryBot.create(:task, name: task_name, status: task_status)
          end
        end
        visit tasks_path
        fill_in "task_name", with: search_name
        select search_status, from: "task_status"
        click_on I18n.t("tasks.index.search")
      end
      context "タイトルであいまい検索をした場合" do
        let(:search_name) { test_name }
        let(:search_status) { I18n.t("tasks.status.title") } #blankを選択
        it "検索キーワードを含むタスクで絞り込まれる" do
          expect(all("tbody tr").count).to eq 2
          expect(all("tbody tr").first).to have_content search_name
        end
      end
      context "ステータス検索をした場合" do
        let(:search_name) { "" }
        let(:search_status) { I18n.t("tasks.status.#{test_status}") }
        it "検索ステータスに完全一致するタスクが絞り込まれる" do
          expect(all("tbody tr").count).to eq 2
          expect(all("tbody tr").first).to have_content search_status
        end
      end
      context "タイトルとステータスで検索した場合" do
        let(:search_name) { test_name }
        let(:search_status) { I18n.t("tasks.status.#{test_status}") }
        it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
          expect(all("tbody tr").count).to eq 1
          expect(all("tbody tr").first).to have_content search_name
          expect(all("tbody tr").first).to have_content search_status
        end
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
            click_link(I18n.t("tasks.destroy.title"), href: task_path(task01))
          end
          expect(page).to have_content "#{task01.name} #{I18n.t("tasks.destroy.message")}"
        }.to change { Task.count }.by(-1)
      end
    end
  end
end