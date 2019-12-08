defmodule Message do 

	defstruct magic: "", 
			command: "", 
			payload_length: 0, 
			checksum: <<>>, 
			payload: <<>> 


	def parse_magic(bin) do 
	# fix this to match on bytes
		case encode(bin) do 
			"f9beb4d9" -> "Mainnet"
			_ -> "Not Mainnet"
		end
	end 

	def parse_command(command) do 

		{:ok, parsed_command} = Message.encode(command) 
			|> String.trim("0") 
			|> Message.decode
		parsed_command
	end 

	def parse_payload(command, bin, len) do 

		case command do 
			"version" ->  parse_version(bin, len)
			"verack" -> <<msg::binary>> = bin 
			"alert" -> "alert"
			other -> other 
		end 
	end 

	def parse_version(bin, len) do 

		<<payload::binary-size(len), _rest::binary>> = bin

		VersionPayload.parse(payload)

	end 

	def verify_checksum(payload, checksum) do 

		slice = String.slice(dblsha(payload), 0..3) 

		slice === checksum 
	# raise error 
	end 

	defp dblsha(bin) do 

		h1 = :crypto.hash(:sha256, bin)
		:crypto.hash(:sha256, h1)
		
	end 

	def encode(bin) do 
		Base.encode16(bin, case: :lower)

	end 

	def decode(hex) do 
		Base.decode16(hex, case: :lower)
	end 

end 
