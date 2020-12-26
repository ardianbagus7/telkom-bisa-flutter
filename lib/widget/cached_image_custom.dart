part of '../main.dart';

class CachedImageCustom extends StatelessWidget {
  const CachedImageCustom({
    @required this.image,
    this.width = 50,
    this.height = 50,
    Key key,
  }) : super(key: key);

  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
            child: Icon(Icons.image, color: Theme.of(context).cardColor)),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
