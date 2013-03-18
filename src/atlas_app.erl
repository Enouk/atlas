-module(atlas_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    case atlas_sup:start_link() of
        {ok, Pid} ->
            ok = riak_core:register([{vnode_module, atlas_vnode}]),
            
            ok = riak_core_ring_events:add_guarded_handler(atlas_ring_event_handler, []),
            ok = riak_core_node_watcher_events:add_guarded_handler(atlas_node_event_handler, []),
            ok = riak_core_node_watcher:service_up(atlas, self()),

            EntryRoute = {["atlas", "ping"], atlas_wm_ping, []},
            webmachine_router:add_route(EntryRoute),

            {ok, Pid};
        {error, Reason} ->
            {error, Reason}
    end.

stop(_State) ->
    ok.
