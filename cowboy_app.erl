%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (C) {{copyright_year}}, {{copyright_owner}}
%%% @doc
%%%
%%% @end
%%% Created :  5 May 2015 by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('{{appid}}_app').

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @spec start(StartType, StartArgs) -> {ok, Pid} |
%%                                      {ok, Pid, State} |
%%                                      {error, Reason}
%%      StartType = normal | {takeover, Node} | {failover, Node}
%%      StartArgs = term()
%% @end
%%--------------------------------------------------------------------
start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile(
                 [
                  {'_', [
                         % http and rest handler
                         {"/", '{{handlerid}}_{{handlertype}}', []},

                         % websocket and eventsource
                         {"/eventsource", '{{handlerid}}_{{handlertype}}', []},
                         {"/", cowboy_static, {priv_file, {{appid}}, "index.html"}},
                         {"/static/[...]", cowboy_static, {priv_dir, {{appid}}, "static"}}
                        ]}
                 ]),
    Port      = application:get_env('{{appid}}', listen_port, 9000),
    Acceptors = application:get_env('{{appid}}', acceptor_num, 100),

    {ok, _} = cowboy:start_http(http, Acceptors, [{port, Port}],
                                [
                                 {env, [{dispatch, Dispatch}]}
                                ]),

    case '{{appid}}_sup':start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @spec stop(State) -> void()
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
