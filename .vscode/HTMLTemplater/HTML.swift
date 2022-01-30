//
// HTML Templater
//

import Vapor

/// HTML Templater
public struct HTML: HTMLElement {
    public init(title: String = "") {
        self.body = []
        self.title = title
    }

    public init(title: String = "", body: [HTMLElement]) {
        self.body = body
        self.title = title
    }
    
    public init(title: String = "", element: HTMLElement) {
        self.body =  [element]
        self.title = title
    }

    mutating public func append(element: HTMLElement) {
        self.body.append(element)
    }

    mutating public func append(_ other: HTML) {
        self.body.append(contentsOf: other.body)
    }
    
 
    public var body: [HTMLElement]
    public var children: [HTMLElement] {
        get {
            body
        }
        set {
            body = value
        }
    }
    public var title: String
    
    public var startTag: String = "<html>"
    public var value: String? = ""
    public var endTag: String = "</html>"

    public func getHTML() -> Response {
        return Response(status: .ok, headers: ["Content-Type": "text/html"], body: Response.Body(string: self.generateHTML()))
    }
} 

private extension HTML {
    func generateHTML() -> String {
        var output = ""
        output.append("<!doctye html<html lang=\"en\"><head><meta charset=\"utf-8\"<title>\(title)</title></head><body>")
        for element in body {
            output.append(generateHTML(forElement: element))
        }
        output.append("</body></html>")
        return output
    }

    func generateHTML(forElement element: HTMLElement) -> String {
        var output = ""
        output.append(element.startTag)
        output.append(element.value ?? "")
        for child in element.children {
            output.append(generateHTML(forElement: child))
        }
        output.append(element.startTag)
        return output
    }
}

