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
        results = builder(nil, '', {'marc US': [ 'jamie US' ]})
        expect(results.count('marc US')).to eql(1)
      end
    end

  end

  describe 'Breadth Traversal Path' do
    context 'with default root node' do
      it 'returns the correct path' do
        results = builder('jamie US')
        expected_result = [
          "jamie US", "timur UA", "pablo ES", "carlos ES",
          "julie FR", "tom UK", "marc US", "rob US", "ali UA",
          "oscar PT", "peter US", "anna ES", "mike US", "marcos FR"
        ]
        expect(results).to match_array(expected_result)
      end
    end

    context 'with set root node' do
      it 'returns the correct path' do
        results = builder('marc US')
        expected_result = [
          "marc US", "jamie US", "timur UA", "rob US", "pablo ES",
          "ali UA", "peter US", "mike US", "marcos FR", "tom UK",
          "carlos ES", "julie FR", "oscar PT", "anna ES"
        ]
        expect(results).to match_array(expected_result)
      end
    end

    context 'with set root node without children' do
      it 'returns correct path of 1' do
        results = builder('oscar PT')
        expected_result = ["oscar PT"]
        expect(results).to match_array(expected_result)
      end
    end

  end

  describe 'Depth Traversal Path' do
    context 'with default root node' do
      it 'returns the correct path' do
        results = builder('jamie US', 'DEPTH')
        expected_result = [
          "jamie US", "timur UA", "pablo ES", "carlos ES",
          "julie FR", "tom UK", "marc US", "rob US",
          "ali UA", "oscar PT", "peter US", "anna ES",
          "mike US", "marcos FR"
        ]
        expect(results).to match_array(expected_result)
      end
    end

    context 'with set root node' do
      it 'returns the correct path' do
        results = builder('marc US', 'DEPTH')
        expected_result = [
          "marc US", "jamie US", "timur UA", "pablo ES",
          "carlos ES", "julie FR", "tom UK", "rob US",
          "ali UA", "oscar PT", "peter US",
          "anna ES", "mike US", "marcos FR"
        ]
        expect(results).to match_array(expected_result)
      end
    end

    context 'with set root node without children' do
      it 'returns correct path of 1' do
        results = builder('oscar PT', 'DEPTH')
        expected_result = ["oscar PT"]
        expect(results).to match_array(expected_result)
      end
    end

  end

  describe 'Friends Distribution by Country' do
    context 'without setting the friend' do
      it 'returns empty distribution' do
        result = friend_distribution_by_country_builder(
          '', 'BREADTH', { friend: '', friends_type: 'DIRECT' }
        )
        expect(result).to be_empty
      end
    end

    context 'with root as friend for DIRECT' do
      it 'returns distribution by country' do
        result = friend_distribution_by_country_builder(
          'jamie US', 'BREADTH', { friend: 'jamie', friends_type: 'DIRECT' }
        )
        expect(result).to eql({"ES"=>1, "FR"=>1, "UA"=>2, "UK"=>1, "US"=>3})
      end
    end

    context 'with root as friend for INDIRECT' do
      it 'returns distribution by country' do
        result = friend_distribution_by_country_builder(
          'jamie US', 'BREADTH', { friend: 'jamie', friends_type: 'INDIRECT' }
        )
        expect(result).to eql({"ES"=>2, "FR"=>1, "PT"=>1, "US"=>1})
      end
    end
  end

  private

  def builder(root, algo_type = 'BREADTH', data = {})
    Search.new(
      FriendsGraph.new({ root_node: root }).build(DATA.merge(data))
    ).call(algo_type, {})
  end

  def friend_distribution_by_country_builder(root, algo_type = 'BREADTH', data)
    Search.new(
      FriendsGraph.new({ root_node: root }).build(DATA)
    ).friends_distribution_by_country(data)
  end
end
