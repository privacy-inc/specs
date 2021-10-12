import Foundation

extension Script {
    public static let _find = """
if (!getSelection().isCollapsed) {
    var privacy_rect = getSelection().getRangeAt(0).getBoundingClientRect();
    "{{" + privacy_rect.left + "," + privacy_rect.top + "},{" + privacy_rect.width + "," + privacy_rect.height + "}}";
}
"""
}
