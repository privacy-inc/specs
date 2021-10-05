import Foundation

extension Script {
    static let timers = """
Worker = null;

function _privacy_incognit_timers(w) {
    const timeout = w.setTimeout;
    const interval = w.setInterval;
    
    w.setTimeout = function(x, y) {
        return -1;
    }
    
    w.setInterval = function(x) {
        return -1;
    }
    
    var id_timeout = timeout(function() { }, 0);
    var id_interval = interval(function() { }, 0);
    
    while (id_timeout--) {
        clearTimeout(id_timeout);
    }
    
    while (id_interval--) {
        clearTimeout(id_interval);
    }
}

_privacy_incognit_timers(window);

for (var index = 0; index < window.frames.length; index++) {
    _privacy_incognit_timers(window.frames[index]);
}

"""
}
