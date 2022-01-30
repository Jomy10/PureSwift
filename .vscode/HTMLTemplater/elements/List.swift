public struct HTMListItem: HTMLElement {
    public let startTag: String = "<li>"
    public let endTag: String = "</li>"
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

public struct HTMLOrderedList: HTMLElement {
    public let startTag: String = "<ol>"
    public let endTag: String = "</ol>"
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

public struct HTMLUnorderedList: HTMLElement {
    public let startTag: String = "<ul>"
    public let endTag: String = "</ul>"
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
