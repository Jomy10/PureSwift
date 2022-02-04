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
        return req.view.render("search")
    }

    app.webSocket("search_socket") { req, ws in 
        print("[WS.search] Opened connection.");

        let decoder = JSONDecoder();
         
        // Asynchronous return
        if #available(macOS 12, *) {
            ws.onText { ws, s in
                do {
                    let decoded: Search = try decoder.decode(Search.self, from: s.data(using: .utf8)!);
                    let search_stream = try decoded.retrieveResults();
                    // Loop over results as they are found
                    for await result in search_stream {
                        let encoded = result.encode()
                        if let _encoded = encoded {
                            try await ws.send(_encoded)
                        }
                    }
                } catch {
                    print("[WS.search: Error]", error)
                    // TODO: send error back
                }
            }
        } else {
            print("Unsupported version");
        }

        ws.onClose.whenComplete { _ in
            print("[WS.search] Closed connection.")
        } 
    }
}