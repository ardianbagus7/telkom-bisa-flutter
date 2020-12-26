part of '../main.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key key,
    @required this.data,
  }) : super(key: key);

  final data;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController donasiController = TextEditingController();
  TextEditingController pesanController = TextEditingController();

  bool loading = false;
  var respon;

  void kirimDonasi() async {
    if (donasiController.text.isEmpty || pesanController.text.isEmpty) {
      customFlushbar(
        context,
        msg: 'Data tidak boleh kosong',
      );
      return;
    }

    Navigator.pop(context);
    loading = true;
    setState(() {});

    String url = baseUrl + '/api/galang-dana.php';

    Map<String, dynamic> body = {
      'donasi_id': widget.data['donasi_id'],
      'message': pesanController.text.toString(),
      'total': donasiController.text.toString(),
    };

    final response = await http.post(url, body: body);
    respon = response.body;

    if (json.decode(respon)['status'] == true) {
      pesanController.clear();
      donasiController.clear();
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
          'Galang Dana',
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: '${widget.data['donasi_id']}',
                        child: CachedImageCustom(
                          image: '$baseUrl/${widget.data['image']}',
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${widget.data['title']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    LinearPercentIndicator(
                      lineHeight: 5.0,
                      percent: (int.parse('${widget.data['total']}') /
                                  int.parse(
                                      '${widget.data['target_funding']}')) >
                              1.0
                          ? 1.0
                          : (int.parse('${widget.data['total']}') /
                              int.parse('${widget.data['target_funding']}')),
                      progressColor: mainColor,
                      backgroundColor: backgroundColor,
                      padding: EdgeInsets.all(0),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terkumpul',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Sisa hari',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          numberCurrency(int.parse('${widget.data['total']}')),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: mainColor),
                        ),
                        if (pastTime(DateFormat("yyyy-MM-dd")
                                .parse(widget.data['target_end'])) >=
                            0)
                          Text(
                            '${pastTime(DateFormat("yyyy-MM-dd").parse(widget.data['target_end']))}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (pastTime(DateFormat("yyyy-MM-dd")
                                .parse(widget.data['target_end'])) <
                            0)
                          Text(
                            'Habis',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0))),
                          builder: (context) => DonasiForm(
                            donasiController: donasiController,
                            pesanController: pesanController,
                            kirimDonasi: kirimDonasi,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Donasi Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      color: backgroundColor,
                      thickness: 1,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.data['description']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class DonasiForm extends StatelessWidget {
  const DonasiForm({
    Key key,
    @required this.donasiController,
    @required this.pesanController,
    @required this.kirimDonasi,
  }) : super(key: key);

  final TextEditingController donasiController;
  final TextEditingController pesanController;
  final Function kirimDonasi;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: mainPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Donasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: donasiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nominal',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: pesanController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pesan',
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: kirimDonasi,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Kirim Donasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
