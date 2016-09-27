using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Snsr;
using Toybox.Timer as Timer;
using Toybox.Time as Time;

class HRAnalyzerView extends Ui.View {

	hidden var Timer1;
	hidden var TimerDuration = 300;
	hidden var leftDuration;
	hidden var leftTime;
	hidden var minHR = 0;
	hidden var maxHR = 0;
	hidden var string_HR = "---";
	hidden var hrArray;
	hidden var HR;
	hidden var sumHR = 0;
	hidden var numHR = 0.00;
	hidden var testCompleted;
	var firstHR = new HRRanking();
	var secondHR = new HRRanking();
	var thirdHR = new HRRanking();
	

	function initialize(lastHR) {
		View.initialize();
        Snsr.enableSensorEvents( method(:onSnsr) );
		
		HR = lastHR;
		testCompleted = false;
		leftDuration = TimerDuration;
		hrArray = new [TimerDuration];		
		leftTime = calcTime(leftDuration);
		calcHRData();
		
		Timer1 = new Timer.Timer();
		Timer1.start( method(:onTimer), 1000, true );
		
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

		var leftSring = format("$1$:$2$", [leftTime["minutes"].format("%02d"), leftTime["seconds"].format("%02d")]);
		var avgHR;
		if ( numHR == 0 ) {
			avgHR = 0;
		}
		else {
			avgHR = sumHR / numHR;
		}
		
        dc.drawText(dc.getWidth()/2, 5, Gfx.FONT_MEDIUM, leftSring, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 60, Gfx.FONT_LARGE, "HR: " + string_HR + " bpm", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth()/4, dc.getHeight()/2 - 10, Gfx.FONT_SMALL, "Min: " + minHR, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth()/2 + dc.getWidth()/4, dc.getHeight()/2 - 10, Gfx.FONT_SMALL, "Max: " + maxHR, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + dc.getHeight()/4 - 20, Gfx.FONT_LARGE, "AVG: " + avgHR.format("%3d"), Gfx.TEXT_JUSTIFY_CENTER);
		
		if (testCompleted) {
		    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
            dc.clear();
			
			var testTime = calcTime(TimerDuration);
			var testTimeString = format("$1$:$2$", [testTime["minutes"].format("%02d"), testTime["seconds"].format("%02d")]);
			var dataLoss = 100 - (numHR / (TimerDuration) * 100);
			
			var lossTime = calcTime((TimerDuration - numHR).toNumber());
			var lossTimeString =  format("$1$:$2$", [lossTime["minutes"].format("%02d"), lossTime["seconds"].format("%02d")]);
			
			dc.drawText(dc.getWidth()/2, 5, Gfx.FONT_TINY , "Test time", Gfx.TEXT_JUSTIFY_CENTER);
			dc.drawText(dc.getWidth()/2, 25, Gfx.FONT_TINY , testTimeString, Gfx.TEXT_JUSTIFY_CENTER);
			
			dc.drawText(dc.getWidth()/2, 45, Gfx.FONT_TINY , "Time loss: " + lossTimeString + " (" + dataLoss.format("%3.1f") + "%)", Gfx.TEXT_JUSTIFY_CENTER);
			
			dc.drawLine(0, 70, dc.getWidth(), 70);
			
			dc.drawText(dc.getWidth()/2, dc.getHeight()/2 -35, Gfx.FONT_SMALL, "1st: " + firstHR.HR + " bmp (" + firstHR.percent.format("%3.1f") + "%)", Gfx.TEXT_JUSTIFY_CENTER);
			
			dc.drawText(dc.getWidth()/2, dc.getHeight()/2 -5, Gfx.FONT_SMALL, "2nd: " + secondHR.HR + " bpm (" + secondHR.percent.format("%3.1f") + "%)", Gfx.TEXT_JUSTIFY_CENTER);
			
			dc.drawText(dc.getWidth()/2, dc.getHeight()/2 +25, Gfx.FONT_SMALL, "3rd: " + thirdHR.HR + " bpm (" + thirdHR.percent.format("%3.1f") + "%)", Gfx.TEXT_JUSTIFY_CENTER);
			
			dc.drawLine(0, dc.getHeight()/2 +55, dc.getWidth(), dc.getHeight()/2 +55);
			
			dc.drawText(dc.getWidth()/4 + 15, dc.getHeight()/2 + 55, Gfx.FONT_SMALL, "Min: " + minHR, Gfx.TEXT_JUSTIFY_CENTER);
		    dc.drawText(dc.getWidth()/2 + dc.getWidth()/4 - 15, dc.getHeight()/2 + 55, Gfx.FONT_SMALL, "Max: " + maxHR, Gfx.TEXT_JUSTIFY_CENTER);
			
			dc.drawText(dc.getWidth()/2, dc.getHeight() - 30, Gfx.FONT_SMALL, "Avg: " + avgHR.format("%3d"), Gfx.TEXT_JUSTIFY_CENTER);
		}
    }
	
