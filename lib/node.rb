require 'set'

class Node
  attr_accessor :value, :_nodes

  def initialize(value)
    raise ArgumentError if value.to_s.empty?

    @value = value.to_s
    @_nodes ||= Set.new
  end

  def add_node(node)
    _nodes << node
  end

  def nodes
    _nodes.to_a
  end
end
