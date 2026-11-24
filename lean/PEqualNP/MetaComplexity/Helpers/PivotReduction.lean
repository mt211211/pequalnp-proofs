import Mathlib

namespace PEqualNP.PivotReduction

theorem compress {Point Line : Type*} [DecidableEq Line]
    (I : Point → Line → Prop)
    (squareFree : ∀ p q a b, p ≠ q → a ≠ b →
      ¬ (I p a ∧ I p b ∧ I q a ∧ I q b))
    (W : Finset Line) :
    ∃ T : Finset Line, T ⊆ W ∧ T.card ≤ 3 ∧
      ∀ p, (∀ l ∈ T, I p l) ↔ (∀ l ∈ W, I p l) := by
  classical
  by_cases hd : ∃ a ∈ W, ∃ b ∈ W, a ≠ b
  · obtain ⟨a, ha, b, hb, hab⟩ := hd
    by_cases h : ∀ p, I p a → I p b → ∀ l ∈ W, I p l
    · refine ⟨{a,b}, ?_, ?_, ?_⟩
      · intro l hl
        simp only [Finset.mem_insert, Finset.mem_singleton] at hl
        rcases hl with rfl | rfl <;> assumption
      · have hcard := Finset.card_insert_le a ({b} : Finset Line)
        simp only [Finset.card_singleton] at hcard
        omega
      · intro p
        simp
        exact ⟨fun hp => h p hp.1 hp.2, fun hp => ⟨hp a ha, hp b hb⟩⟩
    · push Not at h
      obtain ⟨p, hpa, hpb, c, hc, hpc⟩ := h
      refine ⟨{a,b,c}, ?_, ?_, ?_⟩
      · intro l hl
        simp only [Finset.mem_insert, Finset.mem_singleton] at hl
        rcases hl with rfl | rfl | rfl <;> assumption
      · have h1 := Finset.card_insert_le a ({b,c} : Finset Line)
        have h2 := Finset.card_insert_le b ({c} : Finset Line)
        simp only [Finset.card_singleton] at h2
        omega
      · intro q
        simp
        constructor
        · rintro ⟨hqa,hqb,hqc⟩
          have he : p = q := by
            by_contra hne
            exact squareFree p q a b hne hab ⟨hpa,hpb,hqa,hqb⟩
          exact (hpc (he.symm ▸ hqc)).elim
        · exact fun hq => ⟨hq a ha, hq b hb, hq c hc⟩
  · refine ⟨W, fun _ hx => hx, ?_, fun _ => Iff.rfl⟩
    have h1 : W.card ≤ 1 := Finset.card_le_one.mpr (by
      intro a ha b hb
      by_contra hne
      exact hd ⟨a,ha,b,hb,hne⟩)
    omega

theorem reduceOutputs {Point Line Output : Type*} [DecidableEq Line]
    (I : Point → Line → Prop)
    (squareFree : ∀ p q a b, p ≠ q → a ≠ b →
      ¬ (I p a ∧ I p b ∧ I q a ∧ I q b))
    (W : Output → Finset Line) :
    ∃ T : Output → Finset Line,
      (∀ j, T j ⊆ W j ∧ (T j).card ≤ 3) ∧
      (∀ j p, (∃ l ∈ W j, ¬ I p l) ↔ ∃ l ∈ T j, ¬ I p l) ∧
      (∀ j (onPoint : Point → Prop),
        (∃ l ∈ T j, ∀ p, I p l → ¬ onPoint p) →
         ∃ l ∈ W j, ∀ p, I p l → ¬ onPoint p) := by
  classical
  choose T hsub hcard hcommon using fun j => compress I squareFree (W j)
  refine ⟨T, fun j => ⟨hsub j, hcard j⟩, ?_, ?_⟩
  · intro j p
    have h := not_congr (hcommon j p).symm
    push Not at h
    exact h
  · rintro j onPoint ⟨l, hl, h⟩
    exact ⟨l, hsub j hl, h⟩

end PEqualNP.PivotReduction
