require_relative '../lib/node'

RSpec.describe Node do
  describe 'Initialization raises ArgumentError' do
    it 'if value is empty' do
      expect { Node.new('') }.to raise_error(ArgumentError)
    end

    it ' if value is nil' do
      expect { Node.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe 'Adding nodes' do
    let(:child) { Node.new('Child') }
    let(:parent) { Node.new('Parent') }

    it 'increases parent nodes count by 1' do
      expect do
        parent.add_node(child)
      end.to change { parent.nodes.size }.by(1)
    end

    it "doesn't add a single node more than once" do
      expect do
        parent.add_node(child)
        parent.add_node(child)
      end.to change { parent.nodes.size }.by(1)
    end
  end
end
