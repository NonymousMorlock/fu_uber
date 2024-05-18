import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:fu_uber/Core/Constants/colorConstants.dart';
import 'package:fu_uber/Core/ProviderModels/MapModel.dart';
import 'package:fu_uber/Core/ProviderModels/PermissionHandlerModel.dart';
import 'package:fu_uber/UI/views/MainScreen.dart';
import 'package:provider/provider.dart';

class LocationPermissionScreen extends StatefulWidget {
  static final String route = "locationScreen";

  @override
  _LocationPermissionScreenState createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController loadingController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    loadingController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween<double>(begin: 0, end: 40).animate(new CurvedAnimation(
        parent: loadingController, curve: Curves.easeInOutCirc));
    loadingController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        loadingController.forward(from: 0);
      }
    });
    loadingController.forward();
  }

  NavigatorState? currentNavigator;
  MapModel? mapModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentNavigator = Navigator.of(context);
    mapModel = context.read<MapModel>();
    mapModel?.addListener(() {
      if (!mapModel!.isInitialized && mapModel!.currentPosition != null) {
        mapModel!.initialize();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          currentNavigator?.pushReplacementNamed(MainScreen.route);
        });
      }
    });
  }

  @override
  void dispose() {
    loadingController.dispose();
    currentNavigator = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final permModel = Provider.of<PermissionHandlerModel>(context);
    // final mapModel = Provider.of<MapModel>(context);

    return Consumer<MapModel>(builder: (_, mapModel, __) {
      return Consumer<PermissionHandlerModel>(builder: (_, permModel, __) {
        return Material(
          child: Container(
            child: Stack(
              children: <Widget>[
                SpringEffect(),
                permModel.isLocationPerGiven
                    ? Align(
                        alignment: Alignment(0, 0.5),
                        child: permModel.isLocationSerGiven
                            ? Text("Fetching Location...")
                            : InkResponse(
                                onTap: () {
                                  permModel.requestLocationServiceToEnable();
                                  mapModel.randomMapZoom();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    color: ConstantColors.PrimaryColor,
                                    height: 40,
                                    width: double.infinity,
                                    child: Text(
                                      "Location Service Not Enabled",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: InkResponse(
                          onTap: () {
                            permModel.requestAppLocationPermission();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              color: ConstantColors.PrimaryColor,
                              height: 60,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                "Location Permission is Not Given",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        );
      });
    });
  }
}

class SpringEffect extends StatefulWidget {
  @override
  SpringState createState() => SpringState();
}

class SpringState extends State<SpringEffect> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller2;
  late Animation<double> animation;
  late SpringSimulation simulation;
  double _position = 0;

  @override
  void initState() {
    super.initState();
    simulation = SpringSimulation(
      SpringDescription(
        mass: 1.0,
        stiffness: 100.0,
        damping: 5.0,
      ),
      200.0,
      100.0,
      -2000.0,
    );

    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 70));
    animation = Tween(begin: 100.0, end: 200.0).animate(controller2)
      ..addListener(() {
        if (controller2.status == AnimationStatus.completed) {
          controller.forward(from: 0);
        }
        setState(() {
          _position = animation.value;
        });
      });

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addListener(() {
            if (controller.status == AnimationStatus.completed) {
              controller2.forward(from: 0);
            }
            setState(() {
              _position = simulation.x(controller.value);
            });
          });
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment(0, _position / 1000),
            child: Image.asset(
              "images/pickupIcon.png",
              width: 50,
            ),
          ),
        ],
      ),
    ));
  }
}
