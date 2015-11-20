require_relative '../spec_helper'

describe Compatriot do
  describe 'no control image is found' do
    before do
      Compatriot.do_something
    end

    it 'it will create one' do
      assert control_image.exists?
    end
  end

  describe 'control image is found' do
    before do
      setup_control_image
      @result = Compatriot.do_something
    end

    it 'stores a variable image' do
      assert variable_image.exists?
    end

    it 'stores the image difference' do
      assert diff_image.exists?
    end

    it 'returns the percentage difference' do
      assert @result == 0.50
    end
  end
end
