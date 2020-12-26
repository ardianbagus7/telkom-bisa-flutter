part of '../main.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SafeArea(child: SizedBox(height: 20)),
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(
              '$baseUrl/$imageUser',
            ),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('$namaUser'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('$emailUser'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
