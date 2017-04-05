const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Homepage > Sign up > do not choose security answer - should receive 'can't be blank' error message

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(1)')
  .click('input#user_email')
  .type('input#user_email', 'test@testing.com')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > div.br2.mv3.center:nth-child(3) > form:nth-child(1) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .click('input#user_password')
  .type('input#user_password', '123456')
  .click('input#user_password_confirmation')
  .type('input#user_password_confirmation', '123456')
  .click('select#user_security_question')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > form:nth-child(2) > div.form-group:nth-child(7)')
//  Select security question from DROPDOWN
  .click('select#user_security_question')
  .type('select#user_security_question', 'Name of your first boss?')
  .click('input#user_security_answer')
  .type('input#user_security_answer', '')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > form:nth-child(2) > div.tr:nth-child(8) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .screenshot('./test/acceptance_tests/screenshots/SU_securityAns.png')
  .evaluate(function(){
    return document.getElementsByTagName('span')[0].innerHTML;
  })
  .end()
    .then(function (result) {
      result == `can't be blank` ? console.log(`PASS: error message given for sign up without answer to security question`) : console.log(`FAIL: did not correctly give error message for missing answer to security question`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
