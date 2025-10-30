require "rails_helper"

RSpec.describe Project, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:project_leader).class_name("User").optional }
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "acts_as_list" do
    it "should respond to order_position" do
      expect(Project.new).to respond_to(:order_position)
    end
  end
end
