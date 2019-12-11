class DateHelper {

  static String timeLeft(DateTime time){
    if(time.isAfter(DateTime.now())){
      int diff =time.difference(DateTime.now()).inDays;
      if (diff == 0) {
        if(time.day != DateTime.now().day) return "Tomorrow";
        else if(time.hour - DateTime.now().hour < 5) return "In progress";
        return "Today";
      }
      if (diff == 1) return "Tomorrow";
      if (diff > 31) {
        double months = diff/30;
        return "${months.toInt()} months left";
      }
      return "${diff.toString()} days left";
    }
    return "Old event";
  }


}