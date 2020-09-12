require 'spec_helper'

describe VtigerRuby do
  it 'returns the current version number' do
    expect(VtigerRuby::VERSION).to eq('0.1.0')
  end
end
