import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_request/screens/home/tripCard.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/widgets/custom_button.dart';

import '../../blocs/home/bloc.dart';
import '../../blocs/home/event.dart';
import '../../blocs/home/state.dart';
import '../../core/app_routes.dart';

class HomeScreen extends StatefulWidget {
  final String endPoint;
  const HomeScreen({Key? key, required this.endPoint}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.3346, -121.8910),
    zoom: 14,
  );
  CameraPosition? _lastCameraPosition;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(HomeLoadedEvent(endPoint: widget.endPoint));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => current is HomeLoadedState,
        listener: (context, state) async {
          if (state is HomeLoadedState && _mapController != null) {
            if (_lastCameraPosition?.target != state.cameraPosition.target) {
              await _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(state.cameraPosition),
              );
              _lastCameraPosition = state.cameraPosition;
            }
          }
        },
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is HomePaymentProcessingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }
          if (state is HomePaymentSuccessState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
                  ),
                ],
              ),
            );
          }
          if (state is HomeLoadedState) {
            context.read<HomeBloc>().startLiveTracking();
            return Stack(
              children: [
                // Google Map
                Positioned.fill(
                  child: GoogleMap(
                    polylines: state.polyLines,
                    initialCameraPosition: _initialPosition,
                    zoomControlsEnabled: state.orders.isEmpty,
                    myLocationEnabled: true,
                    indoorViewEnabled: true,
                    markers: state.markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      context
                          .read<HomeBloc>()
                          .add(MapControllerInitialized(controller));
                    },
                  ),
                ),
                // Bottom Sheet
                Positioned(
                  bottom: 90,
                  left: 10,
                  right: 10,
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 350,
                      autoPlay: state.orders.length > 1,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: state.orders.map((data) {
                      return Builder(
                        builder: (BuildContext context) {
                          return TripCard(data: data);
                        },
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 60,
                  right: 60,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      borderRadius: 16,
                      backgroundColor: AppColor.appColor,
                      textColor: Colors.white,
                      text: "Chat with driver",
                      onPressed: () {
                        if (state.orders.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.orderChat,
                            arguments: {
                              'bookingId':
                                  state.orders[_currentIndex].bookingId,
                              'bookingTitle':
                                  'Booking ${state.orders[_currentIndex].bookingId.substring(state.orders[_currentIndex].bookingId.length - 5)}',
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }
}
