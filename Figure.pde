class Figure { //<>// //<>//
  ArrayList<Node> nodes;
  float w, h, x, y;
  int amountOfNodes, lastId, lastInsertionFrame, insertionCount;

  Figure(float _x, float _y, float _w, float _h, int _amountOfNodes) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    amountOfNodes = _amountOfNodes;
    lastId = -1;
    lastInsertionFrame = -1;
    insertionCount = 0;
    nodes = new ArrayList<Node>();
    generateInCircle();
  }

  void generateInCircle() {
    int id = 0;
    for (float i = 0; i < TWO_PI; i += TWO_PI/amountOfNodes) {
      float a = i + random(-PI/15, PI/15);
      float px = w * cos(a) + x;
      float py = h * sin(a) + y;

      Node n = new Node(px, py, id, REPEL_DISTANCE, MIN_NEIGHBOR_DISTANCE);

      if (i > 0)
        n.neighbor1 = nodes.get(id - 1);
      if (lastId != -1 && i < amountOfNodes)
        nodes.get(lastId).neighbor2 = n;

      nodes.add(n);

      lastId = id;
      id++;
    }
    nodes.get(0).neighbor1 = nodes.get(lastId);
    nodes.get(lastId).neighbor2 = nodes.get(0);
  }

  void update() {
    introduceNewNodes();
    closeDistanceToNeighbor();
    getAwayFromOthers();
  }

  void introduceNewNodes() {
    if (frameCount < lastInsertionFrame + FRAMESKIP)return;
    insertionCount++;
    int ins = PROPORTIONAL_GROWTH ? round(INSERTAMOUNT * GROWTH_FACTOR * insertionCount) : INSERTAMOUNT;
    for (int iii = 0; iii < ins; iii++) {
      Node n = null, m = null;
      int s = nodes.size();

      boolean foundPair = false;
      int tries = 0;
      while (!foundPair && tries < 100) {
        tries++;
        int ri = round(random(0, s-1));

        n = nodes.get(ri);
        m = n.neighbor1;

        foundPair = (dist(n.position.x, n.position.y, m.position.x, m.position.y) > 4);
      }

      float nnx = (n.position.x + m.position.x)/2;
      float nny = (n.position.y + m.position.y)/2;

      lastId = lastId + 1;

      Node newNode = new Node(nnx, nny, lastId, REPEL_DISTANCE, MIN_NEIGHBOR_DISTANCE);
      nodes.get(m.id).neighbor2 = newNode;
      nodes.get(n.id).neighbor1 = newNode;
      newNode.neighbor1 = nodes.get(m.id);
      newNode.neighbor2 = nodes.get(n.id);
      nodes.add(newNode);
      lastInsertionFrame = frameCount;
    }
  }

  void closeDistanceToNeighbor() {
    for (int i = 0; i < nodes.size(); i++)
      nodes.get(i).closeDistanceToNeighbor();
  }

  void getAwayFromOthers() {
    for (int i = 0; i < nodes.size(); i++)
      nodes.get(i).getAwayFromOthers(nodes);
  }

  void draw() {
    int s = nodes.size();
    for (int i = 0; i < s; i++) {
      Node n = nodes.get(i);
      if (DRAWLINES) {
        Node m = n.neighbor1;
        stroke(20, 60);
        strokeWeight(1);
        noFill();
        line(n.position.x, n.position.y, m.position.x, m.position.y);
      }
      if (DRAWPOINTS) n.draw();
    }
  }

  void draw2() {
    stroke(121, 234, 232, 255);
    strokeWeight(3);
    noFill();
    curveDetail(8);
    curveTightness(0);
    
    int s = nodes.size();

    Node firstnode = nodes.get(0);
    Node secondnode = firstnode.neighbor2;
    Node lastnode = firstnode.neighbor1;

    int id = 0;
    int looops = 0;
    boolean reachedEnd = false;
    beginShape();
    curveVertex(lastnode.position.x, lastnode.position.y);
    while (!reachedEnd) {
      Node n = nodes.get(id);
      if (DRAWLINES) curveVertex(n.position.x, n.position.y);
      if (DRAWPOINTS) n.draw();
      id = n.neighbor2.id;
      looops++;
      reachedEnd = looops == s-1;
    }
    curveVertex(firstnode.position.x, firstnode.position.y);
    curveVertex(secondnode.position.x, secondnode.position.y);
    endShape(CLOSE);
  }
}