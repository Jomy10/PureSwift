import Vapor
import NIO
import Foundation

import Fuse

/// Errors for this site
enum PureSwiftError: Error {
    case Database(String)
    case DataDecode(String)
}

func routes(_ app: Application) throws {
    /// Index (browse)
    app.get { req -> EventLoopFuture<View> in
        // Get all packages
        let file = try String(contentsOfFile: "Public/Data/packages.json", encoding: String.Encoding.utf8)
        let decoder = JSONDecoder()
        let packages: [Package] = try decoder.decode([Package].self, from: file.data(using: String.Encoding.utf8)!) 

        return req.view.render("index", ["packages": packages])
    }

    /// Categories overvies
    app.get("category", ":category") { req -> EventLoopFuture<View> in 
        return req.view.render("not_found")
    }
    
    /// Packages
    app.get("package", ":name") { req -> EventLoopFuture<View> in
        return try PackagePageController().getPage(req: req)
    }

    /// Search
    app.get("search") { req -> EventLoopFuture<View> in
        let results: [Package]
        do {
            let search = try req.query.decode(Search.self)
            results = try search.retrieveResults()
        } catch(let error) {
            results = [Package(title: "Error", authors: ["Something went wrong: \(error)"])]
        }
        // let encoder = JSONEncoder()
        // let rep = Reply(results: [])
        // let results = Response(body: .init(stream: { writer in
        //     for _ in 0..<1000 {
        //         let buffer = try! encoder.encodeAsByteBuffer(rep, allocator: app.allocator)
        //         writer.write(.buffer(buffer))
        //     }
        // }))
        return req.view.render("search", ["packages": results])
    }

    app.webSocket("echo") { req, ws in 
        print("[WS.search] Opened.");

        let decoder = JSONDecoder();
        ws.onText { ws, s in
            do {
                let decoded = try decoder.decode(Search.self, from: s.data(using: .utf8)!);
                // TODO: search + return 
            } catch {
                print(error)
                // TODO: send error back
            }
        }

        ws.send("Hello world!")

        ws.onClose.whenComplete { _ in
            print("[WS.search] Closed.")
        } 
    }
}



struct Reply: Content {
    var results: [String]
}

/// Represents a search query
struct Search: Content {
    var query: String?
}

extension Search {
    /// Retrieve results from the query
    func retrieveResults() throws -> [Package] {
        // #7 
        let fuse = Fuse()
        let result = fuse.search("od mn war", in: "Old Man's  War")
        print(result?.score)
        print(result?.ranges)

        return []
    }
}
