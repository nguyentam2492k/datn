import 'package:datn/api/api_service.dart';
import 'package:datn/model/login_model.dart';
import 'package:datn/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return LogInState();
  }
}

class LogInState extends State<LogIn> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _logInFormKey = GlobalKey<FormBuilderState>();

  late bool isShowPassword;
  late bool isApiCallProcess = false;

  late LoginRequestModel loginRequestModel;

  @override
  void initState() {
    super.initState();
    isShowPassword = false;
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        uiSetup(context),
        progressIndicator(),
      ],
    );
  }

  Widget uiSetup(BuildContext context) {

    return Scaffold (
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 80,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          'assets/images/uet.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 20,),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ĐẠI HỌC QUỐC GIA HÀ NỘI",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF040081),
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "TRƯỜNG ĐẠI HỌC CÔNG NGHỆ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "University of Engineering and Technology",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF040081),
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      "HỆ THỐNG HỖ TRỢ HÀNH CHÍNH MỘT CỬA",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  // height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.fromLTRB(35, 10, 20, 10),
                  color: Colors.transparent,
                  child: FormBuilder(
                    key: _logInFormKey,
                    child: AutofillGroup(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FormBuilderTextField(
                              name: 'username',
                              style: const TextStyle(fontSize: 15.5, color: Color(0xFF04006C),),
                              decoration: decoration("Tên đăng nhập", Icons.login),
                              autofillHints: const [AutofillHints.username],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nhập Tên đăng nhập";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20,),
                            FormBuilderTextField(
                              name: 'password',
                              style: const TextStyle(fontSize: 15.5, color: Color(0xFF04006C),),
                              obscureText: !isShowPassword,
                              decoration: decoration("Mật khẩu", Icons.lock_outlined, isPassword: true),
                              autofillHints: const [AutofillHints.password],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nhập Mật khẩu";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12,),
                            Transform.scale(
                              scale: 0.85,
                              child: FormBuilderCheckbox(
                                name: 'remember_account', 
                                title: const Text("Ghi nhớ đăng nhập", style: TextStyle(color: Color(0xFF04006C)),),
                                initialValue: true,
                                activeColor: const Color(0xFF04006C),
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                            const SizedBox(height: 12,),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF04007B),
                                  elevation: 0
                                ),
                                icon: const Icon(
                                  Icons.login,
                                  color: Colors.white,
                                ), 
                                label: const Text(
                                  "Đăng nhập",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: (){
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  if (_logInFormKey.currentState!.saveAndValidate()) {
                                    setState(() {
                                      isApiCallProcess = true;
                                    });
                                    loginRequestModel = LoginRequestModel(
                                      username: _logInFormKey.currentState!.fields['username']!.value, 
                                      password: _logInFormKey.currentState!.fields['password']!.value
                                    );

                                    APIService apiService = APIService();
                                    apiService.login(loginRequestModel).then((value) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      if (value.runtimeType == LoginResponseModel) {
                                        LoginResponseModel loginResponseData = value as LoginResponseModel;
                                        debugPrint(loginResponseData.accessToken);
                                        TextInput.finishAutofillContext();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                            return HomeScreen(loginResponseData: loginResponseData);
                                        })); 
                                        debugPrint(loginRequestModel.toString());
                                      } else {
                                        var errorMessage = value as String;
                                        var snackBar = SnackBar(content: 
                                          Text(errorMessage.replaceAll(RegExp('"'), '')),
                                          showCloseIcon: true,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    });
                                  }
                                }, 
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget progressIndicator() {
    return Visibility(
        visible: isApiCallProcess,
        child: Stack(
          children: [
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Center(child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator()
                ))
              )
            ),
          ],
        ),
      );
  }

  InputDecoration decoration(String labelText, IconData icon, {bool isPassword = false}){
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      filled: true,
      fillColor: Colors.white,
      label: Text(
        labelText,
        selectionColor: Colors.red,
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF04006C),
        fontSize: 15.5
      ),
      prefixIcon: Icon(icon),
      prefixIconColor: const Color(0xFF04006C),
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      suffixIconColor: const Color(0xFF04006C),
      suffixIconConstraints: const BoxConstraints(minWidth: 50),
      suffixIcon: isPassword 
        ? GestureDetector(
          child:  isShowPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
          onTap: (){
            setState(() {
              isShowPassword = !isShowPassword;
            });
          },
        )
        : null,
      errorStyle: const TextStyle(
        fontSize: 10,
        height: 0.3
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFF04006C),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFF04006C),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFF04006C),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xFF04006C),
        ),
      ),
    );
  }
}
