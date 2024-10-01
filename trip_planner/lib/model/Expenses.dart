class Expenses {
  int expense_id;
  int amount;
  String expense_date;
  String notes;
  int trip_id;
  int user_id;

  Expenses(this.expense_id, this.amount, this.expense_date,
      this.notes, this.trip_id, this.user_id);

  Map<String, Object?> toMap() {
    return {
      'expense_id': expense_id,
      'amount': amount,
      'expense_date': expense_date,
      'notes': notes,
      'trip_id': trip_id,
      'user_id': user_id,
    };
  }
}
