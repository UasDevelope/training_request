class AppImages {
  static get _basePath => "asset/image";
  static get logo => "logo".png;
  static get email => "email".png;
  static get password => "password".png;
  static get loginSucess => "loginSucess".png;
  static get person => "person".png;
  static get person1 => "person1".png;
  static get driving => "driving".png;
  static get profile => "profile".png;
  static get drive => "drive".png;
  static get mylocation => "mylocation".png;
  static get coin => "coin".png;
  static get time => "time".png;
  static get eye => "eye".png;
  static get location => "location".png;
  static get home => "home".png;
  static get calendar => "calendar".png;
  static get chat => "chat".png;
  static get setting => "setting".png;
  static get edit => "edit".png;
  static get search => "search".png;
  static get send => "send".png;
  static get editprofile => "editprofile".png;
  static get transaction => "transaction".png;
  static get tran => "tran".png;
  static get start => 'start'.png;
  static get end => "end".png;
}

extension ImagePathExtension on String {
  String get png => "asset/image/$this.png";
}
