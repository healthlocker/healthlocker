const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Tests that clicking on 'See more stories' from landing page navigates to Stories page
// Checks the '/posts' url and Stories title
nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pa3.center:nth-child(4) > a.pa0.fr:nth-child(3)')
// Ensure you change the name of the screenshot file to reflect the name of the test
// Make sure you're saving the screenshot in the correct folder for the project
// You should make sure the screenshots folder is in your gitignore so you're not pushing
// all of these screenshot images to github
  .screenshot('./test/acceptance_tests/screenshots/stories_page.png')
// Add .evaluate to return the information you need from the page as it currently stands
  .evaluate(function(){
    return [document.getElementsByTagName('h2')[0].innerHTML, window.location.href];
  })
  .end()
  // Alter the .then method to log what a passing test should look like and a failing test using if/else
    .then(function (result) {
      result[0] == 'Stories' && result[1] == 'https://www.healthlocker.uk/posts' ? console.log(`Test passed: /posts url and 'Stories' title located`) : console.log(`Test failed: url:${result[1]} and title:${result[0]} received`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
