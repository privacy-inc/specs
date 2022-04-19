extension Script {
    static let _text = """
document.body.style.webkitTextSizeAdjust
"""
    public static func text(size: Double) -> String {
        _text + "='\(Int(size * 100))%'"
    }
}
