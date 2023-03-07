require 'set'

class Node
  attr_accessor :name, :country

  def initialize(value)
    raise ArgumentError if value.to_s.empty?

    @name, @country = splitter(value)
    @_nodes ||= Set.new
  end

  def add_node(node)
    _nodes << node
  end

  def nodes
    _nodes.to_a
  end

  private

  attr_accessor :_nodes

  def splitter(value)
    value.to_s.gsub(/[)(]/, '').split
  end
end
