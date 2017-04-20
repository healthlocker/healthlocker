const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Homepage > Sign up > enter password that is too short - should receive password length error message

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(1)')
  .click('input#user_email')
  .type('input#user_email', 'test@testing.com')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > div.br2.mv3.center:nth-child(3) > form:nth-child(1) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .click('input#user_password')
  .type('input#user_password', '123')
  .click('input#user_password_confirmation')
  .type('input#user_password_confirmation', '123')
  .click('select#user_security_question')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > form:nth-child(2) > div.form-group:nth-child(7)')
//  Select security question from DROPDOWN
  .click('select#user_security_question')
  .type('select#user_security_question', 'Name of your first boss?')
  .click('input#user_security_answer')
  .type('input#user_security_answer', '123')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > form:nth-child(2) > div.tr:nth-child(8) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .screenshot('./test/acceptance_tests/screenshots/SU_short_password.png')
  .evaluate(function(){
    return document.getElementsByTagName('span')[0].innerHTML;
  })
  .end()
    .then(function (result) {
      result == 'should be at least 6 character(s)' ? console.log(`PASS: sign up with too short password successfully rejected with error message`) : console.log(`FAIL: did not correctly give error message for too short password`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
