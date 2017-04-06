const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Tests login using logged@in.com user and password '123456' arrives at toolkit

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(2)')
  .click('input#login_email')
  .type('input#login_email', 'logged@in.com')
  .click('input#login_password')
  .type('input#login_password', '123456')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > section.mw7.center:nth-child(2) > form.mw6.br2.mv3.center:nth-child(2) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(1000)
  .screenshot('./test/acceptance_tests/screenshots/login_to_toolkit.png')
  .evaluate(function() {
    return window.location.href;
  })
.end()
    .then(function (result) {
      result === 'https://www.healthlocker.uk/toolkit' ? console.log(`PASS: login successful`) : console.log(`FAIL: login unsuccessful. Arrived at: ${result}`)
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
