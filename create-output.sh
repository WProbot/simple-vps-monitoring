#!/bin/bash
OUTPUT=/var/www/html/index.html
LOG=/var/mon.log
echo "<html>
  <head>
    <script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>
    <script type=\"text/javascript\">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Time', 'Memory usage (%)']," > $OUTPUT;

IFS=$'\n'
for line in $(cat $LOG) ; do
	val=$(echo $line | cut --delimiter=' ' -f 1)
	d1=$(echo $line | cut --delimiter=' ' -f 2)
	d2=$(echo $line | cut --delimiter=' ' -f 3)
	val=$(bc <<< "scale=2; $val/100")
	echo "['$d1 $d2',$val]," >> $OUTPUT
done

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
</html>" >> $OUTPUT
