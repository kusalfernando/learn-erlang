% erlc road.erl
% erl -noshell -run road main road.txt

-module(road).

-compile(export_all).

main(File) ->
	{ok, Binary} = file:read_file(File),
	Values = parse_binary(Binary),
	io:format("~p~n", [optimal_path(Values)]),
	erlang:halt(0).

parse_binary(Binary) when is_binary(Binary) ->
	parse_binary(binary_to_list(Binary));
parse_binary(Input) when is_list(Input) ->
	Values = [list_to_integer(X) || X <- string:tokens(Input, "\n")],
	group_val(Values, []).

group_val([], Acc) ->
	lists:reverse(Acc);
group_val([A, B, X | T], Acc) ->
	group_val(T, [{A, B, X} | Acc]). 

shortest_step({A, B, X}, {{DistA, PathA}, {DistB, PathB}}) ->
	OperationA1 = {A + DistA, [{a, A} | PathA]},
	OperationA2 = {B + X + DistA, [{x, X}, {b, B} | PathA]},
	OperationB1 = {B + DistB, [{a, B} | PathB]},
	OperationB2 = {A + X + DistB, [{x, X}, {a, A} | PathB]},
	{erlang:min(OperationA1, OperationA2), erlang:min(OperationB1, OperationB2)}.

optimal_path(Values) ->
	{{_DistanceA, PathA}, {_DistanceB, PathB}}
		= lists:foldl(fun shortest_step/2, {{0, []}, {0, []}}, Values),
	if length(PathA) > length(PathB) ->
		   PathB;
		length(PathA) < length(PathB) ->
		   PathA
	end.

