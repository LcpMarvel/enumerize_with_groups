require 'spec_helper'

describe EnumerizeWithGroups do
  before do
    class ShoppingCart < ActiveRecord::Base
      extend Enumerize
      extend EnumerizeWithGroups

      enumerize :item,
                in: %i(banana apple football basketball),
                groups: {
                  fruit: %i(banana apple),
                  ball: %i(football basketball)
                }
    end
  end

  after do
    Object.instance_eval do
      remove_const(:ShoppingCart)
    end
  end

  it "defines method to list items by group" do
    expect(ShoppingCart.item_groups).to eq({
      fruit: %i(banana apple),
      ball: %i(football basketball)
    })
  end

  it "define methods to show items for specify group" do
    expect(ShoppingCart.item_fruit).to eq([:banana, :apple])
  end

  it 'defines scopes for ShoppingCart' do
    expect(ShoppingCart.respond_to?(:item_fruit_scope)).to eq true
  end
end
