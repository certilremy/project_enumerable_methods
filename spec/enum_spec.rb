require_relative '../lib/main.rb'

describe Enumerable do
  let(:arr) { [2, 3, 4] }
  let(:new_arr) { [1, 2, 2] }
  let(:empyt_arr) { [] }
  describe '#my_each' do
    it 'return enumerator if block not given' do
      expect(arr.my_each.class).to eq(Enumerator)
    end

    it 'loops an entire array' do
      new_arr.my_each { |n| empyt_arr[n] = n + 2 }
      expect(empyt_arr).to eq([nil, 3, 4])
    end

    it 'returns product of each item in array' do
      expect(arr.my_each { |i| i * 2 }).to eql([4, 6, 8])
    end
  end
end
