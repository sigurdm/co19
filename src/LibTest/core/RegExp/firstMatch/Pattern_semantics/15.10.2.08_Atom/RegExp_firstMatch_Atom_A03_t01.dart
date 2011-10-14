/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion 15.10.2.8: Parentheses of the form ( Disjunction ) serve both to
 *            group the components of the Disjunction pattern together and to
 *            save the result of the match. The result can be used either in a
 *            backreference (\ followed by a nonzero decimal number), referenced
 *            in a replace String, or returned as part of a list from the
 *            regular expression matching internal procedure.
 * @description Checks that the contents of parentheses are correctly captured.
 * @3rdparty sputnik-v1:S15.10.2.8_A3_T1.js-S15.10.2.8_A3_T33.js
 * @author rodionov
 * @reviewer msyabro
 */
 

main() {
  check(@"([Jj]ava([Ss]cript)?)\sis\s(fun\w*)", "Learning javaScript is funny, really", 9, ["javaScript is funny", "javaScript", "Script", "funny"]);
  check(@"([Jj]ava([Ss]cript)?)\sis\s(fun\w*)", "Developing with Java is fun, try it", 16, ["Java is fun", "Java", "", "fun"]);
  checkNeg(@"([Jj]ava([Ss]cript)?)\sis\s(fun\w*)", "Developing with JavaScript is dangerous, do not try it without assistance");
  check(@"(abc)", "abc", 0, ["abc", "abc"]);
  check(@"a(bc)d(ef)g", "abcdefg", 0, ["abcdefg", "bc", "ef"]);
  check(@"(.{3})(.{4})", "abcdefgh", 0, ["abcdefg","abc","defg"]);
  check(@"(aa)bcd\1", "aabcdaabcd", 0, ["aabcdaa","aa"]);
  check(@"(aa).+\1", "aabcdaabcd", 0, ["aabcdaa","aa"]);
  check(@"(.{2}).+\1", "aabcdaabcd", 0, ["aabcdaa","aa"]);
  check(@"(\d{3})(\d{3})\1\2", "123456123456", 0, ["123456123456","123","456"]);
  check(@"a(..(..)..)", "abcdefgh", 0, ["abcdefg","bcdefg","de"]);
  check(@"(a(b(c)))(d(e(f)))", "xabcdefg", 1, ["abcdef","abc","bc","c","def","ef","f"]);
  check(@"(a(b(c)))(d(e(f)))\2\5", "xabcdefbcefg", 1, ["abcdefbcef","abc","bc","c","def","ef","f"]);
  check(@"a(.?)b\1c\1d\1", "abcd", 0, ["abcd", ""]);
  check(@"([\S]+([ \t]+[\S]+)*)[ \t]*=[ \t]*[\S]+", "Course_Creator = Test", 0, ["Course_Creator = Test", "Course_Creator", ""]);
  check(@"^(A)?(A.*)$", "AAA", 0, ["AAA", "A", "AA"]);
  check(@"^(A)?(A.*)$", "AA", 0, ["AA", "A", "A"]);
  check(@"^(A)?(A.*)$", "A", 0, ["A", "", "A"]);
  check(@"(A)?(A.*)", "zxcasd;fl\\  ^AAAaaAAaaaf;lrlrzs", 13, ["AAAaaAAaaaf;lrlrzs", "A", "AAaaAAaaaf;lrlrzs"]);
  check(@"(A)?(A.*)", "zxcasd;fl\\  ^AAaaAAaaaf;lrlrzs", 13, ["AAaaAAaaaf;lrlrzs", "A", "AaaAAaaaf;lrlrzs"]);
  check(@"(A)?(A.*)", "zxcasd;fl\\  ^AaaAAaaaf;lrlrzs", 13, ["AaaAAaaaf;lrlrzs", "", "AaaAAaaaf;lrlrzs"]);
  check(@"(a)?a", "a", 0, ["a", ""]);
  check(@"a|(b)", "a", 0, ["a", ""]);
  check(@"(a)?(a)", "a", 0, ["a", "", "a"]);
  check(@"^([a-z]+)*[a-z]$", "a", 0, ["a", ""]);
  check(@"^([a-z]+)*[a-z]$", "ab", 0, ["ab", "a"]);
  check(@"^([a-z]+)*[a-z]$", "abc", 0, ["abc", "ab"]);
  check(@"^(([a-z]+)*[a-z]\.)+[a-z]{2,}$", "www.netscape.com", 0, ["www.netscape.com", "netscape.", "netscap"]);
  check(@"^(([a-z]+)*([a-z])\.)+[a-z]{2,}$", "www.netscape.com", 0, ["www.netscape.com", "netscape.", "netscap", "e"]);
}

void check(String pattern, String str, int matchPos, List<String> expectedGroups) {
  RegExp re = new RegExp(pattern, false, false);
  Match fm = re.firstMatch(str);
  if(null == fm) {
    Expect.fail("\"$pattern\" !~ \"$str\"");
  }
  if(matchPos >= 0) {
    Expect.equals(matchPos, fm.start());
  }
  if(null != expectedGroups) {
    Expect.equals(expectedGroups.length, fm.groupCount() + 1);
    
    for(int i = 0; i <= fm.groupCount(); i++) {
      String expGr = expectedGroups[i];
      String actGr = fm.group(i);
      if(expGr != actGr) {
        Expect.fail("Mismatch at group $i: \"$expGr\" expected instead of \"$actGr\"");
      }
    }
  }
}

void checkNeg(String pattern, String str) {
  RegExp re = new RegExp(pattern, false, false);
  if(null != re.firstMatch(str)) {
    Expect.fail("\"$pattern\" ~ \"$str\"");
  }
}
