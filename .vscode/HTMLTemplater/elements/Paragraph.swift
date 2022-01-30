public struct HTMLParagraph: HTMLElement {
    init(_ val:  String) {
        self.value = val
    }
    public init(children: [HTMLElement]) {
        self.children = children
    }
    public init(child: HTMLElement) {
        self.children = [child]
    }
    public let startTag: String = "<p>"
    public let endTag: String = "</p>"
    public var children: [HTMLElement] = []
    public var value: String?
}
