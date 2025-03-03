class OwnedTicket {
  String ticketId;
  bool redeemable;

  OwnedTicket({
    required this.ticketId,
    this.redeemable = true,
  });

  OwnedTicket.fromMap(Map<String, dynamic> map)
      : ticketId = map["ticketId"],
        redeemable = map["redeemable"] ?? true;
}