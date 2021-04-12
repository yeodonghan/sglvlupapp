import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/shared/User.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MyAccountForm extends StatefulWidget {
  UserProfile user;

  MyAccountForm(UserProfile user) {
    this.user = user;
  }


  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyAccountForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String apiUrl = "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.user.user_name;
    mobileController.text = widget.user.user_mobile;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),
            ),

            Container(
              width: 250,
              child: TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (!(value.length == 8 || value.length == 0)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
              ),
            ),

            Container(
              width: 250,
              child: TextFormField(
                enabled: false,
                initialValue: widget.user.user_email,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  SoundsHandler().playTap();

                  void updateProfile() async {
                    http.Response res = await http.put(apiUrl + "/api/user/users/",
                        body: {
                          "user_name" : "${nameController.text}",
                          "user_mobile" : "${mobileController.text}",
                          "user_email" : "${widget.user.user_email}",
                        });
                  }
                  updateProfile();
                  widget.user.updateProfile(nameController.text, mobileController.text);


                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Updating Profile')));
                  }
                },
                child: Text('Update'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFC823),
                ),
              ),
            ),
          ],
        ),
      );


  }
}