part of '../main.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List> getData() async {
    try {
      final response = await http.get("$baseUrl/api/galang-dana.php");

      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return true;
      },
      child: Scaffold(
        drawer: NavDrawer(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Text('1'),
              onPressed: (){},
            ),
            SizedBox(width:10),
            FloatingActionButton(
              child: Text('2'),
              onPressed: (){},
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(
            'Telkom Bisa',
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.w800,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.white,
          shadowColor: backgroundColor,
          iconTheme: IconThemeData(color: mainColor),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.data == null)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gagal terhubung ke server',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Refresh',
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
                  );
                else
                  return ListGalangDana(data: snapshot.data);
            }
          },
        ),
      ),
    );
  }
}

class ListGalangDana extends StatelessWidget {
  const ListGalangDana({Key key, this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, i) {
        return GalangDanaWidget(
          data: data,
          i: i,
        );
      },
    );
  }
}

class GalangDanaWidget extends StatelessWidget {
  const GalangDanaWidget({
    Key key,
    @required this.data,
    @required this.i,
  }) : super(key: key);

  final data;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(data: data[i])),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            height: 150,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: '${data[i]['donasi_id']}',
                      child: CachedImageCustom(
                        image: '$baseUrl/${data[i]['image']}',
                        width: double.infinity,
                        height: 150,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data[i]['title']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      LinearPercentIndicator(
                        lineHeight: 3.0,
                        percent: (int.parse('${data[i]['total']}') /
                                    int.parse('${data[i]['target_funding']}')) >
                                1.0
                            ? 1.0
                            : (int.parse('${data[i]['total']}') /
                                int.parse('${data[i]['target_funding']}')),
                        progressColor: mainColor,
                        backgroundColor: backgroundColor,
                        padding: EdgeInsets.all(0),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terkumpul',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Sisa hari',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            numberCurrency(int.parse('${data[i]['total']}')),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: mainColor),
                          ),
                          if (pastTime(DateFormat("yyyy-MM-dd")
                                  .parse(data[i]['target_end'])) >=
                              0)
                            Text(
                              '${pastTime(DateFormat("yyyy-MM-dd").parse(data[i]['target_end']))}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (pastTime(DateFormat("yyyy-MM-dd")
                                  .parse(data[i]['target_end'])) <
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (i != data.length - 1)
          Container(
            color: Colors.white,
            padding: mainPadding,
            child: Divider(
              color: backgroundColor,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
