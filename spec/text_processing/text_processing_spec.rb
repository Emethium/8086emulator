require_relative '../../src/text_processing/text_processing'

describe TextProcessing::Base do
	before(:all) do
		@tprocess = TextProcessing::Base.new
	end

	context 'some simple code' do
		it 'with blank lines must count' do
			code = "add ax, bx
			

							ret"
			expected = [ { line: 1, code: { instruction: :add,
																			args: [:ax, :bx] } },
									 { line: 2},
									 { line: 3},
									 { line: 4, code: { instruction: :ret } } ]
			result = @tprocess.process(code)
			expect(result).to eq(expected)	
		end

		it 'with a label and code in next line' do
			code = "sub cx, bx
							loop:
							add cx,ax

							ret"
			expected = [ { line: 1, code: { instruction: :sub, args: [:cx, :bx] } },
									 { line: 2, label: :loop },
									 { line: 3, code: { instruction: :add, args: [:cx, :ax] } },
									 { line: 4 },
									 { line: 5, code: { instruction: :ret } } ]
			result = @tprocess.process(code)
			expect(result).to eq(expected)
		end
	end	
end

