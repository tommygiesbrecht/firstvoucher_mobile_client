class VoucherRedeem {
  final int voucherId;
  final int id;
  final double price;
  final String created;

  VoucherRedeem({
    required this.voucherId,
    required this.id,
    required this.price,
    required this.created,
  });

  factory VoucherRedeem.fromJson(Map<String, dynamic> json) {
    return VoucherRedeem(
      voucherId: json['voucherId'],
      id: json['id'],
      price: json['price'],
      created: json['created'],
    );
  }
}