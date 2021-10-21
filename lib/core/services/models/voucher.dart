class Voucher {
  String code;
  final int id;
  final String? orderNumber;
  final double price;
  final double remainingAmount;
  final int redeems;
  final bool active;
  final String created;
  final bool locked;
  final String guid;

  Voucher({
    required this.code,
    required this.id,
    required this.orderNumber,
    required this.price,
    required this.remainingAmount,
    required this.redeems,
    required this.active,
    required this.created,
    required this.locked,
    required this.guid,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      code: json['code'],
      id: json['id'],
      orderNumber: json['orderNumber'],
      price: json['price'],
      remainingAmount: json['remainingAmount'],
      redeems: json['redeems'],
      active: json['active'],
      created: json['created'],
      locked: json['locked'],
      guid: json['guid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'id': id,
      'orderNumber': orderNumber,
      'price': price,
      'remainingAmount': remainingAmount,
      'redeems': redeems,
      'active': active,
      'created': created,
      'locked': locked,
      'guid': guid,
    };
  }

  bool isActive() {
    return this.active && !this.locked && remainingAmount > 0;
  }
}