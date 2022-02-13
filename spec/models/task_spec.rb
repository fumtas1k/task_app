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
    let!(:label01) { FactoryBot.create(:label, name: "ラベル01")}
    let!(:label02) { FactoryBot.create(:label, name: "ラベル02")}
    let!(:task) { FactoryBot.create(:task, name: "タスク", status: Task.statuses.keys[0], labels:[label01], user: author ) }
    let!(:task02) { FactoryBot.create(:task, name: "サンプル", status: Task.statuses.keys[0], labels: [label02], user: author) }
    let!(:task03) { FactoryBot.create(:task, name: "サンプル", status: Task.statuses.keys[1], labels: [label01], user: author ) }
    let!(:task04) { FactoryBot.create(:task, name: "テストタスク", status: Task.statuses.keys[1], labels:[label02], user: author ) }
    let(:task_search) { Task.search(name, status_num, label)}
    context "scopeメソッドでタイトルのあいまい検索をした場合" do
      let(:name) { task.name }
      let(:status_num) { nil }
      let(:label) { nil }
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(task_search).to include(task)
        expect(task_search).to_not include(task02)
        expect(task_search.count).to eq 2
      end
    end
    context "scopeメソッドでステータス検索をした場合" do
      let(:name) { nil }
      let(:status_num) { task03.status }
      let(:label) { nil }
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(task_search).to include(task03)
        expect(task_search).to_not include(task02)
        expect(task_search.count).to eq 2
      end
    end
    context "scopeメソッドでラベル検索をした場合" do
      let(:name) { nil }
      let(:status_num) { nil }
      let(:label) { task02.labels[0] }
      it "ラベルに完全一致するタスクが絞り込まれる" do
        expect(task_search).to include(task02)
        expect(task_search).to_not include(task)
        expect(task_search.count).to eq 2
      end
    end
    context "scopeメソッドでタイトルのあいまい検索とステータス検索をした場合" do
      let(:name) { task02.name }
      let(:status_num) { task02.status }
      let(:label) { nil }
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(task_search).to include(task02)
        expect(task_search).to_not include(task03)
        expect(task_search.count).to eq 1
      end
    end
    context "scopeメソッドでタイトルのあいまい検索とラベル検索をした場合" do
      let(:name) { task03.name }
      let(:status_num) { nil }
      let(:label) { task03.labels[0] }
      it "検索キーワードをタイトルに含み、かつラベルに完全一致するタスク絞り込まれる" do
        expect(task_search).to include(task03)
        expect(task_search).to_not include(task)
        expect(task_search.count).to eq 1
      end
    end
    context "scopeメソッドでステータスとラベル検索をした場合" do
      let(:name) { nil }
      let(:status_num) { task.status }
      let(:label) { task.labels[0] }
      it "ステータスとラベルに完全一致するタスク絞り込まれる" do
        expect(task_search).to include(task)
        expect(task_search).to_not include(task02)
        expect(task_search.count).to eq 1
      end
    end
    context "scopeメソッドでステータスとラベル検索をした場合" do
      let(:name) { task.name }
      let(:status_num) { task.status }
      let(:label) { task.labels[0] }
      it "検索キーワードをタイトルに含み、かつステータスとラベルに完全一致するタスク絞り込まれる" do
        expect(task_search).to include(task)
        expect(task_search).to_not include(task02)
        expect(task_search.count).to eq 1
      end
    end
  end
end