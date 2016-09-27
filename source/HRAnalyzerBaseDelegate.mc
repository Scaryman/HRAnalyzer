using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class HRAnalyzerBaseDelegate extends Ui.BehaviorDelegate {

	var mView;

    function initialize( view ) {
		BehaviorDelegate.initialize();
		mView = view;
    }

    function onSelect() {
		if ( mView.HR_active ) {
            var view = new HRAnalyzerView(mView.HR);
            var delegate = new HRAnalyzerDelegate();
            pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
		}
    }
}