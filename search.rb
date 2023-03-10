require 'json'
require 'set'

require_relative './lib/friends_graph'

test_data_file = File.read('./data.json')
data = JSON.parse(test_data_file)

module FriendsType
  DIRECT = 'DIRECT'.freeze
  INDIRECT = 'INDIRECT'.freeze
end

class Search
  ZERO = 0

  attr_accessor :graph

  def initialize(graph)
    @graph = graph
    @nodes_collection = []
    @current_depth_level = ZERO
    @friend_direct_nodes = []
  end

  def call(algo_type = 'BREADTH', params)
    case algo_type.upcase
    when 'DEPTH'
      depth_first(ZERO, graph, params)
    else
      breadth_first(ZERO, params)
    end

    nodes_collection.map(&:value)
  end

  def friends_distribution_by_country(
    opts = { friend: nil, friends_type: FriendsType::DIRECT }
  )
    call('BREADTH', opts[:friend])
    results =
      filter_by_friend_type(opts[:friends_type])
        .group_by { |i| i.country }
        .transform_values { |values| values.count }

    results
  end

  private

  attr_accessor :nodes_collection,
                :current_depth_level,
                :friend_direct_nodes

  def breadth_first(
    index = ZERO,
    user = nil
  )
    nodes_collection << graph if index == ZERO
    root = nodes_collection[index] rescue nil
    return if root.nil?
    root_nodes = root.nodes

    if (
      root.name == user &&
      nodes_collection.include?(root)
    )
      @friend_direct_nodes = root_nodes
    end

    root_nodes.each do |node|
      next if nodes_collection.include? node
      nodes_collection << node
    end

    breadth_first((index + 1), user)
  end

  def depth_first(level = 0, node = graph, filters = {})
    return if nodes_collection.include? node

    nodes_collection << node

    node.nodes.each do |node|
      depth_first((level + 1), node, filters)
    end
  end

  def filter_by_friend_type(type)
    result = type == FriendsType::DIRECT ?
      (nodes_collection & friend_direct_nodes) :
      (nodes_collection - friend_direct_nodes - [graph])
    return result
  end
end

search = Search.new(
  FriendsGraph.new({ root_node: 'jamie US' }).build(data)
)

#? Search for Jamie ́s friends distribution by Country ex: US: 2, ES:3

# puts search.friends_distribution_by_country(
#   { friend: 'jamie', friends_type: FriendsType::DIRECT }
# ).inspect

#? Search for friends of Jamie ́s friends distribution by Country ex: UA: 3, FR:4 (Friend
#? of friend, should not be friend of jamie directly

puts search.friends_distribution_by_country(
  { friend: 'jamie', friends_type: FriendsType::INDIRECT }
).inspect
