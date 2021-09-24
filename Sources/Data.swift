import Foundation

extension Data {
    public func temporal(_ name: String) -> URL {
        {
            try? write(to: $0, options: .atomic)
            return $0
        } (URL.temporal(name))
    }
    
    #if os(macOS)
    
    var url: URL? {
        var stale = false
        return (try? URL(resolvingBookmarkData: self, options: .withSecurityScope, bookmarkDataIsStale: &stale))
            .flatMap {
                $0.startAccessingSecurityScopedResource() ? $0 : nil
            }
    }
    
    #elseif os(iOS)
    
    var url: URL? {
        var stale = false
        return (try? URL(resolvingBookmarkData: self, bookmarkDataIsStale: &stale))
            .flatMap {
                $0.startAccessingSecurityScopedResource() ? $0 : nil
            }
    }
    
    #else
    
    var url: URL? {
        nil
    }
    
    #endif
}
