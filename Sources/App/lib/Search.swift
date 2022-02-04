import Vapor
import Fuse

/// Represents a search query
public struct Search: Content {
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

public struct SearchResult {
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
