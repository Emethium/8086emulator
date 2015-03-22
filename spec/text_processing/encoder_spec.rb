require_relative '../../src/text_processing/encoder'


describe Encoder do
	class EncoderClass
		include Encoder
	end
	
	before(:all) do
		@encoder = EncoderClass.new
	end

	context 'memory with one argument' do
		it '[SI]' do
			string = '[SI]'
			expected = { memory: { exp: ["SI"] } }
			result = @encoder.memory_access(string)

			expect(result).to eq(expected)
		end

		it 'imediate [1000]' do
			string = '[1000]'
			result = @encoder.memory_access(string)
			expected = { memory: {imed: 1000} }
			expect(result).to eq(expected)
		end
	end

	context 'memory with two arguments' do
		it '[SI+9]' do
			result = @encoder.memory_access('[SI+9]')
			shoulda = { memory: { exp: ["SI"], imed: 9} }
			expect(result).to eq(shoulda)

		end
		it '[BP+SI]' do
			result = @encoder.memory_access('[BP+SI]')
			shoulda = { memory: { exp: %w(BP SI) } }
			expect(result).to eq(shoulda)
		end

		it '[BP+CX] is invalid' do
			expect{ @encoder.memory_access('[BP+CX]') }.to raise_error(RuntimeError)
		end
	end

	context 'memory with three arguents' do
		it '[BX+SI+1200]' do
			result = @encoder.memory_access('[BX+SI+1200]')
			expect(result).to eq( { memory: { exp: ['BX', 'SI'], imed: 1200} } )
		end
	end

end
