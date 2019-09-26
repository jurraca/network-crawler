defmodule NetworkEnvelope do 
	require Message

	def parse(msg) do 

		<< magic::binary-size(4), 
			command::binary-size(12), 
			payload_length::binary-size(4), 
			checksum::binary-size(4), 
			payload::binary >> = msg

		map = %Message{}
			
		out = %Message{
			map | magic: Message.encode(magic), 
				command: Message.parse_command(command),
				payload_length: Message.parse_length(payload_length),
			 	checksum: checksum,
			 	payload: Message.parse_payload(payload, Message.parse_length(payload_length))
		}

		end 
	end
