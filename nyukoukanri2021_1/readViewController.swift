import UIKit
import WebKit
import CoreNFC

class readViewController: UIViewController, NFCTagReaderSessionDelegate, WKNavigationDelegate{

    //初期化
    var session: NFCTagReaderSession?
    var gate: String = "str"
    var sentURL: String = "str"{
        didSet{
            openURL(urlString: sentURL)
        }
    }

    @IBOutlet weak var reLoad: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var ueWaseda: UIImageView!
    @IBOutlet weak var ueToyama: UIImageView!
    @IBOutlet weak var ueGakkan: UIImageView!
    @IBOutlet weak var ueKougai: UIImageView!
    
    //関数
    override func viewDidLoad() {
        super.viewDidLoad()
        readNFC()
        
        if gate == "waseda"{
            ueToyama.isHidden = true
            ueKougai.isHidden = true
            ueGakkan.isHidden = true
        }else if gate == "toyama"{
            ueWaseda.isHidden = true
            ueKougai.isHidden = true
            ueGakkan.isHidden = true
        }else if gate == "kougai"{
            ueWaseda.isHidden = true
            ueToyama.isHidden = true
            ueGakkan.isHidden = true
        }
    }
    
    @IBAction func reLoad(_ sender: Any) {
        readNFC()
    }
    
    func openURL(urlString: String){
        let URL = URL(string: urlString)
        let request = NSURLRequest(url: URL!)
        webView.load(request as URLRequest)
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        readNFC()
    }
    

    func readNFC(){
        self.session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
        self.session?.begin()
    }
    
    
    
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("読み取りを開始したツノ！")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError{
            if(readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)&&(readerError.code != .readerSessionInvalidationErrorUserCanceled){
                let alertMessage = UIAlertController(
                    title: "エラーが発生したツノ",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertMessage.addAction(UIAlertAction(title: "わかったツノ...", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertMessage, animated: true, completion: nil)
                }
            }
        }
        self.session = nil
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("カードが見つかったツノ！")
        
        if(tags.count > 1){
            let retryInterval = DispatchTimeInterval.milliseconds(200)
            session.alertMessage = "複数枚のカードが見つかったツノ。1枚で試してほしいツノ！"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        let tag = tags.first!
        
        session.connect(to: tag){(error) in
            if nil != error{
                session.invalidate(errorMessage: "接続エラーツノ。もう一度試してほしいツノ！")
                return
            }
            
            guard case .feliCa(let feliCaTag) = tag else{
                let retryInterval = DispatchTimeInterval.milliseconds(200)
                session.alertMessage = "このカードには対応してないツノ..."
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                })
                return
            }
            
            let idmString0: String = feliCaTag.currentIDm.map{String(format: "%.2hhx", $0)}.joined()
            let idmString = "0" + (idmString0.uppercased().dropFirst(1))
            
            session.alertMessage = idmString
            session.invalidate()
            
            Thread.sleep(forTimeInterval: 1.3)
            self.sentURL = "https://script.google.com/a/wasedasai.net/macros/s/AKfycbzdl8gVXhd2Dkqy1B6-rTGKD_ewKWpS2FimTIkZiOA2bVf_IQo/exec?idm=" + idmString + "&&gate=" + self.gate

        }
    }
    


}
