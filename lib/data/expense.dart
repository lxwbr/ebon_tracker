class Expense {
  final String name;
  final double price;
  final double quantity;
  final Units unit;
  final double discount;
  final String messageId;

  const Expense({
    required this.name,
    // Raw price per unit without any discount.
    required this.price,
    // Discount for this expense.
    required this.discount,
    required this.quantity,
    required this.unit,
    required this.messageId,
  });

  double total() =>
      double.parse((price * quantity + discount).toStringAsFixed(2));

  factory Expense.from(String messageId, String name, double total,
      double discount, Quantity quantity) {
    Expense expense = Expense(
        messageId: messageId,
        name: name,
        price: quantity.price,
        discount: discount,
        quantity: quantity.n,
        unit: quantity.unit);

    if (double.parse((expense.total() - expense.discount).toStringAsFixed(2)) !=
        total) {
      throw AssertionError(
          "Calculated total ${expense.total()}+${expense.discount.abs()} was not equal to expense total $total");
    }

    return expense;
  }

  @override
  String toString() {
    String q = quantity > 1.0 ? " x $quantity" : "";
    String d = discount < .0 ? " - ${discount.abs()}" : "";
    String t = q.isNotEmpty || d.isNotEmpty ? " = ${total()}" : "";

    return "$name: $price$q$d$t";
  }

  Map<String, dynamic> toMap(String messageId) {
    return {
      'messageId': messageId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'total': total(),
      'discount': discount,
      'unit': unit.toString()
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    late Units u;
    switch (map['unit']) {
      case "Units.none":
        u = Units.none;
        break;
      case "Units.kg":
        u = Units.kg;
        break;
      default:
        throw UnimplementedError();
    }
    return Expense(
      messageId: map['messageId'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0.0,
      discount: map['discount'] ?? 0.0,
      quantity: map['quantity'] ?? 0.0,
      unit: u,
    );
  }
}

enum Units {
  none,
  kg,
}

class Quantity {
  final double n;
  final Units unit;
  // Price per unit
  final double price;

  double total() => double.parse((price * n).toStringAsFixed(2));

  const Quantity({required this.n, required this.price, required this.unit});
}