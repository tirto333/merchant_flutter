class CustomDate {
  String dateParse(date) {
    var temp = date.split('/');
    return "${temp[2]}-${temp[1]}-${temp[0]}";
  }

  String backToFront(date) {
    var temp = DateTime.parse(date);
    return "${temp.day < 10 ? "0${temp.day}" : temp.day}/${temp.month < 10 ? "0${temp.month}" : temp.month}/${temp.year}";
  }
}
