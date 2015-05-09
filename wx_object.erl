%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (C) 2015, {{author_name}}
%%% @doc
%%%
%%% @end
%%% Created : 28 Apr 2015 by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('wx_').

-behaviour(wx_object).
%%%===================================================================
%% API
%%%===================================================================

export([new/2]).
%%%===================================================================
%% Wx object callbacks
%%%===================================================================
-export([init/1,
         terminate/2,
         code_change/3,
         handle_info/2,
         handle_call/3,
         handle_cast/2,
         handle_event/2]).

-include_lib("wx/include/wx.hrl").

%%%===================================================================
%%% API
%%%===================================================================
new(Parent, Config) ->
    start(Config).

%%%===================================================================
%%% Wx object callbacks
%%%===================================================================
init(Config) ->
    wx:batch(fun() -> do_init(Config) end).

handle_event(Ev = #wx{}, State) ->
    lager:warning("Can't handle event: ~p", [Ev]),
    {noreply, State}.

handle_call(Req, _From, State) ->
    lager:warning("Can't handle request: ~p", [Req]),
    {reply, {error, invalid_req},State}.

handle_cast(Msg, State) ->
    lager:warning("Can't handle msg: ~p", [Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    lager:warning("Can't handle info: ~p", [Info]),
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
