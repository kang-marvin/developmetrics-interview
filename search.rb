require 'json'

require_relative './lib/friends_graph'

test_data_file = File.read('./data.json')
data = JSON.parse(test_data_file)

module FriendType
  DIRECT = 'DIRECT'.freeze
  INDIRECT = 'INDIRECT'.freeze
end

module AlgorithmType
  BREADTH = 'BREADTH'.freeze
  DEPTH = 'DEPTH'.freeze
end

class Search
  ZERO = 0

  attr_accessor :root_node_in_graph

  def initialize(root_node_in_graph)
    @root_node_in_graph = root_node_in_graph
    @nodes_collection = []
    @person_direct_friend_nodes = []
  end

  def call(algo_type = AlgorithmType::BREADTH, params)
    case algo_type.upcase
    when AlgorithmType::DEPTH
      depth_first(ZERO, root_node_in_graph, params)
    else
      breadth_first(ZERO, params)
    end

    nodes_collection.map(&:value)
  end

  def friends_distribution_by_country(
    opts = { person: nil, friend_type: FriendType::DIRECT }
  )
    call(AlgorithmType::BREADTH, opts[:person])
    results =
      filter_by_friend_type(opts[:friend_type])
        .group_by { |i| i.country }
        .transform_values { |values| values.count }

    results
  end

  def friends_by_country(
    opts = { person: nil, from_country: nil, friend_type: FriendType::DIRECT }
  )
    call(AlgorithmType::BREADTH, opts[:person])
    results =
      from_country(
        filter_by_friend_type(opts[:friend_type]),
        opts[:from_country]
      ).map { |node| node.name }

    results
  end

  private

  attr_accessor :nodes_collection,
                :person_direct_friend_nodes

  def breadth_first(
    index = ZERO,
    user = nil
  )
    nodes_collection << root_node_in_graph if index == ZERO
    root = nodes_collection[index] rescue nil
    return if root.nil?
    root_nodes = root.nodes

    if (
      root.name == user &&
      nodes_collection.include?(root)
    )
      @person_direct_friend_nodes = root_nodes
    end

    root_nodes.each do |node|
      next if nodes_collection.include? node
      nodes_collection << node
    end

    breadth_first((index + 1), user)
  end

  def depth_first(level = 0, node = root_node_in_graph, filters = {})
    return if nodes_collection.include? node

    nodes_collection << node

    node.nodes.each do |node|
      depth_first((level + 1), node, filters)
    end
  end

  def filter_by_friend_type(type)
    result = type == FriendType::DIRECT ?
      (nodes_collection & person_direct_friend_nodes) :
      (nodes_collection - person_direct_friend_nodes - [root_node_in_graph])
    return result
  end

  def from_country(list, country)
    list.select { |node| node.country == country }
  end
end

search = Search.new(
  FriendsGraph.new({ root_node: 'jamie US' }).build(data)
)

#? Search for Jamie ́s friends distribution by Country ex: US: 2, ES:3

puts search.friends_distribution_by_country(
  { person: 'jamie', friend_type: FriendType::DIRECT }
).inspect

#? Search for friends of Jamie ́s friends distribution by Country ex: UA: 3, FR:4 (Friend
#? of friend, should not be friend of jamie directly

puts search.friends_distribution_by_country(
  { person: 'jamie', friend_type: FriendType::INDIRECT }
).inspect

#? Search for a friend of Jamie's friends who lives in the US (should not be friend with )
puts search.friends_by_country(
  { person: 'jamie', from_country: 'US', friend_type: FriendType::INDIRECT }
).inspect

#? Search for a friend of Jamie who lives in Ukraine but has no Spanish friends
#! Not ye implemented.
# puts search.friends_by_country_without_friends_from(
#   { person: 'jamie', from_country: 'UA', no_friends_from_country: 'ES' friend_type: FriendType::INDIRECT }
# ).inspect

#? Results to be shown in a Graph (use https://mermaid.js.org/ syntax)
#! Not yet implemented.