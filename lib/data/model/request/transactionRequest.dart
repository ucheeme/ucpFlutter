class TransactionRequest {
  String pageNumber;
  String pageSize;
  String month;
  String acctNumber;

  TransactionRequest(
      {required this.acctNumber,
      required this.month,
      required this.pageNumber,
      required this.pageSize});
}
