using Toybox.WatchUi as Ui;

class HRAnalyzerMainMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
		MenuInputDelegate.initialize();
    }

	function onMenuItem(item) {
        if (item == :About) {
			var view = new HRAnalyzerMainMenuAboutView();
			var delegate = new HRAnalyzerMainMenuAboutDelegate();
            Ui.pushView(view, delegate, Ui.SLIDE_UP);
        }
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
    }
	
}