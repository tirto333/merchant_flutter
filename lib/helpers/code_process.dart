class CodeProcessing {
  String emailVerificationCode(nums) {
    List verifyNumbers = [];

    nums.forEach((element) {
      verifyNumbers.add(element.text);
    });

    return verifyNumbers.join("");
  }
}
