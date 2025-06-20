import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/authentication/auth_bloc.dart';
import 'package:training_request/blocs/booking/bloc.dart';
import 'package:training_request/blocs/chat_user/bloc.dart';
import 'package:training_request/blocs/chat_user/event.dart';
import 'package:training_request/blocs/feedback/bloc.dart';
import 'package:training_request/blocs/home/bloc.dart';
import 'package:training_request/blocs/home/event.dart';
import 'package:training_request/blocs/inbox/bloc.dart';
import 'package:training_request/blocs/inbox/event.dart';
import 'package:training_request/blocs/location/bloc.dart';
import 'package:training_request/blocs/nav/bloc.dart';
import 'package:training_request/blocs/order/bloc.dart';
import 'package:training_request/blocs/order/event.dart';
import 'package:training_request/blocs/splash/splash_event.dart';
import 'package:training_request/repositories/CurrentLocationRepository.dart';
import 'package:training_request/repositories/auth_repository.dart';
import 'package:training_request/repositories/booking_repository.dart';
import 'package:training_request/repositories/feedback.dart';
import 'package:training_request/repositories/location_repository.dart';
import 'package:training_request/repositories/order_repo.dart';
import '../blocs/splash/splash_bloc.dart';
List<BlocProvider> getAppBlocProvider() {
  return [
    BlocProvider<SplashBloc>(
      create: (context) => SplashBloc()..add(checkAuthenticationStatus()),
    ),
    BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository())),
    BlocProvider<LocationBloc>(
      create:
          (_) =>
              LocationBloc(LocationRepository(), CurrentLocationRepository()),
    ),
    BlocProvider<NavBloc>(create: (_) => NavBloc()),
    BlocProvider<OrderBloc>(
      create: (_) => OrderBloc(orderRepository:OrderRepository())..add(OrderLoadedEvent()),
    ),
    BlocProvider<ChatUserBloc>(
      create: (_) => ChatUserBloc()..add(ChatUserLoadedEvent()),
    ),
    BlocProvider<ChatInboxBloc>(
      create: (_) => ChatInboxBloc()..add(ChatLoadedEvent()),
    ),
    BlocProvider<HomeBloc>(create: (_) => HomeBloc()..add(HomeLoadedEvent())),
    BlocProvider<BookingBloc>(
      create:
          (_) => BookingBloc(BookingRepository(), CurrentLocationRepository()),
    ),
    BlocProvider<FeedbackBloc>(
      create: (_) => FeedbackBloc(FeedbackRepository()),
    ),
  ];
}
