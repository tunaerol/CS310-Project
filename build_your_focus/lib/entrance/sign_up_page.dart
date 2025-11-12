import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.black,size: 28,), onPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('/opening_page'));
        },),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 50.0, left: 50.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("Sign Up",style: GoogleFonts.montserrat(fontSize: 28 ,fontWeight: FontWeight.w800),)
              ],
            ),
            SizedBox(height: 60),

            Container(
              height: 50 ,
              decoration: BoxDecoration(
                color: Colors.white,
              ),


              child: TextField(
                style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w600),
                maxLines:1,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w600),
                  prefixIcon: Icon(Icons.person_outline,color: Colors.black, size:25 ,),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Color(0xFFB6B6B6),width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black,width: 2),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),



            Container(
              height: 50 ,
              decoration: BoxDecoration(
                color: Colors.white,
              ),



              child: TextField(
                style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w600),
                maxLines:1,
                decoration: InputDecoration(
                  labelText: "Email address",
                  labelStyle: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w600),
                  prefixIcon: Icon(Icons.local_post_office_outlined,color: Colors.black, size:25 ,),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Color(0xFFB6B6B6),width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black,width: 2),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Container(
              height: 50 ,
              decoration: BoxDecoration(
                color: Colors.white,
              ),



              child: TextField(
                style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w600),
                maxLines:1,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w600),
                  prefixIcon: Icon(Icons.lock_outline,color: Colors.black, size:25 ,),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Color(0xFFB6B6B6),width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black,width: 2),
                  ),
                ),
              ),
            ),


            SizedBox(height: 80),


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
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_page');// It will activated after firebase, it will open homepage for now
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.montserrat(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height:50),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: GoogleFonts.montserrat(fontSize:13, fontWeight: FontWeight.w400 ,color: Colors.black),),
                  TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/login_page');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("Login",style: GoogleFonts.montserrat(fontSize:13, fontWeight: FontWeight.w700 ,color: Colors.black),)
                  )
                ],
              ),
            ),
            SizedBox(height: 50,),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {}, // it will open google account page in the phone after fire base integration
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
                    SizedBox(width: 12),
                    Text(
                      "Sign Up using Google",
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

          ],
        ),
      ),
    );
  }
}
