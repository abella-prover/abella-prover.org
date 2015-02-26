sig stlc.

kind	tm, ty		type.

type 	arr 		ty -> ty -> ty.
type    b               ty.

type	app		tm -> tm -> tm.
type 	abs		ty -> (tm -> tm) -> tm.

type    ty              ty -> o.
type    tm              tm -> o.
