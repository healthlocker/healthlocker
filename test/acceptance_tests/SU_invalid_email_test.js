const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Homepage > Sign up > enter invalid email - should receive account creation error message

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(1)')
  .click('input#user_email')
  .type('input#user_email', 'examplenhs.co.uk')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > div.br2.mv3.center:nth-child(3) > form:nth-child(1) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .screenshot('./test/acceptance_tests/screenshots/SU_invalid_email.png')
  .evaluate(function(){
    return errorMessage = document.getElementsByTagName('span')[1].innerHTML;
  })
  .end()
    .then(function (result) {
      result == 'has invalid format' ? console.log(`PASS: invalid email recognised and error displayed`) : console.log(`FAIL: did not correctly recognise invalid email and display error`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
