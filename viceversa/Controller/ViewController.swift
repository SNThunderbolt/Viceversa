//
//  ViewController.swift
//  viceversa
//
//  Created by SajedeNouri on 3/4/1397 AP.
//  Copyright © 1397 AP SajedeNouri. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import CoreData

enum StateOfTheGame {
    case ready
    case playing
    case correctChoice
    case wrongChoice
    case timesUp
}

enum TimerState {
    case stopped
    case running
}


class ViewController: UIViewController {

   // @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgressView: MBCircularProgressBarView!
    @IBOutlet weak var challengeImage: UIImageView!
   
    @IBOutlet weak var stateButtonLabel: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var upBtnOutlet: UIButton!
    @IBOutlet weak var rightBtnOutlet: UIButton!
    @IBOutlet weak var leftBtnOutlet: UIButton!
    @IBOutlet weak var downBtnOutlet: UIButton!
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    private var challengeDirection = String()
    private let directionArray = ["left", "right", "up", "down"]
    private var state = StateOfTheGame.ready
    
    private var timer = Timer()
    private var countDownTimer = Timer()
    private var isTimerRunning = false
    private var timerState = TimerState.stopped
    
    private let startingTimerValue = 2.0
    private var level = 1
    private var score: Int32 = 0
    private var highScore: Int32 = 0
    
