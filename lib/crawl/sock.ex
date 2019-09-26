defmodule Sock do 

	require Socket 

	def connect(ip) do 

		v = "f9beb4d976657273696f6e0000000000650000005f1a69d2721101000100000000000000bc8f5e5400000000010000000000000000000000000000000000ffffc61b6409208d010000000000000000000000000000000000ffffcb0071c0208d128035cbc97953f80f2f5361746f7368693a302e392e332fcf05050001"
		{:ok, version} = Base.decode16(v, case: :lower)

		socket = Socket.connect!("tcp://" <> ip)
		
		socket |> Socket.Stream.send(version)

     	msg = socket |> Socket.Stream.recv
		
		socket |> Socket.Stream.close

		msg
	end 

end 
