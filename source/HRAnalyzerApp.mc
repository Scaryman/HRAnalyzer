using Toybox.Application as App;
using Toybox.Sensor as Snsr;

class HRAnalyzerApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
		Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
		Snsr.setEnabledSensors( [] );
    }

    // Return the initial view of your application here
    function getInitialView() {
		var view = new HRAnalyzerBaseView();
		var delegate = new HRAnalyzerBaseDelegate(view);
        return [ view, delegate ];
    }

}