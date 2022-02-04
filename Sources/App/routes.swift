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
        // let results: [Package]
        // do {
        //     let search = try req.query.decode(Search.self)
        //     results = try search.retrieveResults()
        // } catch(let error) {
        //     results = [Package(title: "Error", authors: ["Something went wrong: \(error)"])]
        // }
        // let encoder = JSONEncoder()
        // let rep = Reply(results: [])
        // let results = Response(body: .init(stream: { writer in
        //     for _ in 0..<1000 {
        //         let buffer = try! encoder.encodeAsByteBuffer(rep, allocator: app.allocator)
        //         writer.write(.buffer(buffer))
        //     }
        // }))
        return req.view.render("search")
    }

    app.webSocket("echo") { req, ws in 
        print("[WS.search] Opened connection.");

        let decoder = JSONDecoder();
        let encoder = JSONEncoder();

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
            // Fallback on earlier versions
        }

        // ws.send("Hello world!")

        ws.onClose.whenComplete { _ in
            print("[WS.search] Closed connection.")
        } 
    }
}


/// Represents a search query
struct Search: Content {
    /// Search query
    var query: String
    /// Category
    var cat: String

}

extension Search {
    /// Retrieve results from the query
    /// Returns a stream of `SearchResult`s.
    func retrieveResults() throws -> AsyncStream<SearchResult> {
        var packages: [Package] = [];
        switch self.cat {
        case "all":
            // Get all packages from JSON
            let file = try String(contentsOfFile: "Public/Data/packages.json", encoding: String.Encoding.utf8)
            let decoder = JSONDecoder()
            let packs = try decoder.decode([Package].self, from: file.data(using: String.Encoding.utf8)!) 
            packages = packs
        default:
            // TODO: generate JSON
            print("Unimplemented")
        }

        let fuse = Fuse(threshold: 0.3)
        // Stream
        let results = AsyncStream(SearchResult.self) { cont in
            for package in packages {
                // Get matches
                let title_match = fuse.search(self.query, in: package.title)
                let desc_match = fuse.search(self.query, in: package.short_desc ?? "")
                // Return result
                cont.yield(
                    SearchResult(
                        title_match: title_match, 
                        desc_match: desc_match, 
                        package: package
                    ) 
                )
            }
            cont.finish()
        }
        return results
    }
}

struct SearchResult {
    let title_match: (score: Double, ranges: [CountableClosedRange<Int>])?
    let desc_match: (score: Double, ranges: [CountableClosedRange<Int>])?
    let package: Package
}

extension SearchResult {
    func encode() -> String? {
        let title = package.title
        let desc = package.short_desc ?? ""
        
        // Parse title
        var title_highlighted = String()
        var title_score = 0.0
        if let title_match = self.title_match {
            title_score = title_match.score
            let title_range = title_match.ranges
            var title_h = title
            for range in title_range {
                let range_size = range.count
                title_h.replaceSubrange(title_h.closedRange(fromInt: range), with: "#".repeat(range_size))
            }

            for i in 0..<title.count {
                let char = title[title.index(title.startIndex, offsetBy: i)]
                let highlight = title_h[title_h.index(title_h.startIndex, offsetBy: i)] == "#"
                if highlight {
                    title_highlighted += "<span class='h'>\(char)</span>"
                } else {
                    title_highlighted += String(char)
                }
            }
        }

        // Parse desc
        var desc_highlighted = String()
        var desc_score = 0.0
        if let desc_match = self.desc_match {
            desc_score = desc_match.score
            let desc_range = desc_match.ranges
            var desc_h = desc
            for range in desc_range {
                let range_size = range.count
                desc_h.replaceSubrange(desc_h.closedRange(fromInt: range), with: "#".repeat(range_size))
            }

            for i in 0..<desc.count {
                let char = desc[desc.index(desc.startIndex, offsetBy: i)]
                let highlight = desc_h[desc_h.index(desc_h.startIndex, offsetBy: i)] == "#"
                if highlight {
                    desc_highlighted += "<span class='h'>\(char)</span>"
                } else {
                    desc_highlighted += String(char)
                }
            }
        }

        if title_highlighted == "" && desc_highlighted == "" {
            return nil
        } else {
            if desc_highlighted == "" {
                return "{\"title\":\"\(title_highlighted)\", \"desc\": \"\(desc)\", \"title_score\": \(title_score), \"desc_score\": \(desc_score), \"link\": \"\(title)\"}"
            } else if title_highlighted == "" {
                return "{\"title\":\"\(title)\", \"desc\": \"\(desc_highlighted)\", \"title_score\": \(title_score), \"desc_score\": \(desc_score), \"link\": \"\(title)\"}"
            } else {
                return "{\"title\":\"\(title_highlighted)\", \"desc\": \"\(desc_highlighted)\", \"title_score\": \(title_score), \"desc_score\": \(desc_score), \"link\": \"\(title)\"}"
            }
        }
    }
}

/// Use integer ranges on String
extension String {
    func closedRange(fromInt bounds: CountableClosedRange<Int>) -> ClosedRange<String.Index> {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return start...end
    }

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension String {
    func `repeat`(_ times: Int) -> String {
        String(repeating: self, count: times)
    }
}
