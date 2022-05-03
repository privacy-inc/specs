import Foundation

extension Script {
    static let basic = """
localStorage.clear();
sessionStorage.clear();

function _privacy_incognit_finder(query) {
    var result = null;
    var item = window.getSelection().anchorNode;
    
    while (item != null) {
        const elements = item.querySelectorAll(query);

        for (var i = 0; i < elements.length; i++) {
            const source = elements[i].getAttribute("src");
            
            if (source != null) {
                result = source;
                break;
            }
        }
        
        if (result == null) {
            item = item.parentNode;
        } else {
            item = null;
        }
    }
    
    return result;
}
"""
}
