
import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTabBars()
        
        
    }
    
    //设置底部显示
    func setTabBars(){
        //电影
        let Movie       = MainViewController()
        let MovieNav    = UINavigationController(rootViewController: Movie)
        let MovieTabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 1)
        MovieNav.tabBarItem = MovieTabBarItem
        
        //改变
        let Change      = ChangesViewController()
        let ChangeNav   = UINavigationController(rootViewController: Change)
        let ChangeTabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.MostViewed, tag: 2)
        ChangeNav.tabBarItem = ChangeTabBarItem
        
        let Rank        = RankViewController()
        let RankNav     = UINavigationController(rootViewController: Rank)
        let RankTabBarItem  = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.More, tag: 4)
        RankNav.tabBarItem  = RankTabBarItem
        
        
        //用户界面
        let User        = UserViewController()
        let UserTabBarItem = UITabBarItem(title: "我", image: UIImage(named: "tabbar_me"), tag: 0)
        User.tabBarItem = UserTabBarItem
        let UserNav     = UINavigationController(rootViewController: User)
        
    
        
        
        let vc = [
            MovieNav,
            ChangeNav,
            RankNav,
            UserNav
        ]
        
        self.setViewControllers(vc, animated: true)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
