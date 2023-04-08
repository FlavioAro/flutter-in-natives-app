//
//  ViewController.swift
//  ios_native_app
//
//  Created by flavio on 07/04/23.
//

import UIKit
import Flutter

class ViewController: UIViewController {
    lazy var flutterEngine = FlutterEngine(name: "module_flutter_engine")
    var channel: FlutterMethodChannel!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        flutterEngine.run()
        channel = FlutterMethodChannel(name: "example.com/channel", binaryMessenger: flutterEngine.binaryMessenger)
        channel.setMethodCallHandler(handleMethodCall)

        setupTextField()
        setupButton()
    }

    func setupTextField() {
        textField = UITextField(frame: CGRect(x: 45, y: 100, width: 300, height: 40))
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter a value to send.."
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupButton() {
        let button = UIButton(type: .custom)
        button.setTitle("SEND THE VALUE TO THE FLUTTER", for: .normal)
        button.backgroundColor = .systemOrange
        button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            button.widthAnchor.constraint(equalToConstant: 300),
            button.heightAnchor.constraint(equalToConstant: 40),
            textField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func showFlutter() {
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true, completion: nil)
    }

    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let message = textField.text ?? ""
        if call.method == "getText" {
            result(message)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
