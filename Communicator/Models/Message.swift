//
//  Message.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 06/04/2025.
//
import MessageKit
import Foundation

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
