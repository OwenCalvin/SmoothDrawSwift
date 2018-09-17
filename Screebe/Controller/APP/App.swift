//
//  App.swift
//  Screebe
//
//  Created by Owen on 15.09.18.
//  Copyright © 2018 daven. All rights reserved.
//

import Foundation
import SocketIO

class App {
    private var Manager: SocketManager
    private var Socket: SocketIOClient {
        get {
            return Manager.defaultSocket
        }
    }
    public var ServerURL: URL
    private var Session: SessionInstance

    init(url: String) {
        Session = SessionInstance()
        ServerURL = URL(string: url)!
        Manager = SocketManager(socketURL: ServerURL, config: [.log(false)])
        Socket.connect()
        initEvents()
    }

    public func createRoom(username: String, password: String) {
        Socket.emit(IO.CreateSession.rawValue, username, password)
    }

    private func initEvents() {
        let sucess = {(message: IO) -> String in
            return IO.Success.rawValue + ":" + message.rawValue
        }

        Socket.on(sucess(IO.CreateSession)) {data, _ in
            self.Session.Username = data[0] as? String
            self.Session.SessionID = data[1] as? String
            self.Session.connected = true
        }
    }
}
