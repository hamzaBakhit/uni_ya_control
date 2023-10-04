import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Meal extends Equatable {
  late String id;
  String title, description;
  String img;
  double price, rateScore;
  int rateCount,count;
  List<String> groups, additions;

  Meal({
    required this.title,
    required this.img,
    required this.price,    this.count = 1,

    this.rateCount = 0,
    this.rateScore = 0,
    this.description = '',
    required this.additions,
    required this.groups,
  }) {
    id = const Uuid().v4();
  }

  @override
  List<Object?> get props => [id, title, img, price,count];

  setTitle(value) => title = value;

  setImg(value) => img = value;

  setPrice(value) => price = value;

  setId(value) => id = value;

  setDescription(value) => description = value;

  setRateCount(value) => rateCount = value;

  setRateScore(value) => rateScore = value;
  setCount(value) => count = value;

  addGroup(value) => groups.add(value);
  removeGroup(value) => groups.remove(value);

  addAddition(value) => additions.add(value);
  removeAddition(value) => additions.remove(value);
}
