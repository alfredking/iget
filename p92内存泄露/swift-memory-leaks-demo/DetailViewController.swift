import UIKit

class DetailViewController: UIViewController {
  
  var viewModel: DetailViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //循环引用
    print("DetailViewController loaded ...")
    viewModel = DetailViewModel(name: "Jian", presenter: self)
    
  }
  
  deinit {
    print("DetailViewController dealloc ...")
  }
}
