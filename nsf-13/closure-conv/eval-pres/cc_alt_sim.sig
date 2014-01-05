sig cc_alt_sim.

kind nat type.
type z nat.
type s nat -> nat.


% Lambda terms; we deal only with closed ones for now
kind tm type.

type lnat nat -> tm.
type s++  tm -> tm -> tm.
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

type clnat   nat -> ctm.
type c++     ctm -> ctm -> ctm.
type clet    ctm -> (ctm -> ctm) -> ctm.
type fst     ctm -> ctm.
type rst     ctm -> ctm.
type capp    ctm -> ctm -> ctm.
type cabs    (ctm -> ctm) -> ctm.
type cpair   ctm -> ctm -> ctm.
type cunpair ctm -> (ctm -> ctm -> ctm) -> ctm.

% term list
kind ctm_list type.
type ctl_nil ctm_list.
type ctl_cons ctm -> ctm_list -> ctm_list.
type ctl_member ctm -> ctm_list -> o.

% for representing maps in closure conversion
kind map type.
type map tm -> ctm -> map.

% map list
kind map_list type.
type ml_nil map_list.
type ml_cons map -> map_list -> map_list.
type ml_member map -> map_list -> o.

% for creating a map needed in closure conversion
type mapvar tm_list -> (ctm -> map_list) -> o.

% forming the closure environment
type mapenv tm_list -> map_list -> ctm -> o.

% for finding free variables in an abstraction
type notfree tm -> o.
type fvars tm -> tm_list -> tm_list -> o.

% combining two lists; avoiding redundancy is not essential for correctness
type combine tm_list -> tm_list -> tm_list -> o.


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



% evaluation of lambda terms
type eval tm -> tm -> o.

% evaluation of closure converted lambda terms
type evalcc  ctm -> ctm -> o.


% is a value
type val      tm  -> o.
type cval     ctm -> o.

% external function used to define builtins; should mean the same in 
% both source and target domains.
type addnum nat -> nat -> nat -> o.


% typing relation for lambda terms.
type of  tm -> ty -> o.

% typing relation for closuere converted terms.
type cof  ctm -> ty -> o.


% map for substitutions
kind smap       type.
kind smap_list  type.
type smap    tm -> tm -> smap.
type sml_nil    smap_list.
type sml_cons   smap -> smap_list -> smap_list.
type sml_member smap -> smap_list -> o.

kind cmap       type.
kind cmap_list  type.
type cmap    ctm -> ctm -> cmap.
type cml_nil    cmap_list.
type cml_cons   cmap -> cmap_list -> cmap_list.
type cml_member cmap -> cmap_list -> o.


type tm    tm -> o.
type ctm   ctm -> o.