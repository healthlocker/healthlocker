var ctx = document.getElementById('myChart');
var sleepHours = window.sleep_hours ? window.sleep_hours.split(',') : [];
var sleepDates = window.sleep_dates ? window.sleep_dates.split(',') : [];
var today = new Date(Date.now()).getDay();
var days = ['Sun ', 'Mon ', 'Tue ', 'Wed ', 'Thu ', 'Fri ', 'Sat '];
var daysOfWeek = [];
var daysOfWeekHuman = [];

var i = today + 1;
for (i; i <= today + 7; i++) {
  daysOfWeek.push((i % 7).toString());
  daysOfWeekHuman.push(days[i % 7] + sleepDates[i % 7]);
}

var hoursSlept = [];
daysOfWeek.map(function (day) {
  if (sleepHours[day]) {
    hoursSlept.push(sleepHours[day]);
  } else {
    hoursSlept.push(0);
  }
});

if (ctx) {
  var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: daysOfWeekHuman,
      datasets: [{
        label: '7 days',
        data: hoursSlept,
        backgroundColor: [
          'rgba(37, 189, 195, 0.2)',
          'rgba(37, 189, 195, 0.2)',
          'rgba(37, 189, 195, 0.2)',
          'rgba(37, 189, 195, 0.2)',
          'rgba(37, 189, 195, 0.2)',
          'rgba(37, 189, 195, 0.2)',
          'rgba(37, 189, 195, 0.2)'
        ],
        borderColor: [
          'rgba(37, 189, 195, 1)',
          'rgba(37, 189, 195, 1)',
          'rgba(37, 189, 195, 1)',
          'rgba(37, 189, 195, 1)',
          'rgba(37, 189, 195, 1)',
          'rgba(37, 189, 195, 1)',
          'rgba(37, 189, 195, 1)'
        ],
        borderWidth: 1
      }]
    },
    options: {
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
  });
}
