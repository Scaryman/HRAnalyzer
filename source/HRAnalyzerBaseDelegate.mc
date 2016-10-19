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
	
	function onMenu() {
		var view = new Rez.Menus.MainMenu();
		var delegate = new HRAnalyzerMainMenuDelegate();
        Ui.pushView(view, delegate, Ui.SLIDE_UP);
    }
}