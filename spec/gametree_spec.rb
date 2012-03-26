require 'spec_helper'

describe SGF::Gametree do

  it "should hold the first node of the game" do
    game = get_first_game_from 'spec/data/ff4_ex.sgf'
    game.current_node["FF"].should eq "4"
  end

  it "should throw up if initialized with a non-Node argument" do
    expect { SGF::Gametree.new("I am a string") }.to raise_error(ArgumentError)
    expect { SGF::Gametree.new(SGF::Node.new) }.to_not raise_error(ArgumentError)
  end

  it "should have the expected game-level information" do
    game = get_first_game_from 'spec/data/ff4_ex.sgf'
    game.name.should eq "Gametree 1: properties"
    game.data_entry.should eq "Arno Hollosi"
    expect { game.opening }.to raise_error(SGF::NoIdentityError)
    expect { game.nonexistent_identity }.to raise_error(NoMethodError)
  end

  it "should give you a minimum of useful information on inspect" do
    game = get_first_game_from 'spec/data/simple.sgf'
    inspect = game.inspect
    inspect.should match /SGF::Game/
    inspect.should match /#{game.object_id}/
  end

  context "When talking about nodes" do

    it "should have 'root' as the default current node" do
      game = get_first_game_from 'spec/data/ff4_ex.sgf'
      game.current_node.should eq game.root
    end

    it "should have a nice way to go to children[0]" do
      game = get_first_game_from 'spec/data/ff4_ex.sgf'
      game.next_node
      game.current_node.should eq game.root.children[0]
    end

    it "should have a way of setting an arbitrary node to the current node" do
      game = get_first_game_from 'spec/data/ff4_ex.sgf'
      game.current_node = game.root.children[3]
      game.current_node.properties.keys.sort.should eq %w(B C N)
      game.current_node.children.size.should eq 6
    end

  end

  it "should use preorder traversal for each" do
    game = get_first_game_from 'spec/data/example1.sgf'
    array = []
    game.each { |node| array << node }
    array[0].c.should eq "root"
    array[1].c.should eq "a"
    array[2].c.should eq "b"
  end

  it "should go through all nodes, even if block returns 'nil' (puts, anyone?)" do
    root = SGF::Node.new FF: "4", PB: "Me", PW: "You"
    game = SGF::Gametree.new root
    root.add_children SGF::Node.new(B: "dd")
    nodes = []
    game.each { |node| nodes << node; nil }
    nodes.size.should eq 2
  end

end