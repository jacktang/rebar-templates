%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{{author_email}}>
%%% @copyright (C) {{copyright_year}}, {{copyright_owner}}
%%% @doc
%%%
%%% @end
%%% Created : 28 Apr 2015 by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('{{handlerid}}_rest').

%%%===================================================================
%% API
%%%===================================================================

-export([]).

%% Cowboy REST handler callbacks
-export([init/2,
         allowed_methods/2,
         content_types_provided/2,
         content_types_accepted/2,
         resource_exists/2]).

%%%===================================================================
%%% API
%%%===================================================================


%%%===================================================================
%%% Cowboy REST handler callbacks
%%%===================================================================
init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

allowed_methods(Req, State) ->
    {[<<"GET">>, <<"POST">>], Req, State}.

content_types_provided(Req, State) ->
    {[
      {<<"text/html">>,        resource_to_html},
      {<<"application/json">>, resource_to_json},
      ], Req, State}.

content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"x-www-form-urlencoded">>, []}, create_resource}],
     Req, State}.

resource_exists(Req, _State) ->
    case cowboy_req:binding(id, Req) of
        undefined ->
            {true, Req, index};
        Id ->
            {true, Req, Id}
    end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
resource_to_html(Req, Paste) ->
    {"<html>BODY</html>", Req, Paste}.

resource_to_json(Req, index) ->
    {"{}", Req, index}.

create_resource(Req, State) ->
    Id = random:uniform(1024),
    {ok, [{<<"resource">>, Resource}], Req2} = cowboy_req:body_qs(Req),
    case cowboy_req:method(Req2) of
        <<"POST">> ->
            {{true, <<$/, Id/binary>>}, Req2, State};
        _ ->
            {true, Req2, State}
    end.
