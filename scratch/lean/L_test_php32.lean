import Mathlib
import PEqualNP.Defs

namespace PEqualNP.Outside.L_test_php32_aux

open PEqualNP.ProofComplexity

abbrev VV : Type := Fin 3 × Fin 2

def l0 : Clause VV := ({((0, 0), true), ((0, 1), true)} : Clause VV)

def l1 : Clause VV := ({((1, 0), true), ((1, 1), true)} : Clause VV)

def l2 : Clause VV := ({((2, 0), true), ((2, 1), true)} : Clause VV)

def l3 : Clause VV := ({((0, 0), false), ((1, 0), false)} : Clause VV)

def l4 : Clause VV := ({((0, 0), false), ((2, 0), false)} : Clause VV)

def l5 : Clause VV := ({((1, 0), false), ((2, 0), false)} : Clause VV)

def l6 : Clause VV := ({((0, 1), false), ((1, 1), false)} : Clause VV)

def l7 : Clause VV := ({((0, 1), false), ((2, 1), false)} : Clause VV)

def l8 : Clause VV := ({((1, 1), false), ((2, 1), false)} : Clause VV)

def l9 : Clause VV := ({((0, 0), false), ((1, 1), true)} : Clause VV)

def l10 : Clause VV := ({((0, 1), false), ((1, 0), true)} : Clause VV)

def l11 : Clause VV := ({((1, 0), false), ((2, 1), true)} : Clause VV)

def l12 : Clause VV := ({((0, 1), false), ((1, 0), false)} : Clause VV)

def l13 : Clause VV := ({((0, 1), false)} : Clause VV)

def l14 : Clause VV := ({((0, 0), false), ((2, 1), false)} : Clause VV)

def l15 : Clause VV := ({((0, 0), false), ((2, 1), true)} : Clause VV)

def l16 : Clause VV := ({((0, 0), true)} : Clause VV)

def l17 : Clause VV := ({((0, 0), false)} : Clause VV)

def l18 : Clause VV := (∅ : Clause VV)

def p0 : List (Clause VV) := [l0]

def p1 : List (Clause VV) := l1 :: p0

def p2 : List (Clause VV) := l2 :: p1

def p3 : List (Clause VV) := l3 :: p2

def p4 : List (Clause VV) := l4 :: p3

def p5 : List (Clause VV) := l5 :: p4

def p6 : List (Clause VV) := l6 :: p5

def p7 : List (Clause VV) := l7 :: p6

def p8 : List (Clause VV) := l8 :: p7

def p9 : List (Clause VV) := l9 :: p8

def p10 : List (Clause VV) := l10 :: p9

def p11 : List (Clause VV) := l11 :: p10

def p12 : List (Clause VV) := l12 :: p11

def p13 : List (Clause VV) := l13 :: p12

def p14 : List (Clause VV) := l14 :: p13

def p15 : List (Clause VV) := l15 :: p14

def p16 : List (Clause VV) := l16 :: p15

def p17 : List (Clause VV) := l17 :: p16

def p18 : List (Clause VV) := l18 :: p17

set_option maxRecDepth 100000 in
theorem d0 : IsDerivation (PHP 3 2) p0 :=
  IsDerivation.ax IsDerivation.nil (Set.mem_union_left _ ⟨0, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d1 : IsDerivation (PHP 3 2) p1 :=
  IsDerivation.ax d0 (Set.mem_union_left _ ⟨1, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d2 : IsDerivation (PHP 3 2) p2 :=
  IsDerivation.ax d1 (Set.mem_union_left _ ⟨2, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d3 : IsDerivation (PHP 3 2) p3 :=
  IsDerivation.ax d2 (Set.mem_union_right _ ⟨0, 1, 0, by decide, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d4 : IsDerivation (PHP 3 2) p4 :=
  IsDerivation.ax d3 (Set.mem_union_right _ ⟨0, 2, 0, by decide, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d5 : IsDerivation (PHP 3 2) p5 :=
  IsDerivation.ax d4 (Set.mem_union_right _ ⟨1, 2, 0, by decide, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d6 : IsDerivation (PHP 3 2) p6 :=
  IsDerivation.ax d5 (Set.mem_union_right _ ⟨0, 1, 1, by decide, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d7 : IsDerivation (PHP 3 2) p7 :=
  IsDerivation.ax d6 (Set.mem_union_right _ ⟨0, 2, 1, by decide, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d8 : IsDerivation (PHP 3 2) p8 :=
  IsDerivation.ax d7 (Set.mem_union_right _ ⟨1, 2, 1, by decide, by decide +kernel⟩)

set_option maxRecDepth 100000 in
theorem d9 : IsDerivation (PHP 3 2) p9 :=
  IsDerivation.res (C := l1) (D := l3) d8 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))))) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))) ⟨(1, 0), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d10 : IsDerivation (PHP 3 2) p10 :=
  IsDerivation.res (C := l1) (D := l6) d9 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))))))) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))) ⟨(1, 1), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d11 : IsDerivation (PHP 3 2) p11 :=
  IsDerivation.res (C := l2) (D := l5) d10 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))))))) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))) ⟨(2, 0), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d12 : IsDerivation (PHP 3 2) p12 :=
  IsDerivation.res (C := l11) (D := l7) d11 (List.Mem.head _) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))) ⟨(2, 1), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d13 : IsDerivation (PHP 3 2) p13 :=
  IsDerivation.res (C := l10) (D := l12) d12 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))) (List.Mem.head _) ⟨(1, 0), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d14 : IsDerivation (PHP 3 2) p14 :=
  IsDerivation.res (C := l9) (D := l8) d13 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))) ⟨(1, 1), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d15 : IsDerivation (PHP 3 2) p15 :=
  IsDerivation.res (C := l2) (D := l4) d14 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))))))))))) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))))))))) ⟨(2, 0), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d16 : IsDerivation (PHP 3 2) p16 :=
  IsDerivation.res (C := l0) (D := l13) d15 (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))))))))))))))) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))) ⟨(0, 1), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d17 : IsDerivation (PHP 3 2) p17 :=
  IsDerivation.res (C := l15) (D := l14) d16 (List.Mem.tail _ (List.Mem.head _)) (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))) ⟨(2, 1), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem d18 : IsDerivation (PHP 3 2) p18 :=
  IsDerivation.res (C := l16) (D := l17) d17 (List.Mem.tail _ (List.Mem.head _)) (List.Mem.head _) ⟨(0, 0), by decide +kernel, by decide +kernel, by decide +kernel⟩

set_option maxRecDepth 100000 in
theorem main_aux : ∃ π : List (PEqualNP.ProofComplexity.Clause (Fin 3 × Fin 2)), PEqualNP.ProofComplexity.IsRefutation (PEqualNP.ProofComplexity.PHP 3 2) π ∧ π.length ≤ 19 :=
  ⟨p18, ⟨d18, List.Mem.head _⟩, by decide +kernel⟩

end PEqualNP.Outside.L_test_php32_aux

theorem PEqualNP.Outside.L_test_php32 : ∃ π : List (PEqualNP.ProofComplexity.Clause (Fin 3 × Fin 2)), PEqualNP.ProofComplexity.IsRefutation (PEqualNP.ProofComplexity.PHP 3 2) π ∧ π.length ≤ 19 :=
  PEqualNP.Outside.L_test_php32_aux.main_aux
