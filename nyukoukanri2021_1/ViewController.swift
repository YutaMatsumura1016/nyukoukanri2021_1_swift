import UIKit
import WebKit

class ViewController: UIViewController {
    
    //初期化
    var gate: String = "str"
    
    //ボタンの設定
    @IBOutlet weak var buttonWaseda: UIButton!
    @IBOutlet weak var buttonToyama: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonFinishLogin: UIButton!
    @IBOutlet weak var loginWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonFinishLogin.isHidden = true
    }
    
    
    //ボタン押された
    @IBAction func Waseda(_ sender: Any) {
        gate = "waseda"
        performSegue(withIdentifier: "toWaseda", sender: nil)
    }
    @IBAction func Toyama(_ sender: Any) {
        gate = "toyama"
        performSegue(withIdentifier: "toToyama", sender: nil)
    }
    @IBAction func Login(_ sender: Any) {
        let sentURL = "https://docs.google.com/presentation/d/1zWIrRnRylBew4BxDK2JOnsD4awodRSGvhDuUeRDpY3A/edit?usp=sharing"
        let encordedURL = sentURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let URL = NSURL(string: encordedURL!)
        let request = NSURLRequest(url: URL! as URL)

        loginWebView.load(request as URLRequest)
        buttonFinishLogin.isHidden = false
        buttonWaseda.isHidden = true
        buttonToyama.isHidden = true
        buttonLogin.isHidden = true
    }
    @IBAction func closeWebView(_ sender: Any) {
        loginWebView.isHidden = true
        buttonFinishLogin.isHidden = true
        buttonLogin.isHidden = true
        buttonWaseda.isHidden = false
        buttonToyama.isHidden = false
    }


    //画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let read: readViewController = (segue.destination as? readViewController)!
        read.gate = gate
    }
}

