-module(exceptions).

-compile(export_all).

%try Expr of
%	Pattern -> Expr1
%catch
%	Type:Exception -> Expr2
%after % this always gets executed
%	Expr3
%end

throws(F) ->
	try F() of
		_ -> ok
	catch
		Throw -> {throw, caught, Throw}
	end.

errors(F) ->
	try F() of
		_ -> ok
	catch
		error:Error -> {throw, caught, Error}
	end.

exits(F) ->
	try F() of
		_ -> ok
	catch
		exit:Reason -> {throw, caught, Reason}
	end.

sword(1) -> throw(slice);
sword(2) -> erlang:error(cut_arm);
sword(3) -> exit(cut_leg);
sword(4) -> throw(punch);
sword(5) -> exit(cross_bridge).

black_knight(Attack) when is_function(Attack, 0) ->
	try Attack() of
		_ -> "None shall pass"
	catch
		throw:slice -> "It is but a scratch.";
		error:cut_arm -> "I've had worse.";
		exit:cut_leg -> "Come on you pansy!";
		_:_ -> "Just a flesh wound"
	end.

talk() -> "blah blah".

catcher(X,Y) ->
	case catch X/Y of
		{'EXIT', {badarith, _}} -> "uh oh";
		N -> N
end.

one_or_two(1) -> return;
one_or_two(2) -> throw(return).
