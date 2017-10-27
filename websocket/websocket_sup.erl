-module({{name}}_sup).
-behaviour(supervisor).

-export([start_link/0, start_server/0, stop_server/1, hello/2]).

-export([init/1]).

%% API.

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_server() ->
    Id = erlang:unique_integer(),
    Name = list_to_atom("id " ++ integer_to_list(Id)),
    {ok, _} = start_child(Name),
    Name.

stop_server(Name) ->
   supervisor:terminate_child(?MODULE, whereis(Name)).

hello(Name, Msg) ->
    gen_server:call(Name, {hello, Msg}).

%% supervisor.

init([]) ->
    SupFlags = #{strategy => simple_one_for_one,
                 intensity => 1,
                 period => 1},
    ChildSpecs = [#{id => {{name}}_gen_server,
                    start => {{{name}}_gen_server, start_link, []},
		    restart => transient}],
    {ok, {SupFlags, ChildSpecs}}.

start_child(Name) ->
    supervisor:start_child(?MODULE, [Name]).
