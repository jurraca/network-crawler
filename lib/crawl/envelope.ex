defmodule NetworkEnvelope do 
	require Message

	defstruct raw_bytes: <<>>

	def from_peer(ip) do
		{:ok, msg} = Sock.connect(ip)
		%NetworkEnvelope{raw_bytes: msg}
	end  

	def parse(bytes) do 

		<< magic::binary-size(4), 
			command::binary-size(12), 
			payload_length::little-size(16), 
			checksum::binary-size(4), 
			rest::binary >> = bytes

		%Message{ 
				magic: Message.parse_magic(magic), 
				command: Message.parse_command(command),
				payload_length: payload_length,
			 	checksum: checksum,
			 	payload: Message.parse_payload(rest, payload_length)
		}

		end

end
