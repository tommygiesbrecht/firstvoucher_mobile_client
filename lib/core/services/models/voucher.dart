class Voucher {
  String code;
  final int id;
  final String? orderNumber;
  final double price;
  final double remainingAmount;
  final int redeems;
  final String created;
  final bool locked;
  final String guid;
  final String validFrom;
  final String validTo;

  Voucher({
    required this.code,
    required this.id,
    required this.orderNumber,
    required this.price,
    required this.remainingAmount,
    required this.redeems,
    required this.created,
    required this.locked,
    required this.guid,
    required this.validFrom,
    required this.validTo,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      code: json['code'],
      id: json['id'],
      orderNumber: json['orderNumber'],
      price: json['price'],
      remainingAmount: json['remainingAmount'],
      redeems: json['redeems'],
      created: json['created'],
      locked: json['locked'],
      guid: json['guid'],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
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
      'created': created,
      'locked': locked,
      'guid': guid,
      'validFrom': validFrom,
      'validTo': validTo,
    };
  }

  bool isValid() {
    DateTime validFromDate = DateTime.parse(validFrom);
    DateTime validToDate = DateTime.parse(validTo);
    DateTime now = DateTime.now();
    return validFromDate.isBefore(now) && validToDate.isAfter(now);
  }

  bool isActive() {
    return isValid() && !this.locked && remainingAmount > 0;
  }
}
