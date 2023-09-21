# frozen_string_literal: true

module HandleHelper
  def handle!(object)
    @object = object

    object.class.superclass == ActiveRecord::Base ? handle_object : handle_collection
  end

  def exist?(object)
    return false if object

    error! 'Object not found', 404 unless object
  end

  private

  attr_reader :object

  def handle_collection
    object.map { |item| SerializerHandler.new(item).serialize }
  end

  def handle_object
    error! object.errors.messages, 400 and return unless object.valid?

    SerializerHandler.new(object).serialize
  end

  class SerializerHandler
    def initialize(object)
      @object = object
    end

    def serialize
      serializer_for_object.new(object)
    end

    private

    attr_reader :object

    def serializer_for_object
      "#{object.class.name}Serializer".constantize
    end
  end
end
