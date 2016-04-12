/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further UI
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    //	MARK: Properties - State
    
    private var statusPosition = CGPoint.zero
    private var spinnerPosition = CGPoint.zero
    private var loginButtonFrame = CGRect.zero
    private var loginButtonBackgroundColor = UIColor.blackColor()
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.hidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .Center
        status.addSubview(label)
        
        //  save initial properties
        statusPosition = status.center
        spinnerPosition = spinner.center
        loginButtonFrame = loginButton.frame
        loginButtonBackgroundColor = loginButton.backgroundColor!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        heading.center.x -= view.bounds.width
        username.center.x -= view.bounds.width
        password.center.x -= view.bounds.width
        
        loginButton.center.y += 30.0
        loginButton.alpha = 0.0
        
        cloud1.alpha = 0.0
        cloud2.alpha = 0.0
        cloud3.alpha = 0.0
        cloud4.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 3.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.heading.center.x += self.view.bounds.width
            self.cloud1.alpha = 1.0
            self.cloud4.alpha = 1.0
            }, completion: { _ in
                self.animateCloud(self.cloud1)
                self.animateCloud(self.cloud4)
        })
        
        UIView.animateWithDuration(0.5, delay: 3.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.username.center.x += self.view.bounds.width
            self.cloud2.alpha = 1.0
            }, completion: { _ in
                self.animateCloud(self.cloud2)
        })
        
        UIView.animateWithDuration(0.5, delay: 3.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.password.center.x += self.view.bounds.width
            self.cloud3.alpha = 1.0
            }, completion: { _ in
                self.animateCloud(self.cloud3)
        })
        
        UIView.animateWithDuration(0.5, delay: 3.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y -= 30.0
            self.loginButton.alpha = 1.0
            }, completion: nil)
        
        
    }
    
    // MARK: further methods
    
    private func animateCloud(cloud: UIImageView) {
        //  it should take a cloud 10 seconds to move across the enitre width of the screen
        let offset = view.bounds.maxX - cloud.frame.minX
        let animationDuration = NSTimeInterval(offset / view.bounds.width) * 10.0
        
        UIView.transitionWithView(cloud, duration: animationDuration, options: [], animations: {
            
            cloud.frame = cloud.frame.offsetBy(dx: offset, dy: 0.0)
            }, completion: { _ in
                //  once the cloud reaches the edge we start it back at the beginning
                cloud.frame = cloud.frame.offsetBy(dx: -(self.view.bounds.width + (cloud.frame.width * 2.0)), dy: 0.0)
                self.animateCloud(cloud)
        })
    }
    
    private func resetForm() {
        
        //  hide the banner
        UIView.transitionWithView(status, duration: 1/3, options: [.CurveEaseInOut, .TransitionFlipFromBottom], animations: { 
            self.status.hidden = true
            }, completion: nil)
        
        //  reset the login button
        UIView.animateWithDuration(1/3, animations: { 
            self.spinner.alpha = 0.0
            self.spinner.center = self.spinnerPosition
            self.loginButton.frame = self.loginButtonFrame
            self.loginButton.backgroundColor = self.loginButtonBackgroundColor
            }, completion: nil)
        
    }
    
    private func displayNextMessage(atIndex index: Int) {
        UIView.animateWithDuration(1/3, animations: {
            //  animate the banner off screen
            self.status.center.x += self.view.frame.size.width
            }, completion: { _ in
                //  restore the banner to it's original position, hiding it first so people can't see it
                self.status.hidden = true
                self.status.center = self.statusPosition
                
                //  show the next message
                self.showMessage(atIndex: index)
        })
    }
    
    private func showMessage(atIndex index: Int) {
        label.text = messages[index]
        
        UIView.transitionWithView(status, duration: 1/3, options: [.CurveEaseOut, .TransitionFlipFromTop], animations: {
            self.status.hidden = false
            }, completion: { _ in
                //  mimic a real authentication process by removing this message after an aribtrary amount of time and diplaying the next
                delay(seconds: 2.0) {
                    let nextIndex = index + 1
                    //  if there is a next message we show it
                    if nextIndex < self.messages.count  {
                        self.displayNextMessage(atIndex: nextIndex)
                    } else {
                        //  otherwise we reset the form
                        self.resetForm()
                    }
                }
                
        })
    }
    
    @IBAction func login() {
        view.endEditing(true)
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: { 
            self.loginButton.bounds.size.width += 80.0
            }, completion: { _ in
                self.showMessage(atIndex: 0)
        })
        
        UIView.animateWithDuration( 1/3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: { 
            self.loginButton.center.y += 60.0
            self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
            self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height / 2.0)
            self.spinner.alpha = 1.0
            }, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField.becomeFirstResponder()
        return true
    }
    
}
