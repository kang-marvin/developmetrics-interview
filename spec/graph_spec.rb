require_relative "../lib/graph"

RSpec.describe Graph do

  describe "#call" do

    it "returns empty hash if data is empty" do
      expect(Graph.call({})).to be_empty
    end

    it "doesn't duplicate nodes" do
      data = {
        'one': ['one', 'three'],
        'three': ['four', 'one']
      }
      expect(Graph.call(data).keys.size).to eql(3)
    end
  end
end