import 'package:flutter/material.dart';

class MyAccountForm extends StatefulWidget {
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
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                ),
              ),
            ),

            Container(
              width: 250,
              child: TextFormField(
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
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
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