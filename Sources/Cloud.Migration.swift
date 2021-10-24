import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func migrate() {
        Task
            .detached(priority: .utility) { [weak self] in
                await self?.migrate(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Privacy.archive"))
            }
    }
    
    func migrate(url: URL) async {
        guard
            FileManager.default.fileExists(atPath: url.path),
            let compressed = try? Data(contentsOf: url),
            compressed.count > 20
        else { return }
        
        var data = await compressed.decompressed
        _ = data.number() as UInt16
        _ = data.number() as UInt32
        
        let browses = (0 ..< .init(data.number() as UInt16))
            .map { _ in
                LegacyBrowse(data: &data)
            }
            .filter {
                $0.page.access != nil
            }
        
        _ = (0 ..< .init(data.number() as UInt32))
            .map { _ in
                data.number() as UInt32
            }
        _ = (0 ..< .init(data.number() as UInt16))
            .reduce(into: [:]) { result, _ in
                result[data.string(size: UInt16.self)] = (0 ..< .init(data.number() as UInt16))
                    .map { _ in
                        data.number() as UInt32
                    }
            }
        data.removeFirst(10)
        
        let bookmarks = (0 ..< (data.isEmpty ? 0 : .init(data.number() as UInt16)))
            .map { _ in
                LegacyPage(data: &data)
            }
            .filter {
                $0.access != nil
            }
        
        guard !bookmarks.isEmpty || !browses.isEmpty else { return }
        
        bookmarks
            .compactMap { bookmark in
                URL(string: bookmark.access!)
                    .map {
                        .init(url: $0)
                            .with(title: bookmark.title)
                    }
            }
            .forEach { website in
                model.bookmarks = model
                    .bookmarks
                    .filter {
                        $0.access.value != website.access.value
                    }
                + website
            }
        
        browses
            .compactMap { browse in
                URL(string: browse.page.access!)
                    .map {
                        Website(url: $0)
                            .with(title: browse.page.title)
                    }
            }
            .forEach { website in
                model.history = model
                    .history
                    .adding(.init(id: model.index, website: website))
                model.index += 1
            }
        
        await stream()
        try? FileManager.default.removeItem(at: url)
    }
}
