//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by 윤병일 on 2021/08/11.
//

import UIKit
import AVFoundation
import SnapKit

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  //MARK: - Properties

  var video = AVCaptureVideoPreviewLayer()
  
  let myView : UIView = {
    let view = UIView()
    return view
  }()
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    createSession()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  //MARK: - Functions
  
  private func configureUI() {
    view.backgroundColor = .white
    
    view.addSubview(myView)
//    myView.snp.makeConstraints {
//      $0.center.equalToSuperview()
//      $0.width.height.equalTo(100)
//    }
    myView.center = view.center
    myView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    
//    myView.frame = CGRect(x: 20, y: 0, width: 50, height: 50)
  }
  
  private func createSession() {
    
    // Creating session
    let session = AVCaptureSession()
    
    // Define capture device
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
        return
    }
  
    do {
      let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
      session.addInput(input)
    } catch {
      print("Error")
    }
    
    let output = AVCaptureMetadataOutput()
    session.addOutput(output)
    
    output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    
    video = AVCaptureVideoPreviewLayer(session: session)
    
    video.frame = view.layer.bounds
    view.layer.addSublayer(video)
//    self.view.bringSubviewToFront(myView)
    
    session.startRunning()
  }
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//    if metadataObjects != nil && metadataObjects.count != nil {
//      if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
    if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
        if object.type == AVMetadataObject.ObjectType.qr {
          let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
          alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { _ in
            UIPasteboard.general.string = object.stringValue
          }))
          
          present(alert, animated: true, completion: nil)
        }
      }
//    }
  }
}

