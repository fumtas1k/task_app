require 'rails_helper'
describe 'タスクモデル機能', type: :model do
  let!(:author) { FactoryBot.create(:user) }
  describe 'バリデーションのテスト' do
    let(:task) { FactoryBot.build(:task) }
    shared_examples "バリデーションに引っかかる" do
      it { expect(task).not_to be_valid }
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it "バリデーションが通る" do
        expect(task).to be_valid
      end
    end
    context 'タスクの名前が空の場合' do
      before { task.name = "" }
      it_behaves_like "バリデーションに引っかかる"
    end
    context 'タスクの詳細が空の場合' do
      before { task.description = "" }
      it_behaves_like "バリデーションに引っかかる"
    end
    context 'タスクの期限が空の場合' do
      before { task.expired_at = nil }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "タスクの名前が31文字の場合" do
      before { task.name = "a" * 31 }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "ユーザーが空の場合" do
      before { task.user = nil }
      it_behaves_like "バリデーションに引っかかる"
    end
  end

  describe "検索機能" do
    let!(:author) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, name: "task", status: Task.statuses.keys[0], user: author ) }
    let!(:second_task) { FactoryBot.create(:task, name: "sample", status: Task.statuses.keys[0], user: author) }
    let!(:third_task) { FactoryBot.create(:task, name: "sample", status: Task.statuses.keys[1], user: author ) }
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
      let(:status_num) { third_task.status }
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(task_search).to include(third_task)
        expect(task_search).to_not include(second_task)
        expect(task_search.count).to eq 1
      end
    end
    context "scopeメソッドでタイトルのあいまい検索とステータス検索をした場合" do
      let(:name) { second_task.name }
      let(:status_num) { second_task.status }
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(task_search).to include(second_task)
        expect(task_search).to_not include(third_task)
        expect(task_search.count).to eq 1
      end
    end
  end
end