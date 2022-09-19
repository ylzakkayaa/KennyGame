//
//  ViewController.swift
//  KennyGame
//
//  Created by Yeliz Akkaya on 17.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var random = Int()
    var timer = Timer()
    var timerKenny = Timer()
    var counter = 0
    var kennyArray = [UIImageView]()
    var score = 0
    var highScore = 0
    var touchImage = false
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    var kennyIsClicked = [false,false,false,false,false,false,false,false,false]
    //Buradaki her bir deger, kenny'e tıklandı mı onu gosteriyor. Yani ilk false degeri kenny1'in degeri, ikinci false degeri ise kenny2'nin degeri.

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScoreLabel.text = "Score: \(score)"
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highScore = 0
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        
        kennyArray = [kenny1, kenny2, kenny3, kenny4, kenny5, kenny6, kenny7, kenny8, kenny9]

  
        //Burada kullandıgım enumerated ozel bir fonksiyon. Arraydeki elemanların hem indexini hem de degerini veriyor. Bu indexi kullanabilirsin.
        for (index,kenny) in kennyArray.enumerated(){
            kenny.isUserInteractionEnabled = true
            //Burada en altta kendi olusturdugum MyTapGesture detector'ı kullandım. Bu recognizer'ın bir index degeri de var.
            let recognizer = MyTapGesture(target: self, action: #selector(self.increaseScoreAll(sender:)))
            kenny.addGestureRecognizer(recognizer)
            //her bir recognizer'a arraydeki indexini atadım.
            recognizer.index = index
        }
        
        
        
        counter = 10
        timeLabel.text = "Time: \(counter)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        timerKenny = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(hideKenny), userInfo: nil, repeats: true)
        hideKenny()
    }
    
    @objc func timerFunction(){
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter == -1 {
            timer.invalidate()
            timerKenny.invalidate()
            timeLabel.text = "Time's Over."
            
            if self.score > self.highScore {
                self.highScore = self.score
                highscoreLabel.text = "Highscore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore")
            }
            makeAlert(titleInput: "Time's Up", messageInput: "Do you want to play again?")
        }
    }
    
    @objc func hideKenny(){
        //Burada bir onceki random kenny'nin click ozelligini false yapıyorum ki tekrar bir sonraki geldiginde tıklanabilsin.
        kennyIsClicked[random] = false
        
        for kenny in kennyArray{
            kenny.isHidden = true
        }
        
        random = Int(arc4random_uniform(UInt32(kennyArray.count - 1)))
        kennyArray[random].isHidden = false
        
    }
    
    
    @objc func increaseScoreAll(sender: MyTapGesture){
        //burada sender ile gelen sey tiklanilan kenny. Index ozelligini kullanarak kontrol edebiliriz. Ayrıca kennyIsClicked arrayini kullanarak daha once tiklanmis mi
        //onu kontrol ediyoruz. Tekrar tekrar tıklanmayı engellemek icin
        if (random == sender.index && kennyIsClicked[sender.index] == false ){
            //bir kere skor aldıgımızda, kennyIsClicked arrayindeki karsiligini true yapiyoruz ki bir daha tiklanmasin.
            kennyIsClicked[sender.index] = true
            score += 1
            ScoreLabel.text = "Score: \(score)"
        }
    }
    
    func makeAlert(titleInput: String, messageInput:String)  {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
            self.score = 0
            self.ScoreLabel.text = "Score: \(self.score)"
            self.counter = 10
            self.timeLabel.text = String(self.counter)
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
            self.timerKenny = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.hideKenny), userInfo: nil, repeats: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }

}

//Burada kendi gesture detector'ımı tanımladım. Her seyi aynı sadece ekstra index var.
class MyTapGesture: UITapGestureRecognizer {
    var index = Int()
}
