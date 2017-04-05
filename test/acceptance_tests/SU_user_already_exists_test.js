const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Homepage > Sign up > enter email that already has signed up - should receive account creation error message

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(1)')
  .click('input#user_email')
  .type('input#user_email', 'example@nhs.co.uk')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > div.br2.mv3.center:nth-child(3) > form:nth-child(1) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .screenshot('./test/acceptance_tests/screenshots/SU_user_already_exists.png')
  .evaluate(function(){
    let errorMessage = document.getElementsByTagName('span')[1].innerHTML;
    // Have to split error message at 'account' because the test won't recognise
    // an error message on multiple lines
    return errorMessage.split('account')[0];
  })
  .end()
    .then(function (result) {
      result == 'Sorry you cannot create an ' ? console.log(`Test passed: existing user sign up successfully rejected with error message`) : console.log(`Test failed: did not correctly give error message for already existing user`);
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
