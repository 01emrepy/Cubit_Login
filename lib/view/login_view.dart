import 'package:cubitlogin/cubit/login_cubit.dart';
import 'package:cubitlogin/service/login_service.dart';
import 'package:cubitlogin/view/login_detail_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final GlobalKey<FormState> formkey = GlobalKey();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final String baseUrl = 'https://reqres.in/api';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        EmailController,
        PasswordController,
        formkey,
        service: LoginService(Dio(BaseOptions(baseUrl: baseUrl))),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginComplete) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginDetailView()));
          }
        },
        builder: (context, state) {
          return buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold buildScaffold(BuildContext context, LoginState state) {
    return Scaffold(
      appBar: AppBar(
        leading: Visibility(
            visible: context.watch<LoginCubit>().isLoading,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator())),
        elevation: 0,
        backgroundColor: Colors.green.shade200,
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: Form(
        autovalidateMode: state is LoginValidateState
            ? (state.isValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled)
            : AutovalidateMode.disabled,
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: EmailController,
                  validator: (value) {
                    // add your custom validation here.
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length < 15) {
                      return 'Must be more than 15 charater';
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                TextFormField(
                  controller: PasswordController,
                  validator: (value) {
                    // add your custom validation here.
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length < 6) {
                      return 'Must be more than 5 charater';
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ElevatedButton(
                  onPressed: () {
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is LoginComplete) {
                          return Card(
                            child: Icon(Icons.check),
                          );
                        }
                        return ElevatedButton(
                          onPressed: context.watch<LoginCubit>().isLoading
                              ? null
                              : () {
                                  context.read<LoginCubit>().postUserModel();
                                },
                          child: Text('Save'),
                        );
                      },
                    );
                  },
                  child: Text("Save"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
