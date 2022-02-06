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
end
