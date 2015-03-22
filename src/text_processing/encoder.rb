module TextProcessing
	module Encoder
		
		# Object to be returned:
		# { memory: { exp: exp [, imed: imed] } }
		def memory_access(string)
			values = string.upcase.scan(/([BS][PIX])?(\-?\d*)/).flatten.delete_if { |v| v == "" || v == nil }

			errors = string.upcase.scan(/([^BSPIX\d\s\+\-\]\[])/).flatten.delete_if { |v| v == "" || v == nil }

			raise 'ERROR: Invalid argument' if values.empty? || !errors.empty?

			result = {}
			
			case values.length
			when 1
				result[:memory] = one_arg(values)
			else
				result[:memory] = multiple_args(values)
			end
			result
		end
		
		private 

		def is_number?(args)
			if args.class == Array
				!args[0].scan(/\d+/).empty?
			else
				!args.scan(/\d+/).flatten.delete_if { |v| v == "" || v == nil }.empty?
			end
		end

		def multiple_args(args)
			result = { exp: [] }
			args.each do |arg|
				if is_number?(arg)
					result[:imed] = arg.to_i
				else
					# arg.map { |v| v.downcase.to_sym }
					result[:exp] <<  arg.downcase.to_sym
				end
			end
			result
		end

		def one_arg(args)
			if is_number? args
				{ imed: args[0].to_i }
			else
				{ exp: args.map { |v| v.downcase.to_sym } }
			end
		end

	end
	extend Encoder
end
