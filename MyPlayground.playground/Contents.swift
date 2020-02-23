import UIKit
import PlaygroundSupport

//p117,p118 playground
//import safeArray
//PlaygroundPage.current.needsIndefiniteExecution = true
//var str = "Hello, playground"
//
// print("hello ,Swift")

//for var x in 1...100 {
//    var y = arc4random()%100
//
//
//}



//let url = URL(string: "https://www.baidu.com")
//let task = URLSession.shared.dataTask(with: url!){(data, response,error) in
//do{
//    let dictionary  = try JSONSerialization.jsonObject(with: data!, options: [])
//    print("sucess")
//    print(dictionary)
//}
//catch
//{
//    print("error !")
//
//}
//}
//
//task.resume()

//p118
class ViewController :UITableViewController
{
    override func viewDidLoad() {
        super .viewDidLoad()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //为什么这里有个问号
        cell.textLabel?.text = "\(Int(arc4random_uniform(100)))"
        return cell

    }
}

PlaygroundPage.current.liveView = ViewController()
//点双环才能显示界面



// Thread-unsafe array
//do {
//    var array = [Int]()
//    var iterations = 1000
//    let start = Date().timeIntervalSince1970
//
//    DispatchQueue.concurrentPerform(iterations: iterations) { index in
//        let last = array.last ?? 0
//        array.append(last + 1)
//
//        DispatchQueue.global().sync {
//            iterations -= 1
//
//            // Final loop
//            guard iterations <= 0 else { return }
//            let message = String(format: "Unsafe loop took %.3f seconds, count: %d.",
//                                 Date().timeIntervalSince1970 - start,
//                                 array.count)
//            print(message)
//        }
//    }
//}

// Thread-safe array
//do {
//    var array = SafeArray<Int>()
//    var iterations = 1000
//    let start = Date().timeIntervalSince1970
//
//    DispatchQueue.concurrentPerform(iterations: iterations) { index in
//        let last = array.last ?? 0
//        array.append(last + 1)
//
//        DispatchQueue.global().sync {
//            iterations -= 1
//
//            // Final loop
//            guard iterations <= 0 else { return }
//            let message = String(format: "Safe loop took %.3f seconds, count: %d.",
//                                 Date().timeIntervalSince1970 - start,
//                                 array.count)
//            print(message)
//        }
//    }
//}



