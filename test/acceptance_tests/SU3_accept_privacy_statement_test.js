const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Homepage > Sign up > pw and security q > do not accept privacy statement - should receive 'must be accepted' error message

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(1)')
  .click('input#user_email')
  .type('input#user_email', 'test2@testing.com')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > div.br2.mv3.center:nth-child(3) > form:nth-child(1) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .click('input#user_terms_conditions')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l.mv2.mv3-m.mv4-l:nth-child(3) > form:nth-child(4) > div.tr:nth-child(7) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .screenshot('./test/acceptance_tests/screenshots/SU3_privacy_not_accepted.png')
  .evaluate(function(){
    return document.getElementsByTagName('span')[0].innerHTML;
  })
  .end()
    .then(function (result) {
      result == `must be accepted` ? console.log(`PASS: error message given for failing to accept privacy statement`) : console.log(`FAIL: did not correctly give error message for not agreeing to the privacy statement`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
