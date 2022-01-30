//
//  HTMLElement.swift
//
//  Created by Jonas Everaert on 30/01/2022.
//

public protocol HTMLElement {
    var startTag: String { get }
    var value: String? { get set }
    var endTag: String { get }
    var children: [HTMLElement] { get set }
}