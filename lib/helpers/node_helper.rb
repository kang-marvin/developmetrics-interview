require_relative './../node'

class NodeHelper
  class << self

    def fetch_or_create_node(name, nodes)
      node_value = name.upcase
      unless nodes[node_value].nil?
        return nodes[node_value]
      end

      node = Node.new(node_value)
      nodes[node_value.to_sym] = node
      return node
    end
  end
end