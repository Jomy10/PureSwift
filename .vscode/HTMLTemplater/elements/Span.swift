public struct HTMLSpan: HTMLElement {
    public init(_ val:  String) {
        self.value = val
    }
    public init(children: [HTMLElement]) {
        self.children = children
    }
    public init(child: HTMLElement) {
        self.children = [child]
    }
    public let startTag: String = "<span>"
    public let endTag: String = "</span>"
    public var children: [HTMLElement] = []
    public var value: String?
}