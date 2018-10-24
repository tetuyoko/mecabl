$(function($) {
  var ctx = document.getElementById("Chart");
  var myChart = new Chart(ctx, {
    type: 'radar',
    data: data,
    options: {
      legend: {
        display: false,
      },
      scales: {
        display: false,
      }
    }
  });
});
