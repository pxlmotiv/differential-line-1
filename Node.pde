class Node {
  PVector position;
  float repelThreshold, minDistanceToNeighbor;
  int id;
  Node neighbor1, neighbor2;

  Node(float x, float y, int _id, float _repelThreshold, float _minDistanceToNeighbor) {
    position = new PVector(x, y);
    id = _id;
    repelThreshold = _repelThreshold;
    minDistanceToNeighbor = _minDistanceToNeighbor;
  }

  void closeDistanceToNeighbor() {    
    float d1 = dist(position.x, position.y, neighbor1.position.x, neighbor1.position.y);
    float d2 = dist(position.x, position.y, neighbor2.position.x, neighbor2.position.y);

    if (d1 > d2) {
      PVector v = PVector.sub(neighbor1.position, position);
      v.normalize();
      position.add(v);
    } else if (d2 > d1) {
      PVector v = PVector.sub(neighbor2.position, position);
      v.normalize();
      position.add(v);
    }
  }

  void getAwayFromOthers(ArrayList<Node> nodes) {
    PVector v = new PVector(0, 0);
    for (int i = 0; i < nodes.size(); i++) {
      Node other = nodes.get(i);
      float d = dist(position.x, position.y, other.position.x, other.position.y);
      if (d < repelThreshold) {
        PVector a = PVector.sub(position, other.position);
        a.normalize();
        v.add(a);
      }
    }
    v.normalize();
    position.add(v);
  }

  void draw() {
    noStroke();
    fill(20, 100);
    ellipse(position.x, position.y, 2, 2);
  }
}