require 'rails_helper'
describe 'タスクモデル機能', type: :model do
  let(:expired_at) { 3.days.after }
  describe 'バリデーションのテスト' do
    context 'タスクの名前が空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(name: '', description: '失敗テスト', expired_at: expired_at )
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(name: "失敗テスト", description: "", expired_at: expired_at)
        expect(task).not_to be_valid
      end
    end
    context 'タスクの期限が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(name: "失敗テスト", description: "失敗テスト", expired_at: nil)
        expect(task).not_to be_valid
      end
    end
    context "タスクの名前が31文字の場合" do
      it "バリデーションにひっかかる" do
        task = Task.new(name: "a" * 31, description: "失敗テスト", expired_at: expired_at)
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(name: "成功テスト", description: "成功テスト", expired_at: expired_at)
        expect(task).to be_valid
      end
    end
  end

  describe "検索機能" do
    let!(:task) { FactoryBot.create(:task, name: "task", status: Task.statuses.keys[0]) }
    let!(:second_task) { FactoryBot.create(:task, name: "sample", status: Task.statuses.keys[0]) }
    let!(:third_task) { FactoryBot.create(:task, name: "sample", status: Task.statuses.keys[1])}
    let(:task_search) { Task.search(name, status_num)}
    context "scopeメソッドでタイトルのあいまい検索をした場合" do
      let(:name) { task.name }
      let(:status_num) { nil }
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(task_search).to include(task)
        expect(task_search).to_not include(second_task)
        expect(task_search.count).to eq 1
      end
    end
    context "scopeメソッドでステータス検索をした場合" do
      let(:name) { nil }
      let(:status_num) { Task.statuses[third_task.status] }
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(task_search).to include(third_task)
        expect(task_search).to_not include(second_task)
        expect(task_search.count).to eq 1
      end
    end
    context "scopeメソッドでタイトルのあいまい検索とステータス検索をした場合" do
      let(:name) { second_task.name }
      let(:status_num) { Task.statuses[second_task.status] }
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(task_search).to include(second_task)
        expect(task_search).to_not include(third_task)
        expect(task_search.count).to eq 1
      end
    end
  end
end