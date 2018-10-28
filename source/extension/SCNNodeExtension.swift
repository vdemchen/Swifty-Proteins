import SceneKit

func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
    let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
    if length == 0 {
        return SCNVector3(0.0, 0.0, 0.0)
    }
    
    return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
    
}

extension SCNNode {
    
    func connectBetweenTwoNodes(from startPoint: SCNNode, to endPoint: SCNNode) -> SCNNode {
        
        let radius: CGFloat = 0.2
        let color: UIColor = UIColor.darkGray
        
        let w = SCNVector3(
            endPoint.position.x - startPoint.position.x,
            endPoint.position.y - startPoint.position.y,
            endPoint.position.z - startPoint.position.z
        )
        let length = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
        if length == 0.0 {
            let sphere = SCNSphere(radius: radius)
            sphere.firstMaterial?.diffuse.contents = color
            self.geometry = sphere
            self.position = startPoint.position
            return self
        }
        
        let cylinder = SCNCylinder(radius: radius, height: length)
        cylinder.firstMaterial?.diffuse.contents = color
        self.geometry = cylinder
        
        let ov = SCNVector3(0, length/2.0, 0)
        let nv = SCNVector3((endPoint.position.x - startPoint.position.x)/2.0, (endPoint.position.y - startPoint.position.y)/2.0,
                            (endPoint.position.z-startPoint.position.z)/2.0)
        
        // axis between two vector
        let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
        
        //normalized axis vector
        let av_normalized = normalizeVector(av)
        let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
        let q1 = Float(av_normalized.x) // x' * sin(angle/2)
        let q2 = Float(av_normalized.y) // y' * sin(angle/2)
        let q3 = Float(av_normalized.z) // z' * sin(angle/2)
        
        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
        
        self.transform.m11 = r_m11
        self.transform.m12 = r_m12
        self.transform.m13 = r_m13
        self.transform.m14 = 0.0
        
        self.transform.m21 = r_m21
        self.transform.m22 = r_m22
        self.transform.m23 = r_m23
        self.transform.m24 = 0.0
        
        self.transform.m31 = r_m31
        self.transform.m32 = r_m32
        self.transform.m33 = r_m33
        self.transform.m34 = 0.0
        
        self.transform.m41 = (startPoint.position.x + endPoint.position.x) / 2.0
        self.transform.m42 = (startPoint.position.y + endPoint.position.y) / 2.0
        self.transform.m43 = (startPoint.position.z + endPoint.position.z) / 2.0
        self.transform.m44 = 1.0
        
        return self
    }
}

