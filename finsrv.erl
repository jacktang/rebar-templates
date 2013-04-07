-module({{name}}_srv).
-author('{{author_name}} <{{author_email}}>').

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).
-export([code_change/3]).
-export([stop/0, terminate/2]).

-define(SERVER, ?MODULE).

-spec start_link() -> {ok, Pid} | ignore | {error, Error}
  when
      Pid :: pid(),
      Error :: {already_started, Pid} | term().
start_link() ->
  % gen_server:start_link(?MODULE, [], []). % for unnamed gen_server
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

-spec stop() -> ok.
stop() ->
  gen_server:cast(?SERVER, stop).

init(State) ->
  process_flag(trap_exit, true),
  {ok, State}.

handle_call(Req, _From, State) ->
  lager:debug("Unhandled call ~p~n", [Req]),
  {reply, State}.

handle_cast(stop, State) ->
  {stop, normal, State};
handle_cast(Req, State) ->
  lager:debug("Unhandled cast: ~p~n", [Req]),
  {noreply, State}.

handle_info(Info, State) ->
  lager:debug("Unhandled info: ~p~n", [Info]),
  {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(normal, _State) ->
  ok;
terminate(shutdown, _State) ->
  ok;
terminate({shutdown, _Reason}, _State) ->
  ok;
terminate(_Reason, _State) ->
  ok.
