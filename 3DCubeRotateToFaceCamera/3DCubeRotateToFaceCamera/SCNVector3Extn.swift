//
//  SCNVector3Extn.swift
//  3DCubeRotateToFaceCamera
//
//  Created by DSS on 22/07/17.
//  Copyright © 2017 DSS. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3
{
    
    var magnitude:SCNFloat {
        get {
            return sqrt(dot(vector: self))
        }
    }
    
   
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    
   
    func normalized() -> SCNVector3 {
        return self / length()
    }
    
    mutating func normalize() -> SCNVector3 {
        self = normalized()
        return self
    }
    

    func distance(vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    

    func dot(vector: SCNVector3) -> Float {
        return x * vector.x + y * vector.y + z * vector.z
    }
    

    func cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
    
    
    func angleBetweenVectorsCos(_ vectorB:SCNVector3) -> SCNFloat {
        let cosineAngle = (dot(vector: vectorB) / (magnitude * vectorB.magnitude))
        return SCNFloat(acos(cosineAngle))
    }
    
    func angleBetweenVectorsSin(_ vectorB:SCNVector3) -> SCNFloat {
        let cosineAngle = angleBetweenVectorsCos(vectorB)
        let sinangle = sqrt(1-cosineAngle*cosineAngle)
        return SCNFloat(acos(sinangle))
    }
}


func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}


func += ( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}


func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

func -= ( left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}


func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}


func *= ( left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}


func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}


func *= ( vector: inout SCNVector3, scalar: Float) {
    vector = vector * scalar
}


func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}


func /= ( left: inout SCNVector3, right: SCNVector3) {
    left = left / right
}


func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}


func /= ( vector: inout SCNVector3, scalar: Float) {
    vector = vector / scalar
}

