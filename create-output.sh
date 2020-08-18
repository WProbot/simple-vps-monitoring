#!/bin/bash
INPUT=$1
OUTPUT=/var/www/html/index.html
TMP=/tmp/monitoring.tmp
LOG=/var/mon.log
echo "<html>
  <head>
    <script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>
    <script type=\"text/javascript\">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
	['Time', 'Memory usage (%)', 'CPU usage (%)']," > $TMP

	cat $LOG >> $TMP
echo "        ]);

        var options = {
          title: 'Memory usage',
          hAxis: {title: 'Time',  titleTextStyle: {color: '#333'}},
          vAxis: {minValue: 0, maxValue: 100}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id=\"chart_div\" style=\"width: 100%; height: 100%;\"></div>
  </body>
</html>" >> $TMP

#write contents of .tmp file to output file
mv $TMP $OUTPUT
