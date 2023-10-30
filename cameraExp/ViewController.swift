//
//  ViewController.swift
//  cameraExp
//
//  Created by Ярослав on 30.10.2023.
//

import UIKit
import AVFoundation

fileprivate enum Constants {
    static let  circleSize: CGFloat = 300
}

class ViewController: UIViewController {
    var captureSession: AVCaptureSession!
    
    var previewLayer1: AVCaptureVideoPreviewLayer!
    var previewLayer2: AVCaptureVideoPreviewLayer!
    var previewLayer3: AVCaptureVideoPreviewLayer!

    var sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInteractive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraView()
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func setupCameraView() {
        captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("No camera available.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(output)
            
            previewLayer1 = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer1.videoGravity = .resizeAspectFill
            previewLayer1.frame = view.bounds
            view.layer.addSublayer(previewLayer1)
            
            previewLayer2 = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer2.videoGravity = .resizeAspectFill
            previewLayer2.frame = CGRect(x: UIScreen.main.bounds.width / 2 - Constants.circleSize / 2,
                                         y: UIScreen.main.bounds.height / 2 - Constants.circleSize / 2,
                                         width: Constants.circleSize,
                                         height: Constants.circleSize)
            previewLayer2.cornerRadius = 150
            view.layer.addSublayer(previewLayer2)
            
            sessionQueue.async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print(error)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle captured video frames here
        // You can process the frames or display them in the UIImageView
    }
}
