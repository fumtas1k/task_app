require 'rails_helper'
describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクの名前が空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(name: '', description: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(name: "失敗テスト", description: "")
        expect(task).not_to be_valid
      end
    end
    context "タスクの名前が31文字の場合" do
      it "バリデーションにひっかかる" do
        task = Task.new(name: "a" * 31, description: "失敗テスト")
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(name: "成功テスト", description: "成功テスト")
        expect(task).to be_valid
      end
    end
  end
end