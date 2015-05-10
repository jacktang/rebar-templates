%%%-------------------------------------------------------------------
%%% @author {{author_name}} <author_email>
%%% @copyright (C) {{copyright_year}}, {{copyright_owner}}
%%% @doc
%%%
%%% @end
%%% Created : {{now_ts}} by {{author_name}} <author_email>
%%%-------------------------------------------------------------------
-module('{{handlerid}}_websocket').

%%%===================================================================
%% API
%%%===================================================================

export([]).

%%%===================================================================
%% Cowboy websocket handler callbacks
%%%===================================================================
-export([init/2,
         websocket_handle/3,
         websocket_info/3]).
%%%===================================================================
%%% API
%%%===================================================================


%%%===================================================================
%%% Cowboy websocket handler callbacks
%%%===================================================================
init(Req, Opts) ->
    {cowboy_websocket, Req, Opts}.

websocket_handle(Data, Req, State) ->
    {reply, Data, Req, State};
websocket_handle(_Data, Req, State) ->
    {ok, Req, State}.

websocket_info(Data, Req, State) ->
    {reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
    {ok, Req, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
