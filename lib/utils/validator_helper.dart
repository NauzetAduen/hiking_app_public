class ValidatorHelper{

  static String emailValidator(String value) {
    if (value.isEmpty) return 'Please, write your email';

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String passwordValidator(String value) {
    if (value.isEmpty) return "Please, write your password";
    if (value.length <= 6) return "Passwords should be atleast 6";
    return null;
  }

  static String passwordRepeatedValidator(String value, String valueRepeated){
    if (value != valueRepeated) return "Passwords did not match!";
    return null;
  }

  static String eventNameValidator(String value){
    if (value.isEmpty) return "Please, add a name";
    return null;
  }
  static String eventDescriptionValidator(String value){
    if (value.isEmpty) return "Please add a description";
    return null;
  }
  static String eventDateValidator(String value){
    if (value.isEmpty) return "Please add a Date";
    return null;
  }
  static String eventTimeValidator(String value){
    if (value.isEmpty) return "Please add a Time";
    return null;
  }
  static String trailNameValidator(String value){
    if (value.isEmpty) return "Please add a name";
    return null;
  }
  static String trailDescriptionValidator(String value){
    if (value.isEmpty) return "Please add a description";
    return null;
  }

  static String trailDistanceValidator(String value){
    if (value.isEmpty) return "Create a trail";
    return null;
  }

  static String eventTrailNameValidator(String value){
    if (value.isEmpty) return "Pick a trail";
    return null;
  }

}