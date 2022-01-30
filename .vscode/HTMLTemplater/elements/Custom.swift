public struct HTMLCustomElement: HTMLElement {
    public init(_ val:  String) {
        self.value = val
    }
    public init(children: [HTMLElement]) {
        self.children = children
    }
    public init(child: HTMLElement) {
        self.children = [child]
    }
    public let startTag: String = ""
    public let endTag: String = ""
    public var children: [HTMLElement] = []
    public var value: String?
}