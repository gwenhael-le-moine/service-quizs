# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'OutilsTest' do
  include Outils

  it 'retourne une raise erreur' do
    begin
      raise RuntimeError
    rescue => err
      expect { raise_err(err, "message d'erreur") }.to raise_error(RuntimeError)
    end
  end
end