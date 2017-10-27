-module({{name}}_gen_server_test).

-import({{name}}_gen_server,[init/1]).

-include_lib("eunit/include/eunit.hrl").

{{name}}_test_() ->
    {foreach,
     fun setup/0,
     fun cleanup/1,
     [fun hello/0]}.

hello() ->
    Reply = gen_server:call(test, {hello, <<"hi">>}),
    ?assertEqual(Reply, <<"That's what she said! hi">>).

setup() ->
    {ok, _} = gen_server:start({local, test}, {{name}}_gen_server, [], []).

cleanup(_) ->
    ok = gen_server:stop(test).
