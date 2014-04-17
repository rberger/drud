require 'spec_helper'

describe Drud do
  it 'Returns a semantic version number.' do
    expect(Drud::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end

describe Drud::CLI do
  it 'Returns the same version as Drud.' do
    expect(Drud::CLI::VERSION).to eq Drud::VERSION
  end
end
