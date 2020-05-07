import 'package:puppeteer/puppeteer.dart';
import 'package:html/parser.dart';

class TestCase {
  String input;
  String output;

  TestCase({
    this.input,
    this.output,
  });
}

List<TestCase> extractTestCases(String body) {
  var document = parse(body);
  var answers = document.getElementsByClassName('file answer-view');
  var inputs = document.getElementsByClassName('file input-view');

  var tests = <TestCase>[];

  for (var i = 1; i < inputs.length; i++) {
    var input = inputs[i];
    var testInput = input.children[1].children[0].innerHtml;

    var answer = answers[i];
    var testOutput = answer.children[1].children[0].innerHtml;

    tests.add(TestCase(input: testInput, output: testOutput));
  }

  return tests;
}

Future<String> extractHtmlWithTestCases(String url) async {
  var browser = await puppeteer.launch(headless: false);
  var page = await browser.newPage();
  var viewport = DeviceViewport(width: 00, height: 300);
  await page.setViewport(viewport);
  var url = 'https://codeforces.com/problemset/submission/1/768328';
  var response = await page.goto(url, wait: Until.networkIdle);

  var selector =
      '#pageContent > div.tests-placeholder > div.click-to-view-tests-div.smaller > a';

  await page.click(selector);

  await Future.delayed(Duration(seconds: 3));

  var body = await page.content;

  return body;
}

int calculate() {
  return 42;
}
