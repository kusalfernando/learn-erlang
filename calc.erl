-module(calc).

-compile(export_all).

-spec rpn(RPN) -> integer() | float() when
	  RPN :: list().
%% parses an RPN string and outputs the results. 
rpn(Rpn) when is_list(Rpn) ->
	[Res] = lists:foldl(fun rpn/2, [], string:tokens(Rpn, " ")),
	Res.

rpn("+", [E1, E2 | T]) ->
	[E1 + E2 | T];
rpn("-", [E1, E2 | T]) ->
	[E1 - E2 | T];
rpn("*", [E1, E2 | T]) ->
	[E1 * E2 | T];
rpn("/", [E1, E2 | T]) ->
	[E1 / E2 | T];
rpn(X, Acc) ->
	[read(X) | Acc].

read(X) ->
	case string:to_float(X) of
		{error, no_float} ->
			list_to_integer(X);
		{F, _} ->
			F
	end.
