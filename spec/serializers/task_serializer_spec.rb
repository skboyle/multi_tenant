require "rails_helper"

RSpec.describe TaskSerializer do
  let(:team) { create(:team) }
  let(:project) { create(:project, team: team) }
  let(:task) { create(:task, project: project, team: team, title: "Setup CI") }  # ✅ add team

  it "includes title and project relationship" do
    result = described_class.new(task).serializable_hash
    data = result[:data]

    expect(data[:attributes][:title]).to eq("Setup CI")
    expect(data[:relationships][:project]).to be_present
  end
end
