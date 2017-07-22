//
//  GameViewController.swift
//  3DCubeRotateToFaceCamera
//
//  Created by DSS on 22/07/17.
//  Copyright © 2017 DSS. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    
    var scnView:SCNView!
    var gamescn:SCNScene!
    var cube:SCNNode!
    var cameraNode:SCNNode!
    var rotationTimer:TimeInterval = 0
    let distancefromorigin:CGFloat = 10
    let snakewidth:CGFloat = 1
    var lastposition:SCNVector3 = SCNVector3()
    var movingTarget:SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView = view as! SCNView
        gamescn = SCNScene()
        scnView.scene = gamescn
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
        scnView.showsStatistics = true
        scnView.antialiasingMode = .multisampling2X
        scnView.preferredFramesPerSecond = 30
        scnView.delegate = self
        scnView.isPlaying = true
        
        let sphereGeometry = SCNBox(width: distancefromorigin*2, height: distancefromorigin*2, length: distancefromorigin*2, chamferRadius: 0)
        let boxmaterial1 = SCNMaterial()
        boxmaterial1.diffuse.contents =  #imageLiteral(resourceName: "graph1")
        let boxmaterial2 = SCNMaterial()
        boxmaterial2.diffuse.contents =  #imageLiteral(resourceName: "graph2")
        let boxmaterial3 = SCNMaterial()
        boxmaterial3.diffuse.contents =  #imageLiteral(resourceName: "graph3")
        let boxmaterial4 = SCNMaterial()
        boxmaterial4.diffuse.contents = #imageLiteral(resourceName: "graph4")
        let boxmaterial5 = SCNMaterial()
        boxmaterial5.diffuse.contents = #imageLiteral(resourceName: "graph5")
        let boxmaterial6 = SCNMaterial()
        boxmaterial6.diffuse.contents = #imageLiteral(resourceName: "graph6")
        sphereGeometry.materials = [boxmaterial1,boxmaterial2,boxmaterial4,boxmaterial5,boxmaterial3,boxmaterial6]
        
        cube = SCNNode(geometry: sphereGeometry)
        cube.position = SCNVector3Make(0.0, 0.0, 0.0)
        gamescn.rootNode.addChildNode(cube)
        
        
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 40)
        gamescn.rootNode.addChildNode(cameraNode)
        
        
        movingTarget = MakeMovingTarget()
        cube.addChildNode(movingTarget)
        
        //how we want to move
        deltaMove = SCNVector3.init(x: 1.0, y: 0.0, z: 0)
        lastposition = movingTarget.position
        
      
    }
    
    func MakeMovingTarget()->SCNNode{
        let shape = SCNBox(width: snakewidth, height: snakewidth, length: snakewidth, chamferRadius: 0.1)
        let shapematerial = SCNMaterial()
        shapematerial.diffuse.contents = UIColor.yellow
        shape.materials = [shapematerial,shapematerial,shapematerial,shapematerial,shapematerial,shapematerial]
        let body = SCNNode(geometry: shape)
        body.position = SCNVector3Make(0, 0,Float(distancefromorigin + snakewidth/2))
        return body
    }
    

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    var xDegree:Float = 0
    var yDegree:Float = 0
    var zDegree:Float = 0
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > rotationTimer{
            

            let angleCos = lastposition.angleBetweenVectorsCos(movingTarget.position)
            let angleSin = lastposition.angleBetweenVectorsSin(movingTarget.position)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            xDegree += angleSin
            yDegree += angleCos
            zDegree += 0
            
            if vMove {
                cube.eulerAngles.x =  xDegree
            }
            if hMove {
                cube.eulerAngles.y =  -yDegree
            }
            

            SCNTransaction.commit()
            lastposition = movingTarget.position
            
            if (deltaMove.x == 0) && (deltaMove.y == 0) && (deltaMove.z == 0) {
                print("Change the delta move - in ViewDidLoad")
            }else {
                updatePosition(snakehead: movingTarget)
            }
            
            rotationTimer = time + 0.2
        }
        
    }
    
    var vMove:Bool = false
    var hMove:Bool = false
    var deltaMove:SCNVector3 = SCNVector3()
    //these are the cube's 6 surface
    var xFixedMax:Bool = false
    var yFixedMax:Bool = false
    var zFixedMax:Bool = true // this this where I put the initial node
    var xFixedMin:Bool = false
    var yFixedMin:Bool = false
    var zFixedMin:Bool = false
    
    func MakeAllFalse() {
        xFixedMax = false
        yFixedMax = false
        zFixedMax = false
        xFixedMin = false
        yFixedMin = false
        zFixedMin = false
    }
    
    func updatePosition(snakehead:SCNNode){
        ///right
        var tmpmove: SCNVector3 = deltaMove
        
        hMove = true
        vMove = true
        
        //first update the position
        if zFixedMax{
            
        } else  if zFixedMin {
            tmpmove.x = -tmpmove.x
            tmpmove.y = -tmpmove.y
        } else if xFixedMax{
            tmpmove.z = -tmpmove.x
            tmpmove.x = 0
        } else  if xFixedMin {
            tmpmove.z = tmpmove.x
            tmpmove.x = 0
        } else if yFixedMax{
            tmpmove.z = -tmpmove.y
            tmpmove.y = 0
        }else if yFixedMin{
            //            tmpmove.x = -tmpmove.x
            tmpmove.z = tmpmove.y
            tmpmove.y = 0
        }
        
        if tmpmove.y == 0 {
            vMove = false
        }
        if tmpmove.x == 0 {
            hMove = false
        }
        
        snakehead.position.x += tmpmove.x
        snakehead.position.y += tmpmove.y
        snakehead.position.z += tmpmove.z
        
        
        if  (snakehead.position.z > Float(distancefromorigin + snakewidth/2)) {
            print("xFixedMin//max Z")
            snakehead.position.z = Float(distancefromorigin + snakewidth/2)
            MakeAllFalse()
            zFixedMax = true
            return
        }else if  (snakehead.position.z < Float(-distancefromorigin - snakewidth/2)) {
            print("xFixedMin//min Z")
            snakehead.position.z = Float(-distancefromorigin - snakewidth/2)
            MakeAllFalse()
            zFixedMin = true
        }
        
        
        if  (snakehead.position.y < Float(-distancefromorigin - snakewidth/2)){
            print("xFixedMax//min Y")
            snakehead.position.y = Float(-distancefromorigin - snakewidth/2)
            MakeAllFalse()
            yFixedMin = true
        }else  if  (snakehead.position.y > Float(distancefromorigin + snakewidth/2)){
            print("xFixedMax//max Y")
            snakehead.position.y = Float(distancefromorigin + snakewidth/2)
            MakeAllFalse()
            yFixedMax = true
        }
        
        if  (snakehead.position.x < Float(-distancefromorigin - snakewidth/2)) {
            print("zFixedMin//min X")
            snakehead.position.x = Float(-distancefromorigin - snakewidth/2)
            MakeAllFalse()
            xFixedMin = true
        }else if  (snakehead.position.x > Float(distancefromorigin + snakewidth/2)) {
            print("zFixedMin//max X")
            snakehead.position.x = Float(distancefromorigin + snakewidth/2)
            MakeAllFalse()
            xFixedMax = true
        }
        
        
    }
}
