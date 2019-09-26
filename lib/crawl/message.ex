defmodule Message do 
	defstruct magic: "", command: "", payload_length: "", checksum: "", payload: "" 

	def encode(bin) do 
		Base.encode16(bin, case: :lower)
	end 

	def decode(hex) do 
		Base.decode16(hex, case: :lower)
	end 

	def parse_length(payload_length) do 

		payload_length
		|> encode
		|> String.trim("0") 
		|> String.to_integer(16)
	end

	def parse_command(command) do 

		{:ok, parsed_command} = Message.encode(command) 
			|> String.trim("0") 
			|> Message.decode
		parsed_command
	end 

	def parse_payload(payload, len) do 

		<<parsed_payload::binary-size(len), _wtv::binary>> = payload 
		parsed_payload 
	end 

	def verify_checksum(payload, checksum) do 

		slice = String.slice(dblsha(payload), 0..3) 

		slice === checksum 

	end 

	def dblsha(str) do 

		h1 = :crypto.hash(:sha256, str) 
		h2 = :crypto.hash(:sha256, h1)
		
	end 
end 