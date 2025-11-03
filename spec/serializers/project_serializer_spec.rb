require "rails_helper"

RSpec.describe ProjectSerializer do
  let(:team) { create(:team) }
  let(:leader) { create(:user, team: team) }
  let(:project) { create(:project, team: team, project_leader: leader, title: "Roadmap") }
  let!(:task) { create(:task, project: project, team: team) }  # ✅ add team

  it "includes attributes and relationships" do
    result = described_class.new(project).serializable_hash
    data = result[:data]

    expect(data[:attributes][:title]).to eq("Roadmap")
    expect(data[:relationships].keys).to include(:team, :project_leader, :users, :tasks)
  end
end
