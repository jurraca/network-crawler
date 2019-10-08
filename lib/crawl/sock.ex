defmodule Sock do 

	require Socket 

	def connect(ip) do 

		addr = "tcp://" <> ip
		peer = Socket.connect!(addr) 

		local = Socket.listen!("tcp://*:0")

		conn = Socket.accept!(local)
		
		:ok = version_handshake(peer) 

		conn 
		
	end 

	def version_handshake(socket) do 

		#Socket.Stream.file(socket, "stream.txt")

		v = "f9beb4d976657273696f6e0000000000650000005f1a69d2721101000100000000000000bc8f5e5400000000010000000000000000000000000000000000ffffc61b6409208d010000000000000000000000000000000000ffffcb0071c0208d128035cbc97953f80f2f5361746f7368693a302e392e332fcf05050001"
		{:ok, version} = Base.decode16(v, case: :lower)
		
		socket |> Socket.Stream.send(version)
    end 

    def read(socket) do 

		Socket.Stream.recv!(socket)
		
    end

    def verack_handshake(socket) do 
       	v =  "F9BEB4D976657261636B000000000000000000005DF6E0E2" 
    	{:ok, verack} = Base.decode16(v)
    	socket |> Socket.Stream.send(verack)

    end

    def close(socket) do 
    	Socket.Stream.close(socket) 
    end 

end 
