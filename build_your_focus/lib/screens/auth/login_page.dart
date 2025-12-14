import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();

  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  bool _obsecure = true;
  bool _loading = false;

  void _toggleObsecure() {
    setState(() => _obsecure = !_obsecure);
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or password can not be empty.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _loading = true);

    final error = await _authService.login(email: email, password: password);

    if (!mounted) return;

    if (error != null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }


    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home_page',
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/opening_page',
                  (route) => false,
            );
          },
        ),
      ),
      backgroundColor: Colors.white,


      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60),

              // EMAIL
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.black, size: 25),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFB6B6B6), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // PASSWORD
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _controllerPassword,
                  obscureText: _obsecure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _loading ? null : _handleLogin(),
                  style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black, size: 25),
                    suffixIcon: _controllerPassword.text.isEmpty
                        ? null
                        : IconButton(
                      onPressed: _toggleObsecure,
                      icon: const Icon(Icons.remove_red_eye_outlined),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFB6B6B6), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      "Login",
                      style: GoogleFonts.montserrat(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up_page');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                    FocusScope.of(context).unfocus();
                    setState(() => _loading = true);

                    final error = await _authService.signInWithGoogle();

                    if (!mounted) return;

                    if (error != null) {
                      setState(() => _loading = false);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error)));
                      return;
                    }
                    Navigator.pushNamedAndRemoveUntil(context, '/home_page', (route) => false,);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Login using Google",
                        style: GoogleFonts.montserrat(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
