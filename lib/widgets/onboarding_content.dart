// ignore_for_file: public_member_api_docs, sort_constructors_first
class OnBoardingPages {
  String name;
  String description;
  String imageUrl;
  OnBoardingPages({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

List<OnBoardingPages> content = [
  OnBoardingPages(
      name: "Fast Delivery",
      description: "Fast food delivery to your door",
      imageUrl: "img/screen1.png"),
  OnBoardingPages(
      name: "Safety",
      description: "Safety food delivery to your door",
      imageUrl: "img/screen2.png"),
  OnBoardingPages(
      name: "Quality",
      description: "Quality food delivery to your door",
      imageUrl: "img/screen3.png"),
];
