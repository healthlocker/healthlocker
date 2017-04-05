const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Tests that clicking on 'Read this story' on the homepage first story takes you to a /posts page
nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pa3.center:nth-child(4) > article.ph3:nth-child(2) > a.pa0.f5.f4-l.lh-copy:nth-child(5)')
  .screenshot('./test/acceptance_tests/screenshots/read_story_test.png')
  .evaluate(function(){
    let url = window.location.href;
    return url.match(/posts/g)
  })
  .end()
    .then(function (result) {
      result == 'posts' ? console.log(`Test passed: ${result} received in the page url`) : console.log(`Test failed: ${result} received, 'posts' not found in the page url`);
    })
    .catch(function (error) {
      console.error('First Story Test Error:', error);
    });
