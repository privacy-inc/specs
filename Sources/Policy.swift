import Foundation

public enum Policy: UInt8 {
    case
    secure,
    standard
    
    static func with(level: Self) -> PolicyLevel {
        switch level {
        case .secure:
            return Secure()
        case .standard:
            return Standard()
        }
    }
    
    static func with(data: inout Data) -> PolicyLevel {
        with(level: .init(rawValue: data.removeFirst())!)
    }
}
