// Mô phỏng Logic Escrow trên Cardano bằng Aiken
validator {
  fn escrow(datum: Datum, redeemer: Action, context: ScriptContext) -> Bool {
    let must_be_signed_by_assessor = 
        list.has(context.transaction.extra_signatories, datum.assessor)

    when redeemer is {
      Approve -> must_be_signed_by_assessor
      Cancel -> False // Chỉ Assessor mới có quyền hủy hoặc duyệt
    }
  }
}
