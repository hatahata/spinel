require 'active_support/concern'
require 'active_support/inflector'

module Mongoid
  module ActAsTaggable
    extend ActiveSupport::Concern

    Tag = Struct.new :name

    module ClassMethods
      def acts_as_taggable
        create_methods :tags
      end

      def acts_as_taggable_on *args
        args.each do |type|
          create_methods type
        end
      end

      private

      def create_methods type
        method_name = "#{type.to_s.singularize}_list"

        field method_name

        define_method("#{method_name}=") do |tag_list|
          write_attribute method_name, tag_list.split(',').map(&:strip)
        end

        define_method(type) do
          send(method_name).map {|tag| Tag.new tag }
        end
      end
    end
  end
end
