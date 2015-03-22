# require 'encoder'

module TextProcessing
	class Base
		include TextProcessing

		def process(code)
			@text = code
			synthesize
		end

		private

		def synthesize
			line_process
		end

		def line_process
			vector = []
			line_break.each_with_index do |line, index|
				data = { line: index + 1 }
				label, line = partition(line)
				data[:label] = label.to_sym if label != ""
				data[:code] = code(line) if line != ""
				vector << data
			end
			vector
		end

		def code(line)
			match = line.scan(/([\w]*)([\w\d\[\]\+\-]*){0,2}/)
			match.flatten!.delete_if { |t| t == "" }
			{ instruction: instruction(match[0]), args: args(match[1..2]) }.
				delete_if { |k, v| v == [] }
		end

		def instruction(value)
			value.to_sym
		end

		def partition(line)
			parted = line.partition(":")
			if parted[1].empty? && parted[2].empty?
				[ "", parted[0]]
			elsif parted[2].empty?
				[parted[0], ""]
			else
				[parted[0], parted[2]]
			end	
		end

		def args(arguments)
			arguments.map { |v| v.to_sym }
		end

		def line_break
			@text.split("\n").map { |v| v.strip }
		end
	end
end
