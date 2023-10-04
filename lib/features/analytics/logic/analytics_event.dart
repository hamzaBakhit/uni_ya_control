part of'analytics_bloc.dart';

class AnalyticsEvent {}
class GetOrders extends AnalyticsEvent{
  DateTime start,end;

  GetOrders({required this.start,required this.end});
}