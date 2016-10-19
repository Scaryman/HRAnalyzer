using Toybox.WatchUi as Ui;

class HRAnalyzerMainMenuAboutDelegate extends Ui.InputDelegate {

    function initialize() {
		InputDelegate.initialize();
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_DOWN);
    }
	
}