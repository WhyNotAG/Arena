


import '../../Map.dart';

class BookTime {
  int hour;
  int minute;
  int nano;
  int second;

  BookTime({this.hour, this.minute, this.nano, this.second});

  factory BookTime.fromJson(Map<String, dynamic> json) {
    return BookTime(
      hour: json["hour"] as int,
      minute: json["minute"] as int,
      nano: json["nano"] as int,
      second: json["second"] as int,
    );
  }
}

class Booking {
  String bookingFrom;
  String bookingTo;
  bool half;
  int id;
  double price;

  Booking({this.bookingFrom, this.bookingTo, this.half, this.id, this.price});

  factory Booking.fromJson(Map<String, dynamic> json){
    return Booking(
      bookingFrom: json["bookingFrom"],
      bookingTo: json["bookingTo"],
      half: json["half"] as bool,
      id: json["id"] as int,
      price: json["price"] as double,
    );
  }
}

class BookFresh {
  List<Booking> bookings;
  double amount;
  int id;
  String paymentId;
  String paymentUrl;
  Place place;
  Playground playground;
  String date;

  BookFresh({this.bookings, this.amount, this.id, this.paymentId,
      this.paymentUrl, this.place, this.playground, this.date});

  factory BookFresh.fromJson(Map<String, dynamic> json) {
    var list = json['booking'] as List;
    List<Booking> bk = list.map((i) => Booking.fromJson(i)).toList();
    return BookFresh(
      bookings: bk,
      amount: json["amount"] as double,
      id: json["id"] as int,
      paymentId: json["paymentId"] as String,
      paymentUrl: json["paymentUrl"] as String,
      place: Place.fromJson(json["place"]),
      playground: Playground.fromJson(json["playground"]),
      date: json["date"] as String
    );
  }
}