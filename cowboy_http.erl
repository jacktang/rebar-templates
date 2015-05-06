%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (C) 2015, {{author_name}}
%%% @doc
%%%
%%% @end
%%% Created : 28 Apr 2015 by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('{{handlerid}}_http').

-export([init/2]).

%%%===================================================================
%%% Cowboy callbacks
%%%===================================================================
init(Req, Opts) ->
    Req2 = handle(Req),
    {ok, Req2, Opts}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
handle(Req) ->
    Method = cowboy_req:method(Req),
    #{echo := Echo} = cowboy_req:match_qs([echo], Req),
    echo(Method, Echo, Req).

echo(<<"GET">>, undefined, Req) ->
    cowboy_req:reply(400, [], <<"Missing echo parameter.">>, Req);
echo(<<"GET">>, Echo, Req) ->
    cowboy_req:reply(200, [
                           {<<"content-type">>, <<"text/plain; charset=utf-8">>}
                          ], Echo, Req);
echo(_, _, Req) ->
    % Method not allowed.
    cowboy_req:reply(405, Req).
