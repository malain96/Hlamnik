///Class used to filter items
class Filter {
  double quality;
  double rating;
  List<int> colorIdList;
  int categoryId;
  int seasonId;
  bool showOnlyIsBroken;

  Filter({
    this.quality = 0,
    this.rating = 0,
    this.colorIdList,
    this.categoryId,
    this.seasonId,
    this.showOnlyIsBroken = false,
  });
}
