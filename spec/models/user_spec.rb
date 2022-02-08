require 'rails_helper'
RSpec.describe User, type: :model do
  describe "バリデーションのテスト" do
    let(:user_val) { FactoryBot.build(:user) }
    shared_examples "バリデーションに引っかかる" do
      it {expect(user_val).to_not eq be_valid}
    end

    context "全て入力した場合" do
      it "バリデーションが通る" do
        expect(user_val).to be_valid
      end
    end
    context "userの名前が空の場合" do
      before { user_val.name = "" }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userの名前が31文字の場合" do
      before { user_val.name = "a" * 31 }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userのemailが空の場合" do
      before { user_val.email = "" }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userのemailが256文字の場合" do
      before { user_val.email = "a@" + ("a" * 250) + ".com" }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userのemailが不正の場合" do
      @invalid_emails = ["example.diver.com", "example@diver", "example@1diver.com"]
      @invalid_emails.each do |invalid_email|
        before { user_val.email = invalid_email}
        it_behaves_like "バリデーションに引っかかる"
      end
    end
    context "userのemailが大文字小文字以外同じものを登録する場合" do
      before do
        email_big = "EXAMPLE@diver.com"
        FactoryBot.create(:user, email: email_big)
        user_val.email = email_big.downcase
      end
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userのpasswordが空の場合" do
      before { user_val.password = "" }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userのpasswordが5文字の場合" do
      before { user_val.password = "a" * 5 }
      it_behaves_like "バリデーションに引っかかる"
    end
    context "userのpasswordとpassword_confirmationが異なる場合" do
      before do
        user_val.password = "password"
        user_val.password_confirmation = "drowssap"
      end
      it_behaves_like "バリデーションに引っかかる"
    end
  end
  describe "コールバックのテスト" do
    let!(:admin01) { FactoryBot.create(:user, name: "管理ユーザー1", email: "admin01@diver.com", admin: true) }
    let!(:user) { FactoryBot.create(:user, name: "一般ユーザー", email: "example@diver.com", admin: false) }
    context "管理者が2人いる場合" do
      it "削除できる" do
        admin02 = FactoryBot.create(:user, name: "管理ユーザー2", email: "admin02@diver.com", admin: true)
        expect{admin02.destroy}.to change{ User.count }.by(-1)
      end
    end
    context "管理者が1人の場合" do
      it "管理者を削除できない" do
        expect{admin01.destroy}.to change{ User.count }.by(0)
      end
      it "非管理者は削除できる" do
        expect{user.destroy}.to change{ User.count }.by(-1)
      end
      it "管理者のadmin属性をfalseに変更できない" do
        admin01.update(admin: false)
        admin01.reload
        expect(admin01.admin).to be_truthy
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "タスクを作成しているユーザーを削除した場合" do
      it "作成したタスクも削除される" do
        user = FactoryBot.create(:user)
        task = FactoryBot.create(:task, user: user)
        expect{ user.destroy }.to change{ Task.count }.by(-1)
      end
    end
  end
end
