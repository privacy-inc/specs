import Foundation
import Combine

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS) || os(iOS)

public final actor Favicon {
    private var received = Set<String>()
    private var publishers = [String : Pub]()
    
    nonisolated private let session: URLSession = {
        var configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        return .init(configuration: configuration)
    } ()
    
    private lazy var path: URL = {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favicons")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        return url
    } ()
    
    public init() {
        
    }
    
    public func publisher(for icon: String) -> Pub? {
        validate(domain: icon)
        
        let publisher = publishers[icon]!
        
        Task
            .detached(priority: .utility) {
                if await publisher.output == nil {
                    guard let output = await self.output(for: icon) else { return }
                    await publisher.received(output: output)
                }
            }
        
        return publisher
    }
    
    public func request(for access: AccessType) -> Bool {
        (access as? Access.Remote)
            .map(\.domain.minimal)
            .map {
                !received.contains($0.lowercased()) && !$0.isEmpty
            }
        ?? false
    }
    
    public func received(url: String, for access: AccessType) async {
        guard let domain = (access as? Access.Remote)?.domain.minimal.lowercased() else { return }
        
        validate(domain: domain)
        received.insert(domain)
        
        guard
            !url.isEmpty,
            let url = URL(string: url)
        else { return }
        
        Task
            .detached(priority: .utility) {
                try? await self.fetch(url: url, for: domain)
            }
    }
    
    public func clear() {
        publishers = [:]
        received = []
        let path = self.path
        
        Task
            .detached(priority: .utility) {
                try? FileManager.default.removeItem(at: path)
            }
    }
    
    private func fetch(url: URL, for domain: String) async throws {
        let (location, response) = try await session.download(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            try? FileManager.default.removeItem(at: location)
            return
        }
        let file = path.appendingPathComponent(domain)
        
        if FileManager.default.fileExists(atPath: file.path) {
            try? FileManager.default.removeItem(at: file)
        }
        
        try? FileManager.default.moveItem(at: location, to: file)
        
        guard let output = output(for: domain) else { return }
        await publishers[domain]!.received(output: output)
    }
    
    private func validate(domain: String) {
        if publishers[domain] == nil {
            publishers[domain] = .init()
        }
    }
    
    private func output(for domain: String) -> Pub.Output? {
        let url = path.appendingPathComponent(domain)
        
        guard
            FileManager.default.fileExists(atPath: url.path),
            let data = try? Data(contentsOf: url)
        else { return nil }
        
        return .init(data: data)
    }
}

extension Favicon {
    public final actor Pub: Publisher {
#if os(macOS)
public typealias Output = NSImage
#elseif os(iOS)
public typealias Output = UIImage
#endif

        public typealias Failure = Never
        fileprivate private(set) var output: Output?
        private var contracts = [Contract]()
        
        fileprivate func received(output: Output) async {
            self.output = output
            clean()
            await send(output: output)
        }
        
        public nonisolated func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let sub = Sub(subscriber: .init(subscriber))
            subscriber.receive(subscription: sub)
            
            let contract = Contract(sub: sub)
            
            Task {
                await store(contract: contract)
                await send(contract: contract)
            }
        }
        
        private func store(contract: Contract) async {
            contracts.append(contract)
            
            clean()
        }
        
        @MainActor private func send(contract: Contract) async {
            if let output = await output {
                _ = contract.sub?.subscriber?.receive(output)
            }
        }
        
        @MainActor private func send(output: Output) async {
            await contracts
                .compactMap(\.sub?.subscriber)
                .forEach {
                    _ = $0.receive(output)
                }
        }
        
        private func clean() {
            contracts = contracts
                .filter {
                    $0.sub?.subscriber != nil
                }
        }
    }
}
    
private extension Favicon.Pub {
    final class Sub: Subscription {
        private(set) var subscriber: AnySubscriber<Output, Failure>?
        
        init(subscriber: AnySubscriber<Output, Failure>) {
            self.subscriber = subscriber
        }
        
        func cancel() {
            subscriber = nil
        }
        
        func request(_: Subscribers.Demand) {

        }
    }
    
    struct Contract {
        private(set) weak var sub: Sub?
        
        init(sub: Sub) {
            self.sub = sub
        }
    }
}

#endif
