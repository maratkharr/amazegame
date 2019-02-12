//
//  ViewController.swift
//  Quantum Maze
//
//  Created by Marat on 30.05.2018.
//  Copyright © 2018 Marat Kharr. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		maze = Maze(width: mySize, height: mySize)
		
		let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeRight.direction = UISwipeGestureRecognizerDirection.right
		self.view.addGestureRecognizer(swipeRight)
		
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeLeft.direction = UISwipeGestureRecognizerDirection.left
		self.view.addGestureRecognizer(swipeLeft)
		
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeDown.direction = UISwipeGestureRecognizerDirection.down
		self.view.addGestureRecognizer(swipeDown)
		
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeUp.direction = UISwipeGestureRecognizerDirection.up
		self.view.addGestureRecognizer(swipeUp)
		
		let device = UIDevice.current.systemVersion
		print(device)
		
		setUpMaze()
	}
	
	var isFirst = false
	
	func checkWin(){
		if redBall.frame.origin.x == bluewBall.frame.origin.x {
			if redBall.frame.origin.y - bluewBall.frame.origin.y == CGFloat(myW) || bluewBall.frame.origin.y - redBall.frame.origin.y == CGFloat(myW) {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
					self.Win()
				}
			}
		}
		if redBall.frame.origin.y == bluewBall.frame.origin.y {
			if redBall.frame.origin.x - bluewBall.frame.origin.x == CGFloat(myW) || bluewBall.frame.origin.x - redBall.frame.origin.x == CGFloat(myW) {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
					self.Win()
				}
			}
		}
	}
	
	func Win(){
		UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
			//Set x position what ever you want
			self.redBall.frame = CGRect(x: Int(self.bluewBall.frame.origin.x), y: Int(self.bluewBall.frame.origin.y), width: self.myW, height: self.myW)
		}, completion: nil)
		
		self.title = "Next level"
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			self.myView.subviews.forEach({ $0.removeFromSuperview() })
			self.myView.removeFromSuperview()
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.title = "MazeGame"
		}
		
		UIView.animate(withDuration: 0.25) { () -> Void in
			self.myView.alpha = 0.0
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.mySize = self.mySize + 2
			
			self.maze = Maze(width: self.mySize, height: self.mySize)
			
			self.setUpMaze()
			UIView.animate(withDuration: 0.25) { () -> Void in
				self.myView.alpha = 1.0
			}
		}
	}
	
	@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
		if let swipeGesture = gesture as? UISwipeGestureRecognizer {
			
			var myArr = [[Int]]()
			
			for row in maze.data {
				var mass : [Int] = []
				for cell in row {
					if cell == Maze.Cell.Space {
						mass.append(0)
					} else {
						mass.append(1)
					}
				}
				myArr.append(mass)
				mass = []
			}
			myArr[Int(redBall.frame.origin.y/CGFloat(myW))][Int(redBall.frame.origin.x/CGFloat(myW))] = 2
			myArr[Int(bluewBall.frame.origin.y/CGFloat(myW))][Int(bluewBall.frame.origin.x/CGFloat(myW))] = 3
			print(myArr)
			
			var moved = 0
			
			switch swipeGesture.direction {
			case UISwipeGestureRecognizerDirection.right:
				print("Swiped right")
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 2 {
							var k = 1
							while myArr[i][j+k] == 0 {
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.redBall.frame = CGRect(x: Int(self.redBall.frame.origin.x) + moved, y: Int(self.redBall.frame.origin.y), width: self.myW, height: self.myW)
				}, completion: nil)
				
				moved = 0
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 3 {
							var k = 1
							while myArr[i][j+k] == 0 {
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.bluewBall.frame = CGRect(x: Int(self.bluewBall.frame.origin.x) + moved, y: Int(self.bluewBall.frame.origin.y), width: self.myW, height: self.myW)
				}, completion: nil)
				
			case UISwipeGestureRecognizerDirection.down:
				print("Swiped down")
				
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 2 {
							var k = 1
							if i == mySize-2{
								k = 0
								break
							}
							while myArr[i+k][j] == 0 && i + k != mySize-1 {
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.redBall.frame = CGRect(x: Int(self.redBall.frame.origin.x), y: Int(self.redBall.frame.origin.y) + moved, width: self.myW, height: self.myW)
				}, completion: nil)
				
				moved = 0
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 3 {
							var k = 1
							while myArr[i+k][j] == 0 && i + k != mySize-1 {
								if i == mySize-2{
									k = 0
									break
								}
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.bluewBall.frame = CGRect(x: Int(self.bluewBall.frame.origin.x), y: Int(self.bluewBall.frame.origin.y) + moved, width: self.myW, height: self.myW)
				}, completion: nil)
				
				
			case UISwipeGestureRecognizerDirection.left:
				print("Swiped left")
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 2 {
							var k = 1
							while myArr[i][j-k] == 0 {
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.redBall.frame = CGRect(x: Int(self.redBall.frame.origin.x) - moved, y: Int(self.redBall.frame.origin.y), width: self.myW, height: self.myW)
				}, completion: nil)
				
				moved = 0
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 3 {
							var k = 1
							while myArr[i][j-k] == 0 {
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.bluewBall.frame = CGRect(x: Int(self.bluewBall.frame.origin.x) - moved, y: Int(self.bluewBall.frame.origin.y), width: self.myW, height: self.myW)
				}, completion: nil)
				
			case UISwipeGestureRecognizerDirection.up:
				print("Swiped up")
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 2 {
							var k = 1
							while myArr[i-k][j] == 0 && i-k != 0 {
								if i == 1{
									k = 0
									break
								}
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.redBall.frame = CGRect(x: Int(self.redBall.frame.origin.x), y: Int(self.redBall.frame.origin.y) - moved, width: self.myW, height: self.myW)
				}, completion: nil)
				
				moved = 0
				for i in 1...mySize-1 {
					for j in 1...mySize-1 {
						if myArr[i][j] == 3 {
							var k = 1
							while myArr[i-k][j] == 0 {
								if i == 2{
									k = 0
									break
								}
								k+=1
								moved+=myW
							}
							break
						}
					}
				}
				UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
					//Set x position what ever you want
					self.bluewBall.frame = CGRect(x: Int(self.bluewBall.frame.origin.x), y: Int(self.bluewBall.frame.origin.y) - moved, width: self.myW, height: self.myW)
				}, completion: nil)
				
			default:
				break
			}
			checkWin()
		}
	}
	
	var myX = 0
	var myY = 0
	var myW = 0
	var mySize = 9
	
	var maze = Maze(width: 9, height: 9)
	
	var myView = UIView()
	
	let redBall = UIView()
	let bluewBall = UIView()
	
	func setUpMaze() {
		myView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
		myView.backgroundColor = UIColor.clear
		self.view.addSubview(myView)
		
		
		myX = 0
		myY = 0
		myW = Int(myView.frame.size.width/CGFloat(mySize))
		
		for row in maze.data {
			for cell in row {
				if cell == Maze.Cell.Space {
					print("  ", separator: "", terminator: "")
					let block = UIView()
					block.backgroundColor = UIColor.clear
					block.frame = CGRect(x: myX, y: myY, width: myW, height: myW)
					myView.addSubview(block)
					myX = myX + myW
				} else {
					print("[]", separator: "", terminator: "")
					let block = UIView()
					block.backgroundColor = UIColor.white
					block.frame = CGRect(x: myX, y: myY, width: myW, height: myW)
					myView.addSubview(block)
					myX = myX + myW
				}
			}
			print("")
			myY = myY + myW
			myX = 0
		}
		myView.frame = CGRect(x: Int((UIScreen.main.bounds.width-CGFloat(myY))/2), y: 0, width: myY, height: myY)
		
		redBall.frame = CGRect(x: myW*2, y: myW, width: myW, height: myW)
		redBall.backgroundColor = UIColor(red: 255 / 255.0, green: 72 / 255.0, blue: 95 / 255.0, alpha: 1)
		redBall.layer.cornerRadius = CGFloat(myW/2)
		myView.addSubview(redBall)
		
		bluewBall.frame = CGRect(x: myY-myW*3, y: myY-myW*2, width: myW, height: myW)
		bluewBall.backgroundColor = UIColor(red: 46 / 255.0, green: 204 / 255.0, blue: 113 / 255.0, alpha: 1)
		bluewBall.layer.cornerRadius = CGFloat(myW/2)
		myView.addSubview(bluewBall)

	}
	
	@IBAction func RestartBtn(_ sender: Any) {
		let blurEffect = UIBlurEffect(style: .light)
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.frame = CGRect(x: 0, y: 0, width: 1080, height: 2000)
		
		visualEffectView.alpha = 0.0
		view.addSubview(visualEffectView)
		
		UIView.animate(withDuration: 0.25) { () -> Void in
			visualEffectView.alpha = 1.0
		}
		
		self.title = "🤔"
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		
		alertController.view.layer.cornerRadius = 30
		
		alertController.view.tintColor = UIColor(red: 74.0/255, green: 82.0/255, blue: 102.0/255, alpha: 1.0)
		alertController.addAction(UIAlertAction(title: "Restart game", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
			UIView.animate(withDuration: 0.25) { () -> Void in
				visualEffectView.alpha = 0.0
			}
			
			self.title = "Restarted"
			self.myView.subviews.forEach({ $0.removeFromSuperview() })
			self.myView.removeFromSuperview()
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.title = "MazeGame"
			}
			self.mySize = 9
			self.maze = Maze(width: self.mySize, height: self.mySize)
			self.setUpMaze()
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				visualEffectView.removeFromSuperview()
			}}))
		alertController.addAction(UIAlertAction(title: "Restart level", style: .default, handler: {(_ action: UIAlertAction) -> Void in
			UIView.animate(withDuration: 0.25) { () -> Void in
				visualEffectView.alpha = 0.0
			}
			self.title = "Restarted"
			self.myView.subviews.forEach({ $0.removeFromSuperview() })
			self.myView.removeFromSuperview()
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				self.title = "MazeGame"
			}
			self.maze = Maze(width: self.mySize, height: self.mySize)
			self.setUpMaze()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				visualEffectView.removeFromSuperview()
			}}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
			UIView.animate(withDuration: 0.25) { () -> Void in
				visualEffectView.alpha = 0.0
			}
			self.title = "MazeGame"
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				visualEffectView.removeFromSuperview()
			}}))
		present(alertController, animated: true, completion: nil)
		
	}
	
	@IBAction func InfoBtn(_ sender: Any) {
		let blurEffect = UIBlurEffect(style: .light)
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.frame = CGRect(x: 0, y: 0, width: 1080, height: 2000)
		
		visualEffectView.alpha = 0.0
		view.addSubview(visualEffectView)
		
		UIView.animate(withDuration: 0.25) { () -> Void in
			visualEffectView.alpha = 1.0
		}
		
		self.title = "🙂"
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		alertController.view.layer.cornerRadius = 30
		
		alertController.view.tintColor = UIColor(red: 74.0/255, green: 82.0/255, blue: 102.0/255, alpha: 1.0)
		alertController.addAction(UIAlertAction(title: "How to play?", style: .default, handler: {(_ action: UIAlertAction) -> Void in
			UIView.animate(withDuration: 0.25) { () -> Void in
				visualEffectView.alpha = 0.0
			}
			
			self.title = "MazeGame"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				visualEffectView.removeFromSuperview()
			}}))
		alertController.addAction(UIAlertAction(title: "Follow my Instagram", style: .default, handler: {(_ action: UIAlertAction) -> Void in
			UIView.animate(withDuration: 0.25) { () -> Void in
				visualEffectView.alpha = 0.0
			}
			
			let Username =  "maratkharr"
			let appURL = NSURL(string: "instagram://user?username=\(Username)")!
			let webURL = NSURL(string: "https://instagram.com/\(Username)")!
			let application = UIApplication.shared
			
			if application.canOpenURL(appURL as URL) {
				application.open(appURL as URL)
			} else {
				application.open(webURL as URL)
			}
			self.title = "MazeGame"
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				visualEffectView.removeFromSuperview()
			}}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
			UIView.animate(withDuration: 0.25) { () -> Void in
				visualEffectView.alpha = 0.0
			}
			self.title = "MazeGame"
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				visualEffectView.removeFromSuperview()
			}}))
		present(alertController, animated: true, completion: nil)
	}
	
}

