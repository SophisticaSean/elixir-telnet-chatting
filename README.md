# This is a small PoC telnet chat server in Elixir with 1 whole chatroom!
start with `iex -S mix`

# Example
## Client 1
```
➜  ~ telnet localhost 4040
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
hello
i am here
you say: i am here
#PID<0.148.0> says: i am here
#PID<0.148.0> says: how is your wife steve?
she's great Tim, thank you
you say: she's great Tim, thank you
#PID<0.148.0> says: of course man glad to hear it
#PID<0.148.0> says: also what are you doing this weekend?
```

## Client 2
```
➜  ~ telnet localhost 4040
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
hello
i am here
you say: i am here
how is your wife steve?
you say: how is your wife steve?
#PID<0.147.0> says: she's great Tim, thank you
of course man glad to hear it
you say: of course man glad to hear it
also what are you doing this weekend?
you say: also what are you doing this weekend?
```