//
//  ViewController.swift
//  Post-Brexit
//
//  Created by Richard Stelling on 18/12/2019.
//  Copyright © 2019 Miranda Evans & Lionheart Applications Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Error: Swift.Error {
        case failedToCreateImage
    }
    
    private lazy var ukFont = UIFont(name: "Post-BrexitUK", size: 17.0)
    private lazy var euFont = UIFont(name: "Post-BrexitEU", size: 17.0)
    
    private lazy var ukButton = UIBarButtonItem(title: "🇬🇧", style: .plain, target: self, action: #selector(onUK(_:)))
    private lazy var euButton = UIBarButtonItem(title: "🇪🇺", style: .plain, target: self, action: #selector(onEU(_:)))
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = self.ukButton
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    @objc
    private func onUK(_ sender: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem = self.euButton
        self.textView.font = self.euFont
    }

    @objc
    private func onEU(_ sender: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem = self.ukButton
        self.textView.font = self.ukFont
    }
    
    @IBAction func onAction(_ sender: UIBarButtonItem) {
        
        do {
            let image = try self.snapshotText()
            let items = [image]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        }
        catch {
            return
        }
    }
    
    
    private func snapshotText() throws -> UIImage {
        
        guard let snap = self.textView.snapshot else { throw Error.failedToCreateImage }
        
        return snap
        
    }
}
extension UIView {
    
    public func snapshot(at scale: CGFloat) -> UIImage? {
        // Setting the scale of the image context determines what size the final image will be, we need
        // as-big-as-possible because it will be printed
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc var snapshot: UIImage? {
        return self.snapshot(at: 3.0)
    }
}
