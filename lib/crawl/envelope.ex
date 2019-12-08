defmodule NetworkEnvelope do 
	alias Message

	defstruct raw_bytes: <<>>

	def from_peer({address, port}) do
		socket = Sock.connect({address, port})
		msg = Sock.stream(socket) 
		%NetworkEnvelope{raw_bytes: msg}

	end  

	def parse(bytes) when is_binary(bytes) do  

		<< magic::binary-size(4), 
			command::binary-size(12), 
			payload_length::little-size(16), 
			checksum::binary-size(4), 
			rest::binary >> = bytes

		%Message{ 
				magic: Message.parse_magic(magic), 
				command: Message.parse_command(command),
				payload_length: payload_length,
			 	checksum: Message.encode(checksum),
			 	payload: Message.parse_payload(Message.parse_command(command), rest, payload_length)
		}

		end

end
