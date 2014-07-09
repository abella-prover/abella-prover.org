%% Typed Closure Conversion

sig cc.

kind nat type.
type z nat.
type s nat -> nat.

type is_nat nat -> o.

% Constants
kind const type.
type s++ const.

% Source terms
kind tm type.

type cst  const -> tm.
type lnat nat -> tm.
type app  tm -> tm -> tm.
type abs  (tm -> tm) -> tm.

% Source term list
kind tm_list type.
type tl_nil tm_list.
type tl_cons tm -> tm_list -> tm_list.
type tl_member tm -> tm_list -> o.


% Target terms
kind ctm  type.

type unit ctm.
type cross ctm -> ctm -> ctm.
type ccst    const -> ctm.
type clnat   nat -> ctm.
type clet    ctm -> (ctm -> ctm) -> ctm.
type fst     ctm -> ctm.
type rst     ctm -> ctm.
type capp    ctm -> ctm -> ctm.
type cabs    (ctm -> ctm) -> ctm.
type cpair   ctm -> ctm -> ctm.
type cunpair ctm -> (ctm -> ctm -> ctm) -> ctm.


% Mapping from source variables to target terms
kind map type.
type map tm -> ctm -> map.

% Mapping list
kind map_list type.
type ml_nil map_list.
type ml_cons map -> map_list -> map_list.
type ml_member map -> map_list -> o.

% Creating mapping from free variables to projections to
% the environment variable
type mapvar tm_list -> (ctm -> map_list) -> o.

% Creating an environment of tuple from free variables and a mapping
type mapenv tm_list -> map_list -> ctm -> o.

% Finding free variables in a term
type notfree tm -> o.
type fvars tm -> tm_list -> tm_list -> o.

% Union of two lists
type combine tm_list -> tm_list -> tm_list -> o.

% Closure conversion
type cc tm -> ctm -> map_list -> tm_list -> o.
type cc' tm -> ctm -> o.

% Source terms for testing
type term tm -> o.

% Types for the source and target languages
kind ty type.

% Integer type.
type nat_t ty.
% Arrow type. For abstractions in the source language
% and closures in the target language
type arr ty -> ty -> ty.
% Type for abstractions in the target language
type code ty -> ty -> ty.
% Product types
type unit_t ty.
type product ty -> ty -> ty.


% Typing relation for the source language
type of  tm -> ty -> o.
type of_const    const -> ty -> o.

% Typing relation for the target language
type cof  ctm -> ty -> o.
type cof_const 	 const -> ty -> o.
