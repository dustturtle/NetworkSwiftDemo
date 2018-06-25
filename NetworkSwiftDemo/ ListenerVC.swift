//
//  ListenerVC.swift
//  NetworkSwiftDemo
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Network

class ListenerVC: UIViewController {
    var listener: NWListener!
    var isTCP: Bool = true;
    
    @IBOutlet weak var protocolSwitch: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var portInput: UITextField!
    
    // connecting messages...
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func startListen(_ sender: Any)
    {
        NetworkHelper.shared.printSmile()
        statusLabel.text = "Listening"
        
        if portInput.text == nil || (portInput.text?.isEmpty)!
        {
            print ("port invalid! can not listen!")
            return;
        }
        
        if protocolSwitch.isOn
        {
            listener = try! NWListener(parameters: .tcp, port: NWEndpoint.Port.init(portInput.text!)!)
        }
        else
        {
            listener = try! NWListener(parameters: .udp, port: NWEndpoint.Port.init(portInput.text!)!)
        }

        listener.newConnectionHandler = { (newConnection) in
            newConnection.start(queue: .main)
            self.fromLabel.text = newConnection.endpoint.debugDescription
            
            self.receiveLoop(connection: newConnection)
        }
        
        listener.stateUpdateHandler = { (state) in
            print (state)
        }
        
        listener.start(queue: .main)
        dump(listener)
    }
    
    @IBAction func stopListen(_ sender: Any) {
        listener.cancel()
        fromLabel.text = "None"
        infoLabel.text = ""
        statusLabel.text = "Stopped"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Listener"
    }
    
    func receiveLoop (connection:NWConnection)
    {
        connection.receive(minimumIncompleteLength: 1, maximumLength: Int(UINT32_MAX))
        { (content, context, isComplete, receiveError) in
            if (self.protocolSwitch.isOn)
            {
                // means tcp;  TODO:logic not strict, needs improvement.
                if isComplete
                {
                    print("Complete")
                    self.infoLabel.text = ""
                    self.listener.cancel()
                    self.fromLabel.text = "None"
                    self.statusLabel.text = "Stopped"
                }
                else
                {
                    print("notComplete")
                    let str = NSString(data:content! ,encoding: String.Encoding.utf8.rawValue)
                    print(str!)
                    self.infoLabel.text = str! as String
                    self.receiveLoop(connection: connection)
                }
            }
            else
            {
                if context!.isFinal
                {
                    print("Complete")
                    self.infoLabel.text = ""
                    self.listener.cancel()
                    self.fromLabel.text = "None"
                    self.statusLabel.text = "Stopped"
                }
                else
                {
                    print("notComplete")
                    let str = NSString(data:content! ,encoding: String.Encoding.utf8.rawValue)
                    print(str!)
                    self.infoLabel.text = str! as String
                    self.receiveLoop(connection: connection)
                }
            }
            // DispatchIO.. not needed here.
        }
    }
}
