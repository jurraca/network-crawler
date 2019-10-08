# Crawl

Elixir modules to interact with the Bitcoin peer network and retrieve data. WIP. Nowhere near ready to use. 

## Installation

[socket](https://hexdocs.pm/socket/api-reference.html) is the only dependency. 

Clone the repo, and launch with `iex -S mix`. 

`NetworkEnvelope.from_peer("x.x.x.x:8333")` will begin a handshake with a given peer, read their version message, and send a verack. 

Plenty TODO: 

- handle binary pattern matching better. 
- socket management is dismal. 
- extend crawler to retrieve peers and crawl adjoining peers in isolated, supervised processes. 

Not available in [Hex](https://hex.pm/docs/). 