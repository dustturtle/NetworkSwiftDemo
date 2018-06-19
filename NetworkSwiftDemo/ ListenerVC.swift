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
    
    @IBAction func startListen(_ sender: Any) {
        self.listener = try! NWListener(parameters: .tcp, port: NWEndpoint.Port.init(self.portInput.text!)!)!
        self.listener!.newConnectionHandler = { (newConnection) in
            newConnection.start(queue: .main)
            self.fromLabel.text = newConnection.endpoint.debugDescription
            self.receiveLoop(connection: newConnection)
        }
        
        self.listener!.stateUpdateHandler = { (state) in
            print (state)
        }
        
        self.listener!.start(queue: .main)
        //dump(listener)
    }
    
    @IBAction func stopListen(_ sender: Any) {
        self.listener!.cancel()
        self.fromLabel.text = "None"
        self.infoLabel.text = ""
    }
    
    @IBOutlet weak var portInput: UITextField!
    
    // connecting messages...
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var listener:NWListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Listener"

        // Do any additional setup after loading the view.
    }
    
    func receiveLoop (connection:NWConnection)
    {
        connection.receive(minimumIncompleteLength: 1, maximumLength: Int(UINT32_MAX))
        { (content, context, isComplete, receiveError) in
            if isComplete
            {
                print("Complete")
                self.infoLabel.text = ""
                self.listener?.cancel()
                self.fromLabel.text = "None"
            }
            else
            {
                print("notComplete")
                
                let str =  NSString(data:content! ,encoding: String.Encoding.utf8.rawValue)
                print(str!)
                self.infoLabel.text = str! as String
                self.receiveLoop(connection: connection)
            }
        
            // DispatchIO.. not needed here.
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
