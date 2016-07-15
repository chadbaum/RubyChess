require 'rails_helper'

RSpec.describe Knight, type: :model do

  describe "white knight movement validation" do

    it "should return false if the knight is not being moved from its original location" do
      knight = FactoryGirl.create(:knight, :white)
      expect(knight.valid_move?(1,7)).to eq false
    end

    it "should return false if the knight is moved 2 spaces to the right" do
      knight = FactoryGirl.create(:knight, :white)
      expect(knight.valid_move?(3,7)).to eq false
    end

    it "should return false if the knight is moved forwards one space" do
      knight = FactoryGirl.create(:knight, :white)
      expect(knight.valid_move?(1,6)).to eq false
    end

    it "should return false if the knight 3 spaces diagonally forward and to the right" do
      knight = FactoryGirl.create(:knight, :white)
      expect(knight.valid_move?(4,4)).to eq false
    end

    it "should return true if the knight moves forward 2 spaces and then 1 space to the left" do
      knight = FactoryGirl.create(:knight, :white)
      expect(knight.valid_move?(2,5)).to eq true
    end

    it "should return true if the knight moves to the right 2 spaces and then 1 space forward" do
      knight = FactoryGirl.create(:knight, :white)
      expect(knight.valid_move?(3,6)).to eq true
    end

  end

  describe "black knight movement validation" do

    it "should return false if the knight is not being moved from its original location" do
      knight = FactoryGirl.create(:knight, :black)
      expect(knight.valid_move?(1,0)).to eq false
    end

    it "should return false if the knight is moved 2 spaces to the right" do
      knight = FactoryGirl.create(:knight, :black)
      expect(knight.valid_move?(3,0)).to eq false
    end

    it "should return false if the knight is moved forwards one space" do
      knight = FactoryGirl.create(:knight, :black)
      expect(knight.valid_move?(1,1)).to eq false
    end

    it "should return false if the knight 3 spaces diagonally forward and to the right" do
      knight = FactoryGirl.create(:knight, :black)
      expect(knight.valid_move?(4,3)).to eq false
    end

    it "should return true if the knight moves forward 2 spaces and then 1 space to the left" do
      knight = FactoryGirl.create(:knight, :black)
      expect(knight.valid_move?(0,2)).to eq true
    end

    it "should return true if the knight moves to the right 2 spaces and then 1 space forward" do
      knight = FactoryGirl.create(:knight, :black)
      expect(knight.valid_move?(3,1)).to eq true
    end
  end

  describe "Knight creation validation" do

    it "should have a type of Knight" do
      r = FactoryGirl.create(:knight)
      expect(r.type).to eq("Knight")
    end

    it "should not be allowed to create a red knight" do
      expect { FactoryGirl.create(:knight, color: "red") }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end
