-module(atlas_wm_ping).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) ->
    {ok, nostate}.

to_html(ReqData, Context) ->
    Result = io_lib:format("Result: ~p", [atlas:ping()]),
    {"<html><head><title>atlas</title></head><body>" ++ Result ++ "</body></html>", ReqData, Context}.
