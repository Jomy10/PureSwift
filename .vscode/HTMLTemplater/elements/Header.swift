public struct HTMLHeader: HTMLElement {
    let type: Int

    public var startTag: String
    public var value: String?
    public var endTag: String
    public var children: [HTMLElement]

    init(type: Int, _ val: String) {
        self.type = type
        self.value = val
        self.children = []
        self.startTag = "<h\(type)>"
        self.endTag = "</h\(type)>"
    }
    public init(type: Int, children: [HTMLElement]) {
        self.type = type
        self.children = children
        self.startTag = "<h\(type)>"
        self.endTag = "</h\(type)>"
    }
    public init(type: Int, child: HTMLElement) {
        self.children = [child]
        self.type = type
        self.startTag = "<h\(type)>"
        self.endTag = "</h\(type)>"
    }
}