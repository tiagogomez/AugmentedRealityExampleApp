//
//  ViewController.swift
//  AugmentedRealityExampleApp
//
//  Created by Santiago Gómez Giraldo - Ceiba Software on 3/08/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var modelChair: SCNNode?
    var modelTV: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        guard let chairScene = SCNScene(named: "art.scnassets/chair_swan.scn") else { return }
        self.modelChair = chairScene.rootNode.childNodes.first
        
        guard let tvScene = SCNScene(named: "art.scnassets/tv_retro.scn") else { return }
        self.modelTV = tvScene.rootNode.childNodes.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        guard let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "ARResources", bundle: Bundle.main) else { return }
        configuration.detectionImages = imageToTrack
        configuration.maximumNumberOfTrackedImages = 2
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        
        var modelNode: SCNNode
        switch imageAnchor.referenceImage.name {
        case "chair":
            modelNode = self.modelChair ?? SCNNode()
        case "table":
            modelNode = self.modelTV ?? SCNNode()
        default:
            modelNode = SCNNode()
        }
        
        modelNode.eulerAngles.x = .pi/2
        planeNode.addChildNode(modelNode)
        
        node.addChildNode(planeNode)
        return node
    }
}
