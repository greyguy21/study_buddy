class Wallpaper {
  late String name;
  late int price;
  late String imgPath;
  late String num;
  bool bought;
  bool inUse;

  Wallpaper(
      {required this.name,
      required this.price,
      required this.imgPath,
      required this.num,
      required this.bought,
      required this.inUse});
}
