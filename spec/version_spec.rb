# encoding: utf-8
require 'spec_helper'
require 'drud/cli'

describe Drud do
  it 'Returns a semantic version number.' do
    expect(Drud::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end

describe Drud::CLI do
  it 'Returns the same constant version as Drud.' do
    expect(Drud::CLI::VERSION).to eq Drud::VERSION
  end

  describe '#version' do
    before do
      @content = capture(:stdout) { Drud::CLI.start(['version']) }
    end
    it 'Executing `drud version` returns the correct version.' do
      expect(@content).to match(/^#{Drud::VERSION}/)
    end
    @content = capture(:stdout) { Drud::CLI.start(['-v']) }
    it 'Executing `drud -v` returns the correct version.' do
      expect(@content).to match(/^#{Drud::VERSION}/)
    end
  end
end
