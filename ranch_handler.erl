%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (C) 2015, {{author_name}}
%%% @doc
%%%
%%% @end
%%% Created :  5 May 2015 by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('{{handler_name}}').

-behaviour(ranch_protocol).

%% API
-export([start_link/4]).

%% ranch_protocol callbacks
-export([init/4]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
start_link(Ref, Socket, Transport, Opts) ->
    Pid = spawn_link(?MODULE, init, [Ref, Socket, Transport, Opts]),
    {ok, Pid}.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init(Ref, Socket, Transport, _Opts = []) ->
    ok = ranch:accept_ack(Ref),
    loop(Socket, Transport).

%%%===================================================================
%%% Internal functions
%%%===================================================================
loop(Socket, Transport) ->
    case Transport:recv(Socket, 0, 5000) of
        {ok, Data} ->
            Transport:send(Socket, Data),
            loop(Socket, Transport);
        _ ->
            ok = Transport:close(Socket)
    end.
