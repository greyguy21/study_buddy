class Wallpaper {
  late String name;
  late int price;
  late String imgPath;
  late String num;
  bool bought = false;
  bool inUse = false;

  Wallpaper(
      {required this.name,
      required this.price,
      required this.imgPath,
      required this.num,
      required bought,
      required this.inUse});
}
