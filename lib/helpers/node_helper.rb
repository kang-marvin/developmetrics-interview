require_relative './../node'

class NodeHelper
  class << self
    def fetch_or_create_node(name, nodes)
      node_value = name.upcase.to_sym
      return nodes[node_value] unless nodes[node_value].nil?

      node = Node.new(node_value)
      nodes[node_value] = node
      node
    end
  end
end
