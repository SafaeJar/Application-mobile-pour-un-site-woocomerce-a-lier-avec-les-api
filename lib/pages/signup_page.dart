import 'package:flutter/material.dart';

import 'package:woocommerce/utils/validator_service.dart';

import '../../api_services.dart';
import '../../utils/ProgressHUD.dart';
import '../../utils/form_helper.dart';
import '../models/customer.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalkey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  @override
  void initState() {
    apiService = APIService();
    model = CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: const Text("Sign Up"),
      ),
      body: ProgressHUD(
        child: Form(
          key: globalkey,
          child: _formUI(),
        ),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("First Name"),
                FormHelper.textInput(
                  context,
                  model.firstName,
                  (value) => {
                    model.firstName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'please enter your first name';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("last name"),
                FormHelper.textInput(
                  context,
                  model.lastName,
                  (value) => {
                    model.lastName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'please enter your last name';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("email ID"),
                FormHelper.textInput(
                  context,
                  model.email,
                  (value) => {
                    model.email = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'please enter your email id';
                    }
                    if (value.isNotEmpty && !value.toString().isValidEmail()) {
                      return 'please enter valid email id';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("password"),
                FormHelper.textInput(
                  context,
                  model.password,
                  (value) => {
                    model.password = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'please enter your password';
                    }
                    return null;
                  },
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.4),
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: FormHelper.saveButton(
                    "Register",
                    () {
                      if (validateANDSave()) {
                        // ignore: avoid_print
                        print(model.toJson());
                        setState(() {
                          isApiCallProcess = true;
                        });
                        apiService.createCustomer(model).then(
                          (ret) {
                            setState(() {
                              isApiCallProcess = false;
                            });
                            if (ret) {
                              FormHelper.showMessage(
                                context,
                                "Woocommerce App",
                                "Registration Successfull",
                                "ok",
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            } else {
                              FormHelper.showMessage(
                                context,
                                "wooCommerce App",
                                "Email Id already registered",
                                "ok",
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateANDSave() {
    final form = globalkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
