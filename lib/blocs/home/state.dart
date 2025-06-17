import 'package:equatable/equatable.dart';
import 'package:training_request/models/home.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  List<Object> get props => [];
}

class HomeInitalStat extends HomeState {
  const HomeInitalStat();
  List<Object> get props => [];
}

class HomeLoadingStat extends HomeState {
  const HomeLoadingStat();
}

class HomeLoadedStat extends HomeState {
  final List<HomeModel> homeModel;
  const HomeLoadedStat({required this.homeModel});
  List<Object> get props => [];
}

class HomeErrorStat extends HomeState {
  HomeErrorStat();
  List<Object> get props => [];
}
