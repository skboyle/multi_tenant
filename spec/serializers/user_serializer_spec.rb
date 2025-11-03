require "rails_helper"

RSpec.describe UserSerializer do
  let(:user) { create(:user, name: "Buddy", email: "buddy@example.com", avatar: "https://example.com/avatar.png") }

  it "includes id, name, and email and avatar string" do
    result = described_class.new(user).serializable_hash
    data = result[:data][:attributes]

    expect(data[:id]).to eq(user.id)
    expect(data[:name]).to eq(user.name)
    expect(data[:email]).to eq(user.email)
    expect(data[:avatar]).to eq("https://example.com/avatar.png")
  end

  it "has nil avatar when avatar is blank" do
    user.avatar = nil
    result = described_class.new(user).serializable_hash
    data = result[:data][:attributes]

    expect(data[:avatar]).to be_nil
  end
end
