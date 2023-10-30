//
//  ViewController.swift
//  cameraExp
//
//  Created by Ярослав on 30.10.2023.
//

import UIKit
import AVFoundation

fileprivate enum Constants {
    static let circleSize: CGFloat = UIScreen.main.bounds.width - 50
    static let circleSizeSmall: CGFloat = UIScreen.main.bounds.width - 200
}

class ViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInteractive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setupCameraView()
        animateCameraLayer()
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
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = CGRect(x: UIScreen.main.bounds.width / 2 - Constants.circleSize / 2,
                                         y: UIScreen.main.bounds.height / 2 - Constants.circleSize / 2,
                                         width: Constants.circleSize,
                                         height: Constants.circleSize)
            previewLayer.cornerRadius = Constants.circleSize / 2
            
            view.layer.addSublayer(previewLayer)
            
            sessionQueue.async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print(error)
        }
    }
    
    func animateCameraLayer() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.75
        scaleAnimation.duration = 0.25
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        previewLayer.add(scaleAnimation, forKey: "transform.scale")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle captured video frames here
        // You can process the frames or display them in the UIImageView
    }
}
