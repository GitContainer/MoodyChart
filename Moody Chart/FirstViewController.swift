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

class FirstViewController: UIViewController {

    
    @IBOutlet weak var ReynoldsNumber: UITextField!
    @IBOutlet weak var RelativeRoughness: UITextField!
    @IBOutlet weak var Results: UILabel!
    
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
        var n: Int
        
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

