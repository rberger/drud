# encoding: utf-8
require 'spec_helper'
require 'drud'

describe Drud, 'rescue' do
  it 'rescues Thor::Error and raises SystemExit' do
    expect do
      Drud::CLI.rescue do
        fail Thor::Error.new(''), ''
      end
    end.to raise_error(SystemExit)
  end
end
