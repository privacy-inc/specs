import Foundation

extension Script {
    static let scroll = """
const _privacy_incognit_splitted = location.hostname.split(".");
if (_privacy_incognit_splitted.length > 1) {
    switch (_privacy_incognit_splitted[_privacy_incognit_splitted.length - 2]) {
    case "google":
            var style = document.createElement('style');
            style.innerHTML = ":root, body { overflow-y: visible !important; }";
            document.head.appendChild(style);
            break;
    case "twitter":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body { overflow-y: visible !important; }";
            document.head.appendChild(style);
            break;
    case "youtube":
            var style = document.createElement('style');
            style.innerHTML = "body { position: unset !important; }";
            document.head.appendChild(style);
            break;
    case "instagram":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body, .E3X2T { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "reuters":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "thelocal":
            var style = document.createElement('style');
            style.innerHTML = ".tp-modal-open { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "pinterest":
            document.body.setAttribute("style", "overflow-y: visible !important");
            break;
    case "bbc":
            var style = document.createElement('style');
            style.innerHTML = "body { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "reddit":
            var style = document.createElement('style');
            style.innerHTML = "body, .scroll-disabled { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "bloomberg":
            var style = document.createElement('style');
            style.innerHTML = "body { overflow: unset !important; }";
            document.head.appendChild(style);
            break;
    case "newyorker":
            var style = document.createElement('style');
            style.innerHTML = ":root, html, body { overflow-y: visible !important; }";
            document.head.appendChild(style);
            break;
    default:
            break;
    }
}
"""
}
