var ctx = document.getElementById('myChart');
var myChart = new Chart(ctx, {
  type: 'bar',
  data: {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datasets: [{
      label: '7 days',
      data: [12, 19, 3, 5, 2, 3],
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
