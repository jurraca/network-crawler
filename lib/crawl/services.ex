defmodule Services do
	defstruct node_network: "",
		node_getutxo: "", 
		node_bloom: "", 
		node_witness: "", 
		node_network_limited: ""

	def parse(int) do 
		Integer.to_string(int, 2) 
		|> (fn b -> for <<x::binary-1 <- b>>, do: x == "1" end).()
		|> Enum.reverse 
		|> build_struct
	end 

	def build_struct(list) do 
		%Services{
			node_network: Enum.at(list, 0),
			node_getutxo: Enum.at(list, 1), 
			node_bloom: Enum.at(list, 2), 
			node_witness: Enum.at(list, 3), 
			node_network_limited: Enum.at(list, 10)

		}
	end 

end