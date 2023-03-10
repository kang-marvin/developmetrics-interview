require_relative '../search'
require_relative '../lib/friends_graph'

DATA = {
  "jamie US": [
    "timur UA", "rob US",
    "pablo ES", "ali UA",
    "peter US", "mike US",
    "marcos FR", "tom UK"
  ],
  "timur UA": [
    "pablo ES", "carlos ES", "julie FR",
    "tom UK"
  ],
  "ali UA": [ "oscar PT" ],
  "peter US": [ "anna ES" ],
  "tom UK": [ "marc US" ],
  "mike US": [ "marc US" ],
  "marc US": [ "jamie US" ]
}

RSpec.describe Search do
  describe 'Traversal' do

    context 'without setting root node' do
      it 'uses head node as the root' do
        results = builder('')
        expect(results.first).to eql(DATA.keys.first.to_s)
      end
    end

    context 'with root node as nil' do
      it 'uses head node as the root' do
        results = builder(nil)
        expect(results.first).to eql(DATA.keys.first.to_s)
      end
    end

    context 'with root node set' do
      it 'uses the set node as root' do
        root_node = 'mike US'
        results = builder(root_node)
        expect(results.first).to eql(root_node)
      end
    end

    context '' do
      it 'does not have duplicates' do
        results = builder(nil, {'marc US': [ 'jamie US' ]})
        expect(results.count('marc US')).to eql(1)
      end
    end

    private

    def builder(root, data = {})
      Search.new(
        FriendsGraph.new({ root_node: root }).build(DATA.merge(data))
      ).call({})
    end

  end
end
