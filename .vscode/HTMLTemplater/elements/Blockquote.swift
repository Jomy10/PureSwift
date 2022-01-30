//
//  Blockquote.swift
//  
//
//  Created by Jonas Everaert on 30/01/2022.
//

import Foundation

public struct HTMLBlockquote: HTMLElement {
    public init(_ val:  String) {
        self.value = val
    }
    public init(children: [HTMLElement]) {
        self.children = children
    }
    public init(child: HTMLElement) {
        self.children = [child]
    }
    public let startTag: String = "<blockquote>"
    public let endTag: String = "</blockquote>"
    public var children: [HTMLElement] = []
    public var value: String?
}