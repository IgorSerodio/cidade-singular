import 'package:dio/dio.dart';
import 'package:cidade_singular/app/models/ticket.dart';
import 'package:cidade_singular/app/services/dio_service.dart';

class TicketService {
  final DioService dioService;

  TicketService(this.dioService);

  Future<bool> create(Ticket ticket) async {
    try {
      var response = await dioService.dio.post(
        "/ticket",
        data: ticket.toMap(),
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> update(Ticket ticket) async {
    try {
      var response = await dioService.dio.put(
        "/ticket/${ticket.id}",
        data: ticket.toMap(),
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<List<Ticket>> getByCreator(String creatorId) async {
    try {
      var response = await dioService.dio.get(
        "/ticket/$creatorId",
      );

      if (response.data["error"] ?? true) {
        return [];
      }

      return (response.data["data"] as List)
          .map((ticket) => Ticket.fromMap(ticket))
          .toList();
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> delete(String id) async {
    try {
      var response = await dioService.dio.delete(
        "/ticket/$id",
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }
}
