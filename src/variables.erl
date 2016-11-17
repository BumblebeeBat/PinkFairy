-module(variables).
-compile(export_all).
-record(vars, {
	  height,
	  previous_hash
	 }).
path(height) -> 0;
path(previous_hash) -> 1.
    
