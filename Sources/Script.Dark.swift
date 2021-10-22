import Foundation

extension Script {
    static let _dark = """
function _privacy_incognit_make_dark(element) {
    if (!element.hasAttribute('_privacy_incognit_dark_mode')) {
        element.setAttribute('_privacy_incognit_dark_mode', 1);

        const text_color = getComputedStyle(element).getPropertyValue("color");
        const background_color = getComputedStyle(element).getPropertyValue("background-color");

        if (text_color != "rgb(206, 204, 207)" && text_color != "rgb(124, 170, 223)") {
            if (element.tagName == "A") {
                element.style.setProperty("color", "#7caadf", "important");
            } else {
                element.style.setProperty("color", "#cecccf", "important");
            }
        }

        if (getComputedStyle(element).getPropertyValue("box-shadow") != "none") {
            element.style.setProperty("box-shadow", "none", "important");
        }

        if (getComputedStyle(element).getPropertyValue("background").includes("gradient")) {
            element.style.setProperty("background", "none", "important");
        }

        if (background_color != "rgb(37, 34, 40)" && background_color != "rgba(0, 0, 0, 0)" && background_color != "rgb(0, 0, 0)") {
            let alpha = 1;
            const rgba = background_color.match(/[\\d.]+/g);
            if (rgba.length > 3) {
               alpha = rgba[3];
            }
            element.style.setProperty("background-color", "rgba(37, 34, 40, " + alpha + ")", "important");
        }
    }
}

function _privacy_incognit_loop(node) {
    _privacy_incognit_make_dark(node);
    
    var nodes = node.childNodes;
    for (var i = 0; i <nodes.length; i++) {
        if(!nodes[i]) {
            continue;
        }

        if(nodes[i].childNodes.length > 0) {
            _privacy_incognit_loop(nodes[i]);
        }
    }
}

const _privacy_incognit_event = function(_privacy_incognit_event) {
    if (_privacy_incognit_event.animationName == '_privacy_incognit_node') {
        _privacy_incognit_loop(_privacy_incognit_event.target);
    }
}
        
document.addEventListener('webkitAnimationStart', _privacy_incognit_event, false);

const _privacy_incognit_style = document.createElement('style');
_privacy_incognit_style.innerHTML = "\
\
:root, html, body {\
    background-image: none !important;\
    background-color: #252228 !important;\
}\
a, a *, :not(a p) {\
    color: #7caadf !important;\
}\
:root :not(a, a *), a p {\
    color: #cecccf !important;\
}\
* {\
    -webkit-animation-duration: 0.01s;\
    -webkit-animation-name: _privacy_incognit_node;\
    border-color: #454248 !important;\
    outline-color: #454248 !important;\
    box-shadow: none !important;\
}\
::before, ::after {\
    background: none !important;\
}\
@-webkit-keyframes _privacy_incognit_node {\
    from {\
        outline-color: #fff;\
    }\
    to {\
        outline-color: #000;\
    }\
}";

document.addEventListener('readystatechange', event => {
    switch (event.target.readyState) {
        case "interactive":
            document.head.appendChild(_privacy_incognit_style);
            break;
        case "complete":
            document.body.querySelectorAll(":not([_privacy_incognit_dark_mode])").forEach(_privacy_incognit_make_dark);
            break;
        default:
            break;
    }
});

setTimeout(function() {
    document.head.appendChild(_privacy_incognit_style);
}, 1);

"""
}
