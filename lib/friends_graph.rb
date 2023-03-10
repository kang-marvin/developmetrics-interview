require 'json'
require_relative './builders/graph_builder'

class FriendsGraph
  def initialize(opts = { root_node: '' })
    @root_node = opts[:root_node]
  end

  def build(data = {})
    GraphBuilder.build(data) do |builder|
      builder.set_root_node(root_node)
    end
  end

  private

  attr_accessor :root_node
end
