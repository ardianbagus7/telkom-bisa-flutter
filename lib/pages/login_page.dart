part of '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  var respon;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      customFlushbar(
        context,
        msg: 'Data tidak boleh kosong',
      );
      return;
    }

    loading = true;
    setState(() {});

    String url = baseUrl + '/api/auth.php';

    Map<String, dynamic> body = {
      'login': 'true',
      'email': emailController.text.trim().toString(),
      'password': passwordController.text.toString(),
    };

    final response = await http.post(url, body: body);
    respon = response.body;
    print(respon);
    if (json.decode(respon)['status'] == true) {
      emailController.clear();
      passwordController.clear();

      userId = json.decode(respon)['userId'];
      imageUser = json.decode(respon)['foto'];
      namaUser = json.decode(respon)['nama'];
      emailUser = json.decode(respon)['email'];


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
          (route) => false);
      customFlushbar(
        context,
        color: mainColor,
        msg: json.decode(respon)['pesan'],
      );
    } else {
      customFlushbar(
        context,
        msg: json.decode(respon)['pesan'],
      );
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TELKOM BISA',
          style:
              TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        backgroundColor: Colors.white,
        shadowColor: backgroundColor,
      ),
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: mainPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: login,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                            (route) => false);
                      },
                      child: Center(
                          child: Text('Belum punya akun? Daftar sekarang!')),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
