defmodule Handshake do 
	use Task 
	require Socket 
	defstruct version: false, verack: false

	def start_link({address, port}) do 
		Task.start_link(__MODULE__, :stream, [{address, port}])
	end 

	def stream({address, port}) do 
		Stream.resource(

			fn -> connect({address, port}) end, 

			&handle_stream/1,

			fn socket -> Socket.Stream.close(socket) end
			)
	end 	

	def connect({address, port}) do 
		{:ok, socket} = Socket.TCP.connect({address, port})
		:ok = version_handshake(socket)
		socket
	end 

	def handle_stream(socket) do
		case Socket.Stream.recv(socket) do
			{:ok, msg} -> 
				{[parse(msg, socket)], socket} 
			
			nil -> handle_stream(socket)

		    {:error, msg} -> {:halt, socket}

      		_ -> handle_stream(socket)
		end  
	end  

	def parse(msg, socket) do 
		msg
		|> NetworkEnvelope.parse() 
		|> to_struct(socket) 
		#|> is_partial?()
	end 

	def version_handshake(socket) do 

		v = "f9beb4d976657273696f6e0000000000650000005f1a69d2721101000100000000000000bc8f5e5400000000010000000000000000000000000000000000ffffc61b6409208d010000000000000000000000000000000000ffffcb0071c0208d128035cbc97953f80f2f5361746f7368693a302e392e332fcf05050001"
		{:ok, version} = Base.decode16(v, case: :lower)	
		socket |> Socket.Stream.send(version)

    end

    def verack_handshake(socket) do 
       	v =  "F9BEB4D976657261636B000000000000000000005DF6E0E2" 
    	{:ok, verack} = Base.decode16(v)
    	socket |> Socket.Stream.send(verack)

    end

	def to_struct(%Message{command: "version"}, socket) do
		:ok = verack_handshake(socket)
		%Handshake{version: true}
	end 	

	def to_struct(%Message{command: "verack"}, _socket) do 
		%Handshake{verack: true} 
		IO.puts "Handshake complete? --> #{is_partial?()}"
	end

	def to_struct(%Message{command: "ping"}, _socket) do 
		IO.puts "Got ping."
	end 

	def to_struct(%Message{command: "alert"}, _socket) do 
		{:error, "alert"} 
	end 

	def is_partial?() do 
		%Handshake{}
		|> Map.values() 
		|> Enum.any?(fn x -> x == false end) || %Handshake{}
	end 

end 