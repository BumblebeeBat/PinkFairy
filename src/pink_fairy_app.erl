-module(pink_fairy_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ssl:start(),
    application:start(inets),
    pink_fairy_sup:start_link(constants:trie_size()).


%start() ->
%    application:ensure_all_started(pink_fairy).

stop(_State) ->
    ok.

    
