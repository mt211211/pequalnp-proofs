import Mathlib
import PEqualNP.Defs

namespace PEqualNP.Outside.L_meta_16093_aux

open PEqualNP.CircuitLowerBounds PEqualNP.MetaComplexity

def C : Circuit :=
  { gates := [{ op := GateOp.or, inputs := [4, 5] }, { op := GateOp.or, inputs := [2, 3] },
      { op := GateOp.and, inputs := [2, 3] }, { op := GateOp.and, inputs := [6, 7] },
      { op := GateOp.and, inputs := [6, 8] }, { op := GateOp.or, inputs := [1, 9] },
      { op := GateOp.and, inputs := [0, 11] }, { op := GateOp.and, inputs := [1, 10] },
      { op := GateOp.or, inputs := [12, 13] }],
    output := 14 }

theorem fan : FanInTwo C := by
  intro g hg
  simp only [C, List.mem_cons, List.not_mem_nil, or_false] at hg
  rcases hg with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> simp

theorem ev : ∀ x : Fin 6 → Bool, C.eval (List.ofFn x) = Nat.testBit (3936938664 * 2 ^ 32 + 3936913544) (∑ i : Fin 6, if x i then 2 ^ (i : ℕ) else 0) := by
  decide +kernel

theorem sz : C.size ≤ 9 := by decide

end PEqualNP.Outside.L_meta_16093_aux
