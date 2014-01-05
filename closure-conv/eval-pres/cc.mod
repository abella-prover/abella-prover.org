module cc.


% Some generic predicates
tl_member X (tl_cons X L).
tl_member X (tl_cons Y L) :- tl_member X L.

ctl_member X (ctl_cons X L).
ctl_member X (ctl_cons Y L) :- ctl_member X L.

ml_member X (ml_cons X L).
ml_member X (ml_cons Y L) :- ml_member X L.

sml_member X (sml_cons X L).
sml_member X (sml_cons Y L) :- sml_member X L.

cml_member X (cml_cons X L).
cml_member X (cml_cons Y L) :- cml_member X L.


mapvar tl_nil (xenv\ ml_nil).
mapvar (tl_cons X L) 
       (xenv\ ml_cons (map X (fst xenv)) (Map (rst xenv))) :-
     mapvar L Map.

mapenv tl_nil _ unit.
mapenv (tl_cons X L) Map (cross M ML) :-
       ml_member (map X M) Map, mapenv L Map ML.

combine tl_nil Fvs2 Fvs2.
combine (tl_cons X Fvs1) Fvs2 Fvs :-
      tl_member X Fvs2, combine Fvs1 Fvs2 Fvs.
combine (tl_cons X Fvs1) Fvs2 (tl_cons X Fvs) :-
      combine Fvs1 Fvs2 Fvs.

% free variables in a term; second argument is the list of candidates
fvars X _ tl_nil :- notfree X.
fvars (lnat _) _ tl_nil.
fvars Y Vs (tl_cons Y tl_nil) :- tl_member Y Vs.
% fvars (s++ M1 M2) Vs CFvs :-
%    fvars M1 Vs Fvs1, fvars M2 Vs Fvs2, combine Fvs1 Fvs2 CFvs.
fvars (app M1 M2) Vs CFvs :-
   fvars M1 Vs Fvs1, fvars M2 Vs Fvs2, combine Fvs1 Fvs2 CFvs.
fvars (abs M) Vs Fvs :- pi y\ notfree y => fvars (M y) Vs Fvs.


cc X M Map FVs :- ml_member (map X M) Map.
cc (lnat N) (clnat N) Map FVs.
cc (abs M) (cpair (cabs x\ (clet (fst x)
				 (y\ (clet (rst x) xenv\ (P xenv y)))))
		  PE) Map FVs :-
   fvars (abs M) FVs NFVs,
   mapenv NFVs Map PE,
   mapvar NFVs NMap,
   (pi x\ pi y\ pi xenv\
	     cc (M x) (P xenv y) (ml_cons (map x y) (NMap xenv)) (tl_cons x NFVs)).
cc (app M1 M2) (cunpair CM1
			(f\ env\ (capp f (cross CM2 env)))) Map FVs :-
   cc M1 CM1 Map FVs, cc M2 CM2 Map FVs.
% cc (s++ M1 M2) (c++ CM1 CM2) Map FVs :- cc M1 CM1 Map FVs, cc M2 CM2 Map FVs.
cc' X M :- cc X M ml_nil tl_nil.



% call by value evaluation for ordinary lambda terms
eval (lnat X) (lnat X).
% eval (s++ M1 M2) (lnat N) :- eval M1 (lnat N1), eval M2 (lnat N2), addnum N1 N2 N.
% not defined if function part does not evaluate to an abstraction
eval (app M1 M2) V :- 
  eval M1 (abs F), eval M2 V2, eval (F V2) V.
eval (abs F) (abs F).



% call by value evaluation for closure converted lambda terms
evalcc unit unit.
evalcc (cross M ML) (cross M' ML') :-
    evalcc M M', evalcc ML ML'.
evalcc (clnat N) (clnat N).
% evalcc (c++ M1 M2) (clnat N) :- 
%   evalcc M1 (clnat N1), evalcc M2 (clnat N2), addnum N1 N2 N.
evalcc (clet M F) V :- evalcc M M', evalcc (F M') V.
evalcc (fst M) M' :- evalcc M (cross M' ML').
evalcc (rst M) ML' :- evalcc M (cross M' ML').
evalcc (capp M1 M2) V :-
  evalcc M1 (cabs F), evalcc M2 V2, evalcc (F V2) V.
evalcc (cabs F) (cabs F).
evalcc (cpair F E) (cpair F' E') :- evalcc F F', evalcc E E'.
% not defined if the function part does not evaluate to a closure
evalcc (cunpair PPE' B) M :- evalcc PPE' (cpair F E), evalcc (B F E) M.


% values
val (lnat N).
val (abs F).
  
cval unit.
cval (cross V1 V2) :- cval V1, cval V2.
cval (clnat Num).
cval (cabs F).
cval (cpair N1 N2) :- cval N1, cval N2.



% Definition of the typing relation for lambda terms.
of (lnat _) nat_t.
% of (s++ M N) nat_t :- of M nat_t, of N nat_t.
of (app M N) T :- of M (arr T1 T), of N T1.
of (abs M) (arr T1 T2) :- pi x\ of x T1 => of (M x) T2.


% Definition of the typing relation for closure converted terms.
cof (clnat _) nat_t.
% cof (c++ M N) T :- cof M nat_t, cof N nat_t.
cof (clet M1 M2) T :-
    cof M1 T1,
    (pi x\ cof x T1 => cof (M2 x) T).
cof unit unit_t.
cof (cross M1 M2) (product T1 T2) :- cof M1 T1, cof M2 T2.
cof (fst M) T1 :- cof M (product T1 T2).
cof (rst M) T2 :- cof M (product T1 T2).
cof (capp M N) T :- cof M (code T1 T), cof N T1.
cof (cabs M) (code T1 T2) :- pi x\ cof x T1 => cof (M x) T2.
cof (cpair P Q) (arr T1 T2) :-
    cof P (code (product T1 TL) T2),
    cof Q TL.
cof (cunpair P Q) T :-
    cof P (arr T1 T),
    (pi f\ pi env\ pi l\
	cof f (code (product T1 l) T) =>
	cof env l =>
	cof (Q f env) T).


% addition of natural numbers
% addnum z N N.
% addnum (s N1) N2 (s N3) :- addnum N1 N2 N3.
 
% term (app (app (abs x\ (abs y\ s++ x y)) (lnat (s z))) (lnat (s (s z)))).


tm (lnat N).
% tm (s++ M N) :- tm M, tm N.
tm (app M N) :- tm M, tm N.
tm (abs R) :- pi x\ tm x => tm (R x).

ctm unit.
ctm (clnat N).
% ctm (c++ M N) :- ctm M, ctm N.
ctm (clet M F) :- ctm M, pi x\ ctm x => ctm (F x).
ctm (fst M) :- ctm M.
ctm (rst M) :- ctm M.
ctm (cross M N) :- ctm M, ctm N.
ctm (capp M N) :- ctm M, ctm N.
ctm (cabs R) :- pi x\ ctm x => ctm (R x).
ctm (cpair F PE) :- ctm F, ctm PE.
ctm (cunpair P F) :- ctm P, pi f\ pi env\ ctm f => ctm env => ctm (F f env).