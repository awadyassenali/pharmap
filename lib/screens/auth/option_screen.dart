import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmap/components/custom_button.dart';
import 'package:pharmap/components/custom_text_form_field.dart';
import 'package:pharmap/components/option_card.dart';
import 'package:pharmap/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:pharmap/services/database.dart';

enum ScreenState { choose, fillPharmacy }
enum PharmacyType { night, day }

class OptionScreen extends StatefulWidget {
  static final String id = '/OptionScreen';
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  ScreenState _screenState = ScreenState.choose;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String pharmacyCode;
  String pharmacyName;
  double pharmacyLongitude;
  double pharmacyLatitude;
  PharmacyType pharmacyType;

  void _handleSubmit() async {
    User user = Provider.of<User>(context, listen: false);
    _formKey.currentState.save();
    Database db = Database();
    await db.addPharmacyData(
        user.uid,
        pharmacyCode,
        pharmacyName,
        pharmacyLongitude,
        pharmacyLatitude,
        pharmacyType == PharmacyType.day ? 'day' : 'night');
    Navigator.pushReplacementNamed(context, '/WrapperScreen');
  }

  Widget _chooseWidget() {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 15.0,
          ),
          child: SizedBox(
            width: _size.width,
            height: _size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: OptionCard(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/WrapperScreen'),
                    label: 'CLIENT',
                    assetPath: "assets/Svg/client.svg",
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: OptionCard(
                    onTap: () =>
                        setState(() => _screenState = ScreenState.fillPharmacy),
                    label: 'PHARMACIST',
                    assetPath: "assets/Svg/pharmacist.svg",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fillPharmacyDataWidget() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fill your pharmacy\nData to get started',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withAlpha(40),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          autovalidate: false,
                          hintText: "Pharmacy Code",
                          onSaved: (String newValue) => pharmacyCode = newValue,
                        ),
                        CustomTextFormField(
                          autovalidate: false,
                          hintText: "Pharmacy Name",
                          onSaved: (String newValue) => pharmacyName = newValue,
                        ),
                        CustomTextFormField(
                          autovalidate: false,
                          hintText: "Pharmacy Longitude",
                          onSaved: (String newValue) =>
                              pharmacyLongitude = double.parse(newValue),
                        ),
                        CustomTextFormField(
                          autovalidate: false,
                          hintText: "Pharmacy Latitude",
                          onSaved: (String newValue) =>
                              pharmacyLatitude = double.parse(newValue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text('Pharmacy type'),
                  ListTile(
                    title: const Text('night'),
                    leading: Radio<PharmacyType>(
                      value: PharmacyType.night,
                      groupValue: pharmacyType,
                      onChanged: (PharmacyType value) {
                        setState(() {
                          pharmacyType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('day'),
                    leading: Radio<PharmacyType>(
                      value: PharmacyType.day,
                      groupValue: pharmacyType,
                      onChanged: (PharmacyType value) {
                        setState(() {
                          pharmacyType = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  CustomButton(
                    text: 'save data',
                    bgColor: primaryColor,
                    press: _handleSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_screenState == ScreenState.fillPharmacy) {
      return _fillPharmacyDataWidget();
    }
    return _chooseWidget();
  }
}
