import Foundation

extension Script {
    static let _favicon = """
function \(favicon.method) {
    const list = document.querySelectorAll("link[rel*='icon']");
    var icon = null;
    
    function find(rel) {
        for (var i = 0; i < list.length; i++) {
            if(list[i].getAttribute("rel") == rel && !list[i].href.endsWith('.svg')) {
                return list[i].href;
            }
        }
    }
    
    icon = find("apple-touch-icon-precomposed");
    
    if (icon == null) {
        icon = find("apple-touch-icon");
        
        if (icon == null) {
            icon = find("icon");
            
            if (icon == null) {
                icon = find("shortcut icon");
                
                if (icon == null) {
                    icon = find("alternate icon");
                    
                    if (icon == null) {
                        icon = window.location.origin + "/favicon.ico";
                    }
                }
            }
        }
    }

    return icon;
}
"""
}
