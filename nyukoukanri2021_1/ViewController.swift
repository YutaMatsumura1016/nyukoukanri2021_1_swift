import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{
    
    //初期化
    var gate: String = "str"
    
    //ボタンの設定
    @IBOutlet weak var buttonWaseda: UIButton!
    @IBOutlet weak var buttonToyama: UIButton!
    @IBOutlet weak var buttonKougai: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonFinishLogin: UIButton!
    @IBOutlet weak var loginWebView: WKWebView!
    @IBOutlet weak var kidou_ue: UIImageView!
    @IBOutlet weak var kidou_shita: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.isHidden = true
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
    @IBAction func Kougai(_ sender: Any) {
        gate = "kougai"
        performSegue(withIdentifier: "toKougai", sender: nil)
    }
    @IBAction func Login(_ sender: Any) {
        loginWebView.isHidden = false

        
        let sentURL = "https://script.google.com/a/wasedasai.net/macros/s/AKfycbzaVnrwI0sa0CUYjsz-PNF9sdiyTPZtVP6CC_ZzA3f2vpFMdC4/exec"



        let encordedURL = sentURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let URL = NSURL(string: encordedURL!)
        let request = NSURLRequest(url: URL! as URL)

        loginWebView.load(request as URLRequest)
        loginWebView.navigationDelegate = self
        loginWebView.scrollView.bounces = false

        buttonFinishLogin.isHidden = false
        buttonWaseda.isHidden = true
        buttonToyama.isHidden = true
        buttonKougai.isHidden = true
        buttonLogin.isHidden = true
        kidou_ue.isHidden = true
        kidou_shita.isHidden = true
    }
    @IBAction func closeWebView(_ sender: Any) {
        loginWebView.isHidden = true
        buttonFinishLogin.isHidden = true
        buttonLogin.isHidden = true
        buttonWaseda.isHidden = false
        buttonToyama.isHidden = false
        buttonKougai.isHidden = false
        kidou_ue.isHidden = false
        kidou_shita.isHidden = false
    }


    func openURL(urlString: String){
        let URL = URL(string: urlString)
        let request = NSURLRequest(url: URL!)
        loginWebView.load(request as URLRequest)
        loginWebView.navigationDelegate = self
    }
    
    //画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let read: readViewController = (segue.destination as? readViewController)!
        read.gate = gate
    }
}

