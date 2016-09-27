using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Snsr;

class HRAnalyzerBaseView extends Ui.View {

    var HR;
    var string_HR;
	var HR_active;

    function initialize() {       
		View.initialize();
        string_HR = "---";
		HR_active = false;
    }

	function onShow() {
		Snsr.enableSensorEvents( method(:onSnsr) );
	}
	
    // Update the view
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		
		dc.drawText(dc.getWidth()/2, 5, Gfx.FONT_TINY, "Heart Rate\nAnalyzer", Gfx.TEXT_JUSTIFY_CENTER); 
		
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2-20, Gfx.FONT_LARGE, string_HR + " bpm", Gfx.TEXT_JUSTIFY_CENTER);
		
		if ( HR_active) {
			dc.drawText(dc.getWidth()/2, dc.getHeight()-50, Gfx.FONT_MEDIUM, "Press START", Gfx.TEXT_JUSTIFY_CENTER);
		}
		else {
		    dc.drawText(dc.getWidth()/2, dc.getHeight()-70, Gfx.FONT_TINY, "Please connect\nHeart Rate Monitor", Gfx.TEXT_JUSTIFY_CENTER);
		}
    }
	
	function onSnsr(sensor_info) {
        HR = sensor_info.heartRate;
        if( sensor_info.heartRate != null ) {
            string_HR = HR.toString();
			HR_active = true;
        }
		else {
            string_HR = "---";
			HR_active = false;
        }

        Ui.requestUpdate();
    }
}


