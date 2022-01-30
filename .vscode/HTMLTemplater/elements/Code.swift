public struct HTMLCode: HTMLElement {
    public let startTag: String = "<code>"
    public let endTag: String = "</code>"
    public var children: [HTMLElement] = []
    public var value: String?

    public init(_ val:  String) {
        self.value = val
    }
    public init(children: [HTMLElement]) {
        self.children = children
    }
    public init(child: HTMLElement) {
        self.children = [child]
    }
}