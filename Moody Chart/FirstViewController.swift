//
//  FirstViewController.swift
//  Moody Chart
//
//  Created by Ilan Isakov on 1/27/17.
//
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
}

extension UIButton {
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map {$0.cgColor}
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class FirstViewController: UIViewController {

    
    @IBOutlet weak var ReynoldsNumber: UITextField!
    @IBOutlet weak var RelativeRoughness: UITextField!
    @IBOutlet weak var Results: UILabel!
    @IBOutlet weak var CalculateButtonUI: UIButton!
    @IBOutlet weak var ResultsBox: UIView!
    
   
    
    @IBAction func CalculateButton(_ sender: Any) {
        var Re: Double
        var rel_r: Double
        var result: Double
        
        if let rnT = Double(ReynoldsNumber.text!) {
            Re = rnT
        }
        else{
            Results.text = "Error: Reynolds Number not set"
            return
        }
        
        if let rrT = Double(RelativeRoughness.text!) {
            rel_r = rrT
        }
        else{
            Results.text = "Error: Relative Roughness not set"
            return
        }
        
        result = CalculateFrictionFactor(reynoldsNumber: Re, relativeRoughness: rel_r)
        
        if result == -1 {
            Results.text = "Transition Flow"
            return
        }
        
        Results.text = String(result)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapped()
        
        ResultsBox.layer.cornerRadius = 10
        ResultsBox.layer.borderWidth = 1.0
        
        
        ReynoldsNumber.layer.borderWidth = 1.0
        ReynoldsNumber.layer.cornerRadius = 5
        RelativeRoughness.layer.borderWidth = 1.0
        RelativeRoughness.layer.cornerRadius = 5
        
        //Creating Button Graphics
        //let gradientColorOne = UIColor.init(red: 0, green: 122, blue: 255, alpha: 1.0)
        //let gradientColorTwo = UIColor.init(red: 0, green: 122, blue: 255, alpha: 1.0)
        
        //CalculateButtonUI.applyGradient(colors: [gradientColorOne, gradientColorTwo] ,locations: [0.0, 1.0])
        //CalculateButtonUI.clipsToBounds = true
        CalculateButtonUI.layer.cornerRadius = 10
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CalculateFrictionFactor(reynoldsNumber: Double,relativeRoughness: Double) -> Double {
        
        if (reynoldsNumber <= 2300)
        {
            return (64/reynoldsNumber)
        }
        
        if (reynoldsNumber < 4000)
        {
            //return "transition flow"
            return -1.0
        }
        
        //(Turbulent Flow)
        var x: Double
        var y: Double
        var Dy: Double
        var A: Double
        var B: Double
        let n: Int
        
        A = (relativeRoughness/3.7)
        B = (2.51/reynoldsNumber)
        n = 3 // (default # of iterations for Newton's Method)
        
        //x = -1.8*log10((6.9/reynoldsNumber)+(A^1.11)) //initial guess
        x = (-1.8)*(log10((6.9/reynoldsNumber) + (pow(A, 1.11))))
        
        for _ in 0...n
        {
            y = x+(2*log10(A+(B*x)))
            Dy = 1+(2*(B/log(10))/(A+(B*x)))
            x = x - (y/Dy)
        }
        
        return 1/(pow(x,2))
        
    }
    

}

