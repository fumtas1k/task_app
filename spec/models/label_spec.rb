require 'rails_helper'

RSpec.describe Label, type: :model do
  describe "バリデーション" do
    let!(:label0) {FactoryBot.create(:label, name: "ラベル0")}
    let(:label) {FactoryBot.build(:label, name: "ラベル")}

    context "重複なく名前を設定した場合" do
      it "バリデーションが通る" do
        expect(label).to be_valid
      end
    end
    context "名前が空白の場合" do
      it "バリデーションに引っかかる" do
        label.name = ""
        expect(label).not_to be_valid
      end
    end
    context "名前が11文字以上の場合" do
      it "バリデーションに引っかかる" do
        label.name = "a" * 11
        expect(label).not_to be_valid
      end
    end
    context "名前が重複した場合" do
      it "バリデーションに引っかかる" do
        label.name = label0.name
        expect(label).not_to be_valid
      end
    end
  end
end
