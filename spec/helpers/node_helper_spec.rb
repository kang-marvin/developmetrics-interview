require_relative '../../lib/graph'
require_relative '../../lib/helpers/node_helper'

NODES_DATA = {
  one: ['four']
}.freeze

RSpec.describe NodeHelper do
  describe '#fetch_or_create_node' do
    let(:graph) do
      Graph.call(NODES_DATA)
    end

    context 'node name is not provided' do
      it 'raises ArgumentError' do
        expect { NodeHelper.fetch_or_create_node('', graph) }.to raise_error(ArgumentError)
      end
    end

    describe 'node name' do
      context 'exists in the graph' do
        it 'returns the node' do
          expect(NodeHelper.fetch_or_create_node('one', graph).value).to eql('ONE')
        end

        it "doesn't change nodes count in the graph" do
          expect do
            NodeHelper.fetch_or_create_node('one', graph)
          end.to change { graph.keys.size }.by(0)
        end
      end

      context "doesn't exist in the graph" do
        it 'creates and return the node' do
          expect(NodeHelper.fetch_or_create_node('six', graph).value).to eql('SIX')
        end

        it 'increases the nodes count in the graph' do
          expect do
            NodeHelper.fetch_or_create_node('twelve', graph)
          end.to change { graph.keys.size }.by(1)
        end
      end
    end
  end
end
