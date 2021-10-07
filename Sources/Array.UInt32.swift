import Foundation
import Archivable

private let divisions = 10

extension Array where Element == UInt32 {
    var timeline: [Double] {
        isEmpty
        ? []
        : {
            { array, top in
                array
                    .map {
                        $0 / top
                    }
            } ($0, Swift.max($0.max()!, 1))
        } (counted)
    }
    
    func timestamp<T>(result: (Int, Self) -> T) -> T {
        last
            .flatMap {
                .init(timestamp: $0) > Calendar.current.date(byAdding: .minute, value: -1, to: .now)!
                ? count - 1
                : nil
            }
            .map {
                result($0, self)
            }
        ?? result(count, self + .now)
    }
    
    private var counted: [Double] {
        map(Double.init)
            .reduce(into: (.init(repeating: .init(), count: divisions), 0, ranges)) { (result: inout (
                array: [Double],
                index: Int,
                ranges: [Double]), item) in
                
                while result.index < divisions - 1 && result.ranges[result.index + 1] < item {
                    result.index += 1
                }
                result.array[result.index] += 1
            }
            .array
    }
    
    private var ranges: [Double] {
        (0 ..< divisions)
            .map {
                (.init($0) * interval) + .init(first!)
            }
    }
    
    private var interval: Double {
        .init(.now - first!) / .init(divisions)
    }
}
