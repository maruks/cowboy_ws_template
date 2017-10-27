-module({{name}}_ws_handler).

-export([init/2,websocket_init/1,websocket_handle/2,websocket_info/2,terminate/3]).

init(Req, _State) ->
    {cowboy_websocket, Req, initial_state}.

websocket_init(_State) ->
    erlang:start_timer(1000, self(), <<"Hello!">>),
    Server = {{name}}_sup:start_server(),
    {ok, Server}.

websocket_handle({text, Msg}, State) ->
    Reply = {{name}}_sup:hello(State, Msg),
    {reply, {text, Reply}, State};
websocket_handle(_Data, State) ->
    {ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
    erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, State};
websocket_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _, State) ->
    {{name}}_sup:stop_server(State),
    ok.
