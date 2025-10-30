require "rails_helper"

RSpec.describe Task, type: :model do
  describe "associations" do
    it { should belong_to(:project) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "acts_as_list" do
    it "should respond to order_position" do
      expect(Task.new).to respond_to(:order_position)
    end
  end
end
