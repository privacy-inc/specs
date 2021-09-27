import Foundation

extension Script {
    static let _favicon = """
function \(favicon.method) {
    const list = document.querySelectorAll("link[rel*='icon']");
    var icon = null;
    
    for (var i = 0; i < list.length; i++) {
        if(list[i].getAttribute("rel") == "icon" && !list[i].href.endsWith('.svg')) {
            icon = list[i].href;
            break;
        }
    }

    if (icon == null) {
        for (var i = 0; i < list.length; i++) {
            if(list[i].getAttribute("rel") == "shortcut icon" && !list[i].href.endsWith('.svg')) {
                icon = list[i].href;
                break;
            }
        }

        if (icon == null) {
            for (var i = 0; i < list.length; i++) {
                if(list[i].getAttribute("rel") == "alternate icon" && !list[i].href.endsWith('.svg')) {
                    icon = list[i].href;
                    break;
                }
            }

            if (icon == null) {
                for (var i = 0; i < list.length; i++) {
                    if(list[i].getAttribute("rel") == "apple-touch-icon" && !list[i].href.endsWith('.svg')) {
                        icon = list[i].href;
                        break;
                    }
                }

                if (icon == null) {
                    icon = window.location.origin + "/favicon.ico";
                }
            }
        }
    }

    return icon;
}
"""
}
