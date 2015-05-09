%%%-------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (C) {{copyright_year}}, {{copyright_owner}}
%%% @doc
%%%
%%% @end
%%% Created :  {{now_ts}} by {{author_name}} <{{author_email}}>
%%%-------------------------------------------------------------------
-module('{{specid}}_espec').
-author('{{author_name}} <{{author_email}}>').


-include_lib("espec/include/espec.hrl").

spec() ->
    describe("{{description}}",
             fun() ->
                     % Run before each case
                     before_each(fun() ->
                                         spec_set(var1, "variable 1")
                                 end),
                     % Run after each case
                     after_each(fun() ->
                                        ok
                                end),

                     it("should do stuff",
                        fun() ->
                                Result = do_stuff(spec_get(var1)),
                                ?assertEqual(true, Result),
                                List = [a, b, c],
                                ?assertMatch([a, _, c], List)
                        end),

                     it("should be one sentence that describe the case")
         end).

do_stuff(_V) ->
    true.
