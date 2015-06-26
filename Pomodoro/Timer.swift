class Timer:Printable{
    let initialMinutes:Int
    let initialSeconds:Int
    
    var minutes:Int
    var seconds:Int

    init(minutes:Int,seconds:Int){
        self.initialMinutes = minutes
        self.initialSeconds = seconds
        
        self.minutes = minutes
        self.seconds = seconds
    }
    
    func decrease(){
        if(!finished){
            if(seconds == 0){
                minutes--
                seconds=59
            }
            else{
                seconds--
            }
        }
    }
    
    func set(#minutes:Int,seconds:Int){
        self.minutes = minutes
        self.seconds = seconds
    }
    
    func reset(){
        set(minutes:initialMinutes,seconds: initialSeconds)
    }
    
    var finished:Bool{
        return minutes == 0 && seconds == 0
    }
    
    var progress:Float{
        return 1 - Float(minutes * 60 + seconds) / Float(initialMinutes * 60 + initialSeconds)
    }
    
    var description: String {
        return String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}