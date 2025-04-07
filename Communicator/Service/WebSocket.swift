//
//  WebSocket.swift
//  Communicator
//
//  Created by Kacper Marciszewski on 06/04/2025.
//

import Foundation

class WebSocket: NSObject {
    private var webSocket: URLSessionWebSocketTask?
    var onMessageReceived: ((MessageProto) -> Void)?
    
    func connect() {
        let url = URL(string: "ws://localhost:8080")
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
        receiveMessage()
        
    }
    
    func sendMessage(_ data: Data) async {
        do {
            let message = URLSessionWebSocketTask.Message.data(data)
            try await webSocket?.send(message)
        } catch {
            print("Błąd serializacji wiadomości: \(error)")
        }
    }
    
    func receiveMessage() {
            webSocket?.receive { [weak self] result in
                switch result {
                case .success(let message):
                    switch message {
                    case .data(let data):
                        do {
                            let decodedMessage = try MessageProto(serializedBytes: data)
                            print("Otrzymano wiadomość: \(decodedMessage.text)")
                            
                            DispatchQueue.main.async {
                                self?.onMessageReceived?(decodedMessage) 
                            }
                            
                        } catch {
                            print("Błąd dekodowania protobuf: \(error)")
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print("Błąd odbioru: \(error)")
                }
                
                self?.receiveMessage()
            }
        }
        
    func disconnect() {
            webSocket?.cancel(with: .goingAway, reason: nil)
    }
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
            print("Połączenie WebSocket zamknięte")
    }
    
}
