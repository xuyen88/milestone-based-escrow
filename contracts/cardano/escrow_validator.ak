// Aiken Smart Contract for Milestone Escrow
type Datum {
  assessor: Hash<Blake2b_224, VerificationKey>,
  developer: Hash<Blake2b_224, VerificationKey>,
  milestone_count: Int,
}

validator {
  fn approve(datum: Datum, _redeemer: Void, ctx: ScriptContext) -> Bool {
    // Điều kiện: Giao dịch phải được ký bởi Assessor
    let must_be_signed_by_assessor = 
      list.has(ctx.transaction.extra_signatories, datum.assessor)
      
    must_be_signed_by_assessor
  }
}
