const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Tests that "Home" is the innerHTML for the third 'a' tag on the menu page
nightmare
.goto('https://www.healthlocker.uk/')
.click('i#open-nav')
.wait(1000) // https://github.com/dwyl/learn-daydream-and-nightmare/issues/5
.screenshot('./test/acceptance_tests/screenshots/menu_test.png')
.evaluate(function(){
  return document.getElementsByTagName('a')[2].innerHTML;
})
.end()
.then(function (result) {
  result == "Home" ? console.log(`Test passed: ${result} received`) : console.log(`Test failed: ${result} received, expected "Home"`);
})
.catch(function (error) {
  console.error('Menu Test Error:', error);
});
