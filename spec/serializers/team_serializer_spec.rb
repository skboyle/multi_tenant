require "rails_helper"

RSpec.describe TeamSerializer do
  let(:team) { create(:team, name: "Engineering", slug: "engineering", theme_color: "#ff6600") }

  it "includes name, slug, and theme_color" do
    result = described_class.new(team).serializable_hash
    data = result[:data][:attributes]

    expect(data[:name]).to eq("Engineering")
    expect(data[:slug]).to eq("engineering")
    expect(data[:theme_color]).to eq("#ff6600")
  end

  it "includes logo as the logo string" do
    team.update(logo: "https://example.com/logo.png")

    result = described_class.new(team).serializable_hash
    data = result[:data][:attributes]

    expect(data[:logo]).to eq("https://example.com/logo.png")
  end
end
