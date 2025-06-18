import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_request/screens/home/tripCard.dart';

import '../../blocs/home/bloc.dart';
import '../../blocs/home/state.dart';
import '../../utils/const/app_color.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.3346, -121.8910),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoadedState) {
            return Stack(
              children: [
                // Google Map
                Positioned.fill(
                  child: GoogleMap(
                    polylines: state.polyLines,
                    initialCameraPosition: _initialPosition,
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,
                    markers: state.marker,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),

                // Top Bar
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder:
                            (context) => Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.menu),
                                onPressed:
                                    () => Scaffold.of(context).openDrawer(),
                                color: Colors.black,
                              ),
                            ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "\$0",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                //  Bottom Sheet
                Positioned(
                  bottom: 90,
                  left: 10,
                  right: 10,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 350, // Adjust based on card size
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal,
                    ),
                    items:
                        state.homeModel.map((data) {
                          return Builder(
                            builder: (BuildContext context) {
                              return TripCard(
                                data: data,
                              ); // Your custom trip card widget
                            },
                          );
                        }).toList(),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 60,
                  right: 60,
                  child: AppButton(
                    backgroundColor: AppColor.appColor,
                    width: 200,
                    text: "Accept job",
                    onPressed: () {},
                  ),
                ),
              ],
            );
          }
          return Center(child: Text("Ok doing"));
        },
      ),
    );
  }
}
