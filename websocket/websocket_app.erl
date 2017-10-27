-module({{name}}_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
        {ok, PortNum} = application:get_env(port),
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, {{name}}, "index.html"}},
			{"/websocket", {{name}}_ws_handler, []},
			{"/static/[...]", cowboy_static, {priv_dir, {{name}}, "static"}}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, PortNum}],
				    #{env =>  #{dispatch => Dispatch}}),
        lager:info("Started on port ~p~n",[PortNum]),
	{{name}}_sup:start_link().

stop(_State) ->
	ok.
