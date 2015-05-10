%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (C) {{copyright_year}}, {{copyright_owner}}
%%% @doc
%%%
%%% @end
%%% Created : {{now_ts}} by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('{{handlerid}}_eventsource').

-export([init/3]).
-export([info/3]).
-export([terminate/3]).

%%%===================================================================
%%% Cowboy callbacks
%%%===================================================================
init(_Transport, Req, []) ->
    Headers = [{<<"content-type">>, <<"text/event-stream">>}],
    {ok, Req2} = cowboy_req:chunked_reply(200, Headers, Req),
    erlang:send_after(1000, self(), {message, "Tick"}),
    {loop, Req2, undefined, 5000}.

info({message, Msg}, Req, State) ->
    ok = cowboy_req:chunk(["id: ", id(), "\ndata: ", Msg, "\n\n"], Req),
    erlang:send_after(1000, self(), {message, "Tick"}),
    {loop, Req, State}.

terminate(_Reason, _Req, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
id() ->
    {Mega, Sec, Micro} = erlang:now(),
    Id = (Mega * 1000000 + Sec) * 1000000 + Micro,
    integer_to_list(Id, 16).
