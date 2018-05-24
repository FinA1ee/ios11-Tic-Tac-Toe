//
//  gamePage.swift
//  Tic_Tac_Toe
//
//  Created by Yuchen Zhu on 2018-05-17.
//  Copyright © 2018 Momendie. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class gamePage: UIViewController {

   
    @IBOutlet weak var gridImage: UIImageView!

    
    @IBOutlet var buttonArray: [UIButton]!
    
    
    @IBOutlet weak var displayGamingStatus: UILabel!
    
    
    var isGameOver : Bool! = false
    var gameOneTurn : Bool! = true
    var totalMove : Int = 0;
    var playerOneTaken = [Int]()
    var playerTwoTaken = [Int]()
    var winCondition = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    var player: AVAudioPlayer?
    var winningSubArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gridImage.image = UIImage(named: "grid")
        playSound(noteToPlay: "start")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressOnGrid(_ sender: UIButton) {
        let clickedButton : UIButton = buttonArray[sender.tag - 1]
        if(checkIfValid(myButton: clickedButton) == false ||
            isGameOver == true){
            displayGamingStatus.text = "Invalid Move."
            return
        }
        
        if(gameOneTurn == true){
            clickedButton.setImage(UIImage(named : "circle"), for: .normal)
            playerOneTaken.append(sender.tag)
            playSound(noteToPlay: "circleSound")
            if checkWin(player : "One") == true{
                displayGamingStatus.text = "Game Over. Player One Wins."
                playSound(noteToPlay: "win")
                isGameOver = true
                return
            }
            gameOneTurn = false;
            displayGamingStatus.text = "Player Two's Turn."
        } else {
           clickedButton.setImage(UIImage(named : "cross"), for: .normal)
            playerTwoTaken.append(sender.tag)
            playSound(noteToPlay: "crossSound")
            if checkWin(player : "Two") == true{
                displayGamingStatus.text = "Game Over. Player Two Wins."
                playSound(noteToPlay: "win")
                isGameOver = true
                return
            }
            gameOneTurn = true
            displayGamingStatus.text = "Player One's Turn"
        }
        totalMove += 1
        if totalMove == 9 {
            displayGamingStatus.text = "Draw Game. Click to Restart."
            isGameOver = true
            playSound(noteToPlay: "draw")
        }
    }
    
    
    func checkIfValid(myButton : UIButton) -> Bool{
        if myButton.hasImage(named: "circle", for: .normal) ||
            myButton.hasImage(named: "cross", for: .normal){
            return false
        }
        return true
    }
    
    
    func checkSubArray(subArray : [Int], mainArray : [Int]) -> Bool{
        for item in subArray {
            if mainArray.contains(item) == false{
                return false
            }
        }
        winningSubArray = subArray
        print(winningSubArray)
        return true
    }
    
    
    func checkWin(player : String) -> Bool{
        if player == "One"{
            for item in winCondition{
                if checkSubArray(subArray: item, mainArray: playerOneTaken) == true{
                    draw(winningPath: winningSubArray)
                    return true
                }
            }
            return false
        }
        else {
            for item in winCondition{
                if checkSubArray(subArray: item, mainArray: playerTwoTaken) == true{
                    draw(winningPath: winningSubArray)
                    return true
                }
            }
            return false
        }
    }
    
    
    func restartGame(){
        playSound(noteToPlay: "restart")
        deleteDrawing()
        totalMove = 0
        for item in buttonArray{
            item.setImage(UIImage(named: " "), for: .normal)
        }
        playerOneTaken = []
        playerTwoTaken = []
        isGameOver = false
        gameOneTurn = true
    }
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        restartGame()
    }
    
    
    func playSound(noteToPlay : String) {
        guard let url = Bundle.main.url(forResource: noteToPlay, withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    weak var shapeLayer: CAShapeLayer?
    
    
    func draw(winningPath : [Int]){
        print(winningPath)
        if winningPath == [1, 5, 9]{
            drawLine(x0:45, y0:198, x1:293, y1:455)
        }
        if winningPath == [3, 5, 7]{
            drawLine(x0:293, y0:198, x1:45, y1:455)
        }
        if winningPath == [2, 5, 8]{
            drawLine(x0:175, y0:178, x1:175, y1:472)
        }
        if winningPath == [3, 6, 9]{
            drawLine(x0:293, y0:178, x1:293, y1:472)
        }
        if winningPath == [1, 4, 7]{
            drawLine(x0:57, y0:178, x1:57, y1:472)
        }
        if winningPath == [1, 2, 3]{
            drawLine(x0:40, y0:203, x1:298, y1:203)
        }
        if winningPath == [4, 5, 6]{
            drawLine(x0:40, y0:325, x1:298, y1:325)
        }
        if winningPath == [7, 8, 9]{
            drawLine(x0:40, y0:447, x1:298, y1:447)
        }
    }
    
    
    func deleteDrawing(){
        self.shapeLayer?.removeFromSuperlayer()
    }
    
    func drawLine(x0 : Int, y0 : Int ,x1 : Int, y1 : Int) {
        // remove old shape layer if any
        
        
        
        // create whatever path you want
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x0, y: y0))
        path.addLine(to: CGPoint(x: x1, y: y1))
 //       path.addLine(to: CGPoint(x: 200, y: 240))
        
        // create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.path = path.cgPath
        
        // animate it
        
        view.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.7
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        
        self.shapeLayer = shapeLayer
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
