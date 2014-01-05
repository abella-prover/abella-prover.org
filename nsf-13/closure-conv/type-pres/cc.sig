sig cc.

kind nat type.
type z nat.
type s nat -> nat.

type is_nat nat -> o.

% constants
kind const type.
type s++ const.
type arity  const -> nat -> o.


% Lambda terms; we deal only with closed ones for now
kind tm type.

type cst  const -> tm.
type lnat nat -> tm.
type app  tm -> tm -> tm.
type abs  (tm -> tm) -> tm.

% term list
kind tm_list type.
type tl_nil tm_list.
type tl_cons tm -> tm_list -> tm_list.
type tl_member tm -> tm_list -> o.


% closure converted terms; only what we need for the simple lambda terms
% considered
kind ctm  type.

% for environments
type unit ctm.
type cross ctm -> ctm -> ctm.

type ccst    const -> ctm.
type clnat   nat -> ctm.
type c++     ctm -> ctm -> ctm.
type clet    ctm -> (ctm -> ctm) -> ctm.
type fst     ctm -> ctm.
type rst     ctm -> ctm.
type capp    ctm -> ctm -> ctm.
type cabs    (ctm -> ctm) -> ctm.
type cpair   ctm -> ctm -> ctm.
type cunpair ctm -> (ctm -> ctm -> ctm) -> ctm.


% for representing maps in closure conversion
kind map type.
type map tm -> ctm -> map.

% map list
kind map_list type.
type ml_nil map_list.
type ml_cons map -> map_list -> map_list.
type ml_member map -> map_list -> o.

% for creating a map needed in closure conversion
type mapvar tm_list -> ctm -> map_list -> o.

% forming the closure environment
type mapenv tm_list -> map_list -> ctm -> o.

% for finding free variables in an abstraction
type notfree tm -> o.
type fvars tm -> tm_list -> tm_list -> o.

% combining two lists; avoiding redundancy is not essential for correctness
type combine tm_list -> tm_list -> tm_list -> o.


% for getting variables bound externally
type extBndVars map_list -> tm_list -> o.

% for performing closure conversion; map is a mapping from free variables
% to environment variables and tm_list is the list of free variables
type cc tm -> ctm -> map_list -> tm_list -> o.

type cc' tm -> ctm -> o.

% for experiment
type term tm -> o.


% Types for lambda terms and closure converted terms.

kind ty type.

% Integer type.
type nat_t ty.
% Arrow type for lambda abstractions (in the lambda terms)
% and closures (in the closure converted terms).
type arr ty -> ty -> ty.
% "Real" arrow type for lambda abstractions in the closure converted terms.
type code ty -> ty -> ty.
% Product types
type unit_t ty.
type product ty -> ty -> ty.

%

% typing relation for lambda terms.
type of  tm -> ty -> o.
type of_const    const -> ty -> o.

% typing relation for closuere converted terms.
type cof  ctm -> ty -> o.
type cof_const 	 const -> ty -> o.