	function onSnsr(sensor_info) {
        HR = sensor_info.heartRate;
    }
	
	function onTimer() {
		leftDuration -= 1;
		if ( leftDuration == 0 ) {
			Timer1.stop();
			testCompleted = true;
		}
		else {
			calcHRData();
		}
		leftTime = calcTime(leftDuration);		
		
		if ( testCompleted ) {
			calcResult();
		}
		Ui.requestUpdate();		
	}
	
	function calcTime(timeDuration) {
	    var dict = { "minutes" => 0, "seconds" => 0 };
		dict["seconds"] = timeDuration % 60;
		dict["minutes"] = (timeDuration - dict["seconds"]) / 60;
		return dict;
	}
	
	function calcHRData() {
	    if( HR != null ) {
			if ( maxHR < HR ) {
				maxHR = HR;
			}
			if ( minHR > HR or minHR == 0 ) {
				minHR = HR;
			}
            hrArray[TimerDuration - leftDuration] = HR;
			sumHR = sumHR + HR;
			numHR += 1;
			string_HR = HR.toString();
		}
		else {
			hrArray[TimerDuration - leftDuration] = 0;
            string_HR = "---";
        }	
	}
	
	function calcResult() {
		var i;
	    var tmpArray = new [maxHR - minHR + 1];
		for ( i = 0; i < tmpArray.size(); i += 1 ) {
			tmpArray[i] = 0;
		}
		for ( i = 0; i < numHR; i += 1 ) {
			if ( hrArray[i] != 0 ) {
			    tmpArray[hrArray[i] - minHR] += 1;
			}
		}
		firstHR.HR = 0;
		firstHR.count = 0;
		firstHR.percent = 0;
		secondHR.HR = 0;
		secondHR.count = 0;
		secondHR.percent = 0;
		thirdHR.HR = 0;
    	thirdHR.count = 0;
        thirdHR.percent = 0;
		for ( i = 0; i < tmpArray.size(); i += 1 ) {
		    if ( firstHR.count < tmpArray[i] ) {
				firstHR.HR = i + minHR;
				firstHR.count = tmpArray[i];
				firstHR.percent = firstHR.count / numHR * 100;
			}
	    }
		if ( firstHR.HR != 0 ) {
		    tmpArray[firstHR.HR - minHR] = 0;
		    for ( i = 0; i < tmpArray.size(); i += 1 ) {
		        if ( secondHR.count < tmpArray[i] ) {
			    	secondHR.HR = i + minHR;
			    	secondHR.count = tmpArray[i];
			    	secondHR.percent = secondHR.count / numHR * 100;
		    	}
	        }
			if ( secondHR.HR != 0 ) {
		        tmpArray[secondHR.HR - minHR] = 0;			
		        for ( i = 0; i < tmpArray.size(); i += 1 ) {
		            if ( thirdHR.count < tmpArray[i] ) {
			        	thirdHR.HR = i + minHR;
			        	thirdHR.count = tmpArray[i];
			        	thirdHR.percent = thirdHR.count / numHR * 100;
		        	}
	            }
			}
		}
	}
	
}

class HRRanking {
	var HR;
	var count;
	var percent = 1 / 3;
}