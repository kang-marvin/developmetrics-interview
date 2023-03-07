require_relative './helpers/node_helper'

class Graph
  attr_accessor :nodes, :data

  def self.call(data)
    new(data).generate_graph
  end

  def initialize(data)
    @nodes = {}
    @data = data
  end

  def generate_graph
    data.each do |key, value|
      parent_node = NodeHelper.fetch_or_create_node(key, nodes)
      value.each do |child|
        child_node = NodeHelper.fetch_or_create_node(child, nodes)
        next if parent_node === child_node

        parent_node.add_node(child_node)
      end
    end
    nodes
  end
end
