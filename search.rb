require 'json'
require 'set'

require_relative './lib/friends_graph'

test_data_file = File.read('./data.json')
data = JSON.parse(test_data_file)

module FriendsType
  DIRECT = 'direct'.freeze
end

class Search
  ZERO = 0

  attr_accessor :graph

  def initialize(graph)
    @graph = graph
    @nodes_collection = []
    @current_depth_level = ZERO
    @list = []
  end

  def call(params)
    breadth_first(ZERO, params)
    # depth_first(ZERO, graph, params)

    puts nodes_collection.map(&:value).inspect
  end

  def friends_distribution_by_country(
    opts = { friend: nil, friends_type: FriendsType::DIRECT }
  )
    call(opts)
    results =
      nodes_collection
        .to_a
        .group_by { |i| i.country }
        .transform_values { |values| values.count}
    puts results
  end

  private

  attr_accessor :nodes_collection,
                :current_depth_level,
                :list

  def breadth_first(
    index = ZERO,
    filters = { friend: nil, friends_type: 'DIRECT' }
  )
    nodes_collection << graph if index == ZERO
    root = nodes_collection[index] rescue nil
    return if root.nil?

    root.nodes.each do |node|
      next if nodes_collection.include? node
      nodes_collection << node
    end

    breadth_first((index+1), filters)
  end

  def depth_first(level = 0, node = graph, filters = {})
    return if nodes_collection.include? node
    nodes_collection << node

    node.nodes.each do |node|
      depth_first((level+1), node, filters)
    end
  end

end

# Search for Jamie ́s friends distribution by Country ex: US: 2, ES:3

graph = FriendsGraph.new({root_node: 'tom UK'}).build(data)
search = Search.new(graph)

search.call({})

# search.friends_distribution_by_country(
#   { friend: 'jamie' }.merge({ friends_type: FriendsType::DIRECT })
# )
