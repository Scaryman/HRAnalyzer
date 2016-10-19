using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class HRAnalyzerMainMenuAboutView extends Ui.View {

    function initialize() {       
		View.initialize();
    }
	
	function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 25, Gfx.FONT_MEDIUM, "Version\n" + Ui.loadResource(Rez.Strings.Version), Gfx.TEXT_JUSTIFY_CENTER);
	}
}