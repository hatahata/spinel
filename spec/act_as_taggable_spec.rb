require 'spec_helper'
require 'active_support/inflector'

class Test
  include Mongoid::Document
  include Mongoid::ActAsTaggable

  field "name"
  acts_as_taggable
  acts_as_taggable_on :skills, :interests
end


describe Mongoid::ActAsTaggable do
  let(:model) { Test.new }
  let(:tag_value) { "fruit, rice, soap" }
  let(:tag_array) { tag_value.split(',').map(&:strip) } 

  describe "#act_as_taggable" do

    it "should create tag_list method" do
      model.should respond_to :tag_list
    end

    it "should create tag_list= method" do
      model.should respond_to :tag_list=
    end

    it "should create tags method" do
      model.should respond_to :tags
    end

    describe "#tag_list, #tag_list=" do
      it "should set tag list as array" do
        model.tag_list = tag_value
        model.tag_list.should =~ tag_array
      end
    end

    describe "#tags" do
      before(:each) { model.tag_list = tag_value }

      it "should return array of Tag class" do
        model.tags.should =~ tag_array.map do |tag|
          Mongoid::ActAsTaggable::Tag.new tag
        end
      end
    end
  end

  describe "#act_as_taggable_on" do
    context "when it takes :skills, :interests" do
      it "should create skill_list and interest_list methods" do
        model.should respond_to :skill_list, :interest_list
      end

      it "should create skill_list= and interest_list= methods" do
        model.should respond_to :skill_list=, :interest_list=
      end

      it "should create skills and interests method" do
        model.should respond_to :skills, :interests
      end

      describe "#skill_list, #skill_list=" do
        it "should set values as array" do
          model.skill_list = tag_value
          model.skill_list.should =~ tag_array
        end
      end

      describe "#skills" do
        it "should return array of Tag class" do
          model.skill_list = tag_value
          model.skills.should =~ tag_array.map do |tag|
            Mongoid::ActAsTaggable::Tag.new tag
          end
        end
      end
    end
  end
end
