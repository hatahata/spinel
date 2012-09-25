require 'active_support/concern'
require 'active_support/inflector'

module Mongoid::ActAsTaggable
  extend ActiveSupport::Concern

  Tag = Struct.new :name, :count

  module ClassMethods
    def acts_as_taggable
      acts_as_taggable_on :tags
    end

    def acts_as_taggable_on *args
      args.each do |type|
        field field_name(type)
        create_method type
        create_class_method type
      end
    end

    private

    def field_name type
      "#{type.to_s.singularize}_list"
    end

    def create_method type
      method_name = field_name(type)

      define_method("#{method_name}=") do |tag_list|
        write_attribute method_name, tag_list.split(',').map(&:strip)
      end

      define_method(type) do
        send(method_name).map {|tag| Tag.new tag }
      end
    end

    def create_class_method type
      method_name = field_name(type)
      define_singleton_method("#{type.to_s.singularize}_counts") do
        list = all.map(&method_name.to_sym).flatten.compact
        list = list.reduce(Hash.new(0)) {|h,v| h[v] += 1; h }
        list.map {|k,v| Tag.new k, v }
      end
    end
  end
end
