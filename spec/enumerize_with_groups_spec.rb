require 'spec_helper'

describe EnumerizeWithGroups do
  def add_enumerize_config(unconfigured_klass)
    unconfigured_klass.enumerize(
      :item,
      in: %i(banana apple football basketball),
      groups: {
        fruit: %i(banana apple),
        ball: %i(football basketball)
      }
    )
  end

  let(:klass) do
    Class.new do
      extend Enumerize
      extend EnumerizeWithGroups
    end
  end

  let(:object) { klass.new }

  before { add_enumerize_config(klass) }

  it "defines method to list items by group" do
    expect(klass.item_groups).to eq({
      fruit: %i(banana apple),
      ball: %i(football basketball)
    })
  end

  it "define methods to show items for specify group" do
    expect(klass.item_fruit).to eq([:banana, :apple])
  end

  it "defines method to determine group includes the specify value" do
    object.item = "banana"
    expect(object.in_item_fruit?).to be_truthy

    object.item = "football"
    expect(object.in_item_fruit?).to be_falsy
  end

  it "defines scopes for klass if the super class is ActiveRecord::Base" do
    klass = Class.new(ActiveRecord::Base) do
      extend Enumerize
      extend EnumerizeWithGroups
    end
    add_enumerize_config(klass)

    expect(klass.respond_to?(:item_fruit_scope)).to eq true
  end
end
