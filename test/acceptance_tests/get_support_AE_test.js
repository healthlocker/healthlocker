const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })
const nhsLink = `http://www.nhs.uk/Service-Search/Accident-and-emergency-services/LocationSearch/428`
// Tests landing page to menu to get support to NHS A&E finder page
nightmare
  .goto('https://www.healthlocker.uk/')
  .click('i#open-nav')
  .click('nav#my-sidenav > a.mt3.mh5.mh6-m.mh7-l.hl-bg-pink.pv2.f3.white-80.db.hover-white:nth-child(6)')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > ul:nth-child(4) > li.mb3.ml3.mr5:nth-child(2) > a:nth-child(2)')
  .screenshot('./test/acceptance_tests/screenshots/NHS_AE_finder.png')
  .evaluate(function(){
    return window.location.href;
  })
  .end()
    .then(function (result) {
      result == nhsLink ? console.log(`PASS: navigated home > menu > get support > NHS A&E finder`) : console.log(`FAIL: finished at ${result}`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });

// Will not pass as looks at the wrong tab for screenshot and url
// https://github.com/dwyl/learn-daydream-and-nightmare/issues/6
