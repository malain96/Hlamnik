///Class used to filter items
class Filter {
  double quality;
  double rating;
  List<int> colorIdList;
  int categoryId;
  int seasonId;

  Filter({
    this.quality = 0,
    this.rating = 0,
    this.colorIdList,
    this.categoryId,
    this.seasonId,
  });
}
