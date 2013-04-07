-module({{name}}_sup).

-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  {ok, { {one_for_one, 5, 10}, []} }.
