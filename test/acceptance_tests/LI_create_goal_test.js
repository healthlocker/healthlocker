const Nightmare = require('nightmare')
const nightmare = Nightmare({ show: true })

// Tests login using logged@in.com user and password '123456', toolkit > goals > create new goal > new goal is visible in list of goals

nightmare
  .goto('https://www.healthlocker.uk/')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > section.bb.b--black-20.pb3.ph3.center:nth-child(3) > p:nth-child(4) > a:nth-child(2)')
  .click('input#login_email')
  .type('input#login_email', 'logged@in.com')
  .click('input#login_password')
  .type('input#login_password', '123456')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > section.mw7.center:nth-child(2) > form.mw6.br2.mv3.center:nth-child(2) > div.tr:nth-child(5) > button.mt4.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(2000)
  // Screenshot of toolkit page
  .screenshot('./test/acceptance_tests/screenshots/toolkit.png')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > div.goals-strategies.w-100.mw6.center:nth-child(2) > div.tc.w-40.dib:nth-child(1) > a:nth-child(1) > span.mt3.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-75:nth-child(2)')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > div.ma3.ma4-m.ma4-l:nth-child(3) > a.link.mv3.f5.tc.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.w-50:nth-child(2)')
  .click('textarea#goal_content')
  .type('textarea#goal_content', 'Test Goal!')
  .click('main#body > section.h-100.pa3.pa5-ns.bt.b--black-10.bg-white:nth-child(1) > section.mw7.center:nth-child(1) > form:nth-child(6) > div.center:nth-child(3) > div.mh4.measure.center:nth-child(1) > div.tr:nth-child(6) > button.mt3.f5.link.dim.br-pill.ph3.pv2.dib.black-60.hl-bg-grey.pointer.w-40:nth-child(1)')
  .wait(3000)
  // Screenshot of goals page including newly created goal
  .screenshot('./test/acceptance_tests/screenshots/create_goal.png')
  .evaluate(function() {
    return document.getElementsByTagName('p')[2].innerHTML;
  })
.end()
    .then(function (result) {
      result === 'Goal added!' ? console.log(`PASS: Goal created successfully!`) : console.log(`FAIL: Goal not created.`)
    })
    .catch(function (error) {
      console.error('Error:', error);
    });