    private var seconds = 5.0
    private var countDownSeconds = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<HighScore> = HighScore.fetchRequest()
        do {
            let fetchedHighScore = try PersistentService.context.fetch(fetchRequest)
            //TO DO: fetchedHighScores is an array! get rid of the unnecessary ones
            if let hScore = fetchedHighScore.last {
                self.highScore = hScore.highScoreValue
                highScoreLabel.text = "High Score:" + String(self.highScore)
            }
            
        } catch {
            print("error in fetching high score...")
        }
        InitializeTheGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func helpBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        //TO DO: First Start a Countdown for user
        stateButtonLabel.isHidden = true
        InitilizeScoreAndLevel()
        updateUI()
        getReadyForGame()
        
        
    }
    
    @IBAction func upBtnPressed(_ sender: Any) {
        if state == StateOfTheGame.playing {
            stopTimer()
            BtnPressed(direction: "up")
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.upBtnOutlet.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.upBtnOutlet.transform = CGAffineTransform.identity
            })
        })
    }
    
    @IBAction func downBtnPressed(_ sender: Any) {
        if state == StateOfTheGame.playing {
            stopTimer()
            BtnPressed(direction: "down")
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.downBtnOutlet.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.downBtnOutlet.transform = CGAffineTransform.identity
            })
        })
    }
    
    @IBAction func rightBtnPressed(_ sender: Any) {
         if state == StateOfTheGame.playing {
            stopTimer()
            BtnPressed(direction: "right")
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.rightBtnOutlet.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.rightBtnOutlet.transform = CGAffineTransform.identity
            })
        })
    }
    
    @IBAction func leftBtnPressed(_ sender: Any) {
        if state == StateOfTheGame.playing {
            stopTimer()
            BtnPressed(direction: "left")
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.leftBtnOutlet.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.leftBtnOutlet.transform = CGAffineTransform.identity
            })
        })
    }
    
    func BtnPressed(direction: String) {
        if checkIfButtonPressedCurrectly(selectedDirection: direction) {
            score += 1
            level = calculateLevel(score: score)
            
            //TO DO :  implement the timer value generator function
            seconds = calculateSeconds(score: score)
            state = StateOfTheGame.playing
            UIView.transition(with: challengeImage, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.challengeImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.challengeImage.image = UIImage(named: self.generateDirection())
            }, completion: {_ in
                UIView.animate(withDuration: 0.1, animations: {
                self.challengeImage.transform = CGAffineTransform.identity
                })   
            })
            
            
            runTimer()
        } else {
            state = StateOfTheGame.wrongChoice
            presentMessageToUser(msg: "Oops!\n Next Time!")
            InitializeTheGame()
        }
        highScoreManager()
        updateUI()
    }
    func calculateSeconds(score: Int32) -> Double {
        var result : Double = 0.0
        seconds = 1.5 + pow(sqrt(Double(1/score)), 3)//(pow(1/(score)),(0.5)) as Double// + ((1/score)^(1.25))
        if score < 10 {
            result = 1.5 + 2 * (1/Double(score)) - (1/pow(Double(score), 2))
            
        } else if score >= 10 && score < 20 {
            result = 1.2 + 2 * (1/Double(score - 9)) - (1/pow(Double(score - 9), 2))
            
        } else if score >= 20 && score < 40 {
            result = 1 + 2 * (1/Double(score - 19)) - (1/pow(Double(score - 19), 2))
            
        } else if score >= 40 && score < 60 {
            result = 0.85 + 2 * (1/Double(score - 39)) - (1/pow(Double(score - 39), 2))
            
        } else if score >= 60 && score < 80 {
            result = 0.7 + 2 * (1/Double(score - 59)) - (1/pow(Double(score - 59), 2))
            
        } else if score >= 80 && score < 90  {
            result = 0.55 + 2 * (1/Double(score - 79)) - (1/pow(Double(score - 79), 2))
            
        } else {
            result = 0.3 + 2 * (1/Double(score - 89)) - (1/pow(Double(score - 89), 2))
        }
        print ("score: \(score) , result: \(result) seconds")
        //DEBUG: result = 5
        //result = 5.0
        return result
    }
    
    
    func getReadyForGame() {
        countDownReady()
        updateCountDownTimer()
    }
    
    func startTheGame() {
        state = StateOfTheGame.playing
        stateButtonLabel.isHidden = true
        InitilizeScoreAndLevel()
        challengeImage.image = UIImage(named: generateDirection())
        runTimer()
    }
    
    func calculateLevel(score: Int32) -> Int {
        var lvl = 1
        lvl = Int(score / 10)
        if level >= 10 {
            gameIsFinished()
        }
        return lvl
    }
    
    func gameIsFinished() {
        stopTimer()
        performSegue(withIdentifier: "VictoryVC", sender: nil)
    }
    
    func presentMessageToUser(msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.resetTimer()
        }
        
        alertController.addAction(okBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkIfButtonPressedCurrectly(selectedDirection: String) -> Bool {
        var result = false
        switch challengeDirection {
        case "up":
            if selectedDirection == "down" {
                result = true
            }
            break
        case "down":
            if selectedDirection == "up" {
                result = true
            }
            break
        case "right":
            if selectedDirection == "left" {
                result = true
            }
            break
        case "left":
            if selectedDirection == "right" {
                result = true
            }
            break
            
        default:
            result = false
        }
        return result
    }
    
    func generateDirection() -> String {
        let index = Int(arc4random_uniform(4))
        challengeDirection = directionArray[index]
        return challengeDirection
    }
    func countDownReady() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: (#selector(ViewController.updateCountDownTimer)), userInfo: nil, repeats: true)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDownTimer() {
        countDownLabel.isHidden = false
        challengeImage.isHidden = true
        countDownSeconds -= 1
        if countDownSeconds > 2 {
            
            countDownLabel.text = String(countDownSeconds - 2)
            
        } else if countDownSeconds == 2 {
            
            countDownLabel.text = "Ready?"
            
        } else if countDownSeconds == 1 {
            
            countDownLabel.text = "Go!"
            
        } else {
            challengeImage.isHidden = false
            countDownLabel.isHidden = true
            countDownTimer.invalidate()
            countDownSeconds = 6
            startTheGame()
        }
    }
    
    @objc func updateTimer() {
        seconds -= 0.01
        if seconds < 0 {
            timer.invalidate()
            resetTimer()
            presentMessageToUser(msg: "Time's Up!")
            InitializeTheGame()
        }
        timerProgressView.value = CGFloat(seconds)
    }
    
    func stopTimer() {
        timer.invalidate()
        resetTimer()
    }
    
    func resetTimer() {
        seconds = startingTimerValue
        timerProgressView.maxValue = CGFloat(startingTimerValue)
    }
    
    func InitializeTheGame() {
        stopTimer()
        resetTimer()
        state = StateOfTheGame.ready
        stateButtonLabel.titleLabel!.text = "Start!"
        stateButtonLabel.isHidden = false
    }
    
    func InitilizeScoreAndLevel() {
        
        score = 0
        level = 1
        
//        //DEBUG
//        score = 92
//        level = 9
    }
    
    func highScoreManager() {
        if score > highScore {
            highScore = score
            let hScoreContext = HighScore(context: PersistentService.context)
            hScoreContext.highScoreValue = highScore
            PersistentService.saveContext()
        }
    }
    
    func updateUI() {
        scoreLabel.text = "Score: " + String(score)
        levelLabel.text = "Level: " + String(level)
        highScoreLabel.text = "High Score: " + String(highScore)
    }
}

