require_relative './graph'

class GraphBuilder
  attr_accessor :store

  def self.build(data)
    builder = new(data)
    yield(builder)
    builder.store
  end

  def initialize(data)
    @store = Graph.call(data)
  end

  def set_root_node(value)
    key = upcase_value(value)
    result = if store[key].nil?
               store.values[0]
             else
               store[key]
             end
    @store = result
  end

  private

  def upcase_value(value)
    value.upcase.to_sym
  end
end
