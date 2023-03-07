require_relative '../../lib/graph'
require_relative '../../lib/helpers/node_helper'

NODES_DATA = {
  'one (KE)': ['four (DE)']
}.freeze

RSpec.describe NodeHelper do
  describe '#fetch_or_create_node' do
    let(:graph) do
      Graph.call(NODES_DATA)
    end

    context 'node name is not provided' do
      it 'raises ArgumentError' do
        expect {
          NodeHelper.fetch_or_create_node('', graph)
        }.to raise_error(ArgumentError)
      end
    end

    describe 'node name' do
      context 'exists in the graph' do
        it 'returns the node name and country' do
          node = NodeHelper.fetch_or_create_node('one (KE)', graph)
          expect(node.name).to eql('one')
          expect(node.country).to eql('KE')
        end

        it "doesn't change nodes count in the graph" do
          expect do
            NodeHelper.fetch_or_create_node('one (KE)', graph)
          end.to change { graph.keys.size }.by(0)
        end
      end

      context "doesn't exist in the graph" do
        it 'creates and return the node' do
          expect(
            NodeHelper.fetch_or_create_node('six (SA)', graph).name
          ).to eql('six')
        end

        it 'increases the nodes count in the graph' do
          expect do
            NodeHelper.fetch_or_create_node('twelve (IA)', graph)
          end.to change { graph.keys.size }.by(1)
        end
      end
    end
  end
end
