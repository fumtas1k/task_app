require 'rails_helper'

RSpec.describe Labeling, type: :model do
  describe "dependent" do
    let!(:label) { FactoryBot.create(:label) }
    let!(:task) { FactoryBot.create(:task) }
    let!(:labeling) { FactoryBot.create(:labeling, task_id: task.id, label_id: label.id)}
    context "ラベルを削除した場合" do
      it "そのラベルに関連するlabelingも削除される" do
        expect{label.destroy}.to change{ Labeling.count }.by(-1)
      end
    end
    context "タスクを削除した場合" do
      it "そのタスクに関連するlabelingも削除される" do
        expect{task.destroy}.to change{ Labeling.count }.by(-1)
      end
    end
  end
end
