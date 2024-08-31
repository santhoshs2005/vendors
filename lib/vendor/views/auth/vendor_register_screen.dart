import 'dart:typed_data';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app_only/vendor/controllers/vendor_register_controller.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VendorController _vendorController = VendorController();

  late String bussinessName;

  late String email;

  late String phoneNumber;

  late String taxnumber;

  late String countryValue;

  late String stateValue;

  late String cityValue;

  Uint8List? _image;

  SelectGalleryImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);

    setState(
      () {
        _image = im;
      },
    );
  }

  SelectCameraImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.camera);

    setState(
      () {
        _image = im;
      },
    );
  }

  String? _taxStaus;

  List<String> taxOptions = [
    'YES',
    'NO',
  ];

  _saveVendorDetail() async {
    EasyLoading.show(status: 'PLEASE WAIT');
    if (_formKey.currentState!.validate()) {
      await _vendorController.RegisterVendor(
              bussinessName,
              email,
              phoneNumber,
              countryValue,
              stateValue,
              cityValue,
              _taxStaus!,
              taxnumber,
              _image)
          .whenComplete(() {
        EasyLoading.dismiss();

        
      });
    } else {
      print('bad');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 247, 255, 2),
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              return FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 57, 214, 0),
                        Color.fromARGB(255, 52, 207, 228)
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _image != null
                                ? Image.memory(_image!)
                                : IconButton(
                                    onPressed: () {
                                      SelectGalleryImage();
                                    },
                                    icon: const Icon(CupertinoIcons.photo),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        bussinessName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please bussiness name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration:
                          const InputDecoration(labelText: 'Bussiness Name'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please email name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Email Address'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please phone number name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tax Registered?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              width: 100,
                              child: DropdownButtonFormField(
                                hint: const Text('Select'),
                                items: taxOptions.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _taxStaus = value;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (_taxStaus == 'YES')
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            taxnumber = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please tax number name must not be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration:
                              const InputDecoration(labelText: 'Tax number'),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        _saveVendorDetail();
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
