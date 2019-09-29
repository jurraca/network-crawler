defmodule VersionPayload do 

	defstruct protocol: "",
		services: "",
		timestamp: "",
		receiver_services: "",
		receiver_address: "",
		receiver_port: "",
		sender_services: "",
		sender_address: "",
		sender_port: "",
		nonce: "",
		height: "",
		user_agent: ""

	def parse(payload) do 

		<<
		_pad::binary-size(2), 
		protocol::little-size(32),
		services::little-unsigned-size(64), 
		timestamp::little-size(64),
		receiver_services::little-size(64),
		receiver_address::binary-size(16), 
		receiver_port::little-size(16), 
		sender_services::little-size(64),
		sender_address::binary-size(16), 
		sender_port::little-size(16), 
		nonce::little-unsigned-size(64),
		varint::little-size(8),
		ua::binary >> = payload 

		<< user_agent::binary-size(varint), 
		height::little-size(24) 
		>> = ua 

		%VersionPayload{
			protocol: protocol, 
			services: services,
			timestamp: parse_timestamp(timestamp),
			receiver_services: receiver_services,
			receiver_address: parse_addr(receiver_address),
			receiver_port: receiver_port,
			sender_services: sender_services,
			sender_address: parse_addr(sender_address),
			sender_port: sender_port,
			nonce: nonce,
			user_agent: user_agent,
			height: height
		}

	end 

	def parse_timestamp(unix_ts) do 
		{:ok, ts} = DateTime.from_unix(unix_ts) 
		ts
	end 

	def parse_addr(bin) do 
		
		ipv4 = Base.encode16(bin) 
			|> String.starts_with?("0000000000")

		case ipv4 do 
			true -> bin_to_ipv4(bin)
			false -> bin_to_ipv6(bin)
		end
	end 

	def bin_to_ipv4(bin) do 
		String.slice(bin, -4..16) 
			|> :binary.bin_to_list() 
			|> Enum.join(".")

	end 

	def bin_to_ipv6(bin) do 
		l = for <<x::binary-2 <- bin>>, do: Base.encode16(x, case: :lower)
		Enum.join(l, ":")
	end 

#	def read_varint(b) do 
#		len = b |> Message.encode
#		case len do 

#			"ff" -> 8 
#			"fe" -> 4
#			"fd" -> 2
#			_ -> 1

#		end 
#	end 

end 