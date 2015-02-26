module stlc.

ty b.
ty (arr T1 T2) :- ty T1, ty T2.

tm (app M1 M2) :- tm M1, tm M2.
tm (abs T R) :- ty T, pi x\ tm x => tm (R x).
