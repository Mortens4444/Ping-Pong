static final int width = 400;
static final int height = 300;

static final int directions = 5, halfOfDirections = directions / 2, minSpeed = 3;

Ball ball;
Racket leftRacket, rightRacket;
MovingHandler movingHandler;

void setup()
{
  size(400, 300); // Create canvas

  CreateBall();
  CreateRackets(30, 50);
  
  movingHandler = new MovingHandler();
}

void CreateBall()
{
  ball = new Ball();
}

void CreateRackets(int shiftOfX, int racketHeight)
{
  leftRacket = new Racket(shiftOfX, height / 2, racketHeight);
  rightRacket = new Racket(width - shiftOfX, height / 2, racketHeight);
}

void draw()
{
  clear();
  
  ball.Move();
  ball.Draw(102, 204, 102);  
  
  leftRacket.Draw(204, 102, 0);
  ball.CheckCollision(leftRacket);
  
  rightRacket.Draw(0, 102, 204);
  ball.CheckCollision(rightRacket);
}

class Ball
{
  float x, y, dx, dy;
  static final int diameter = 10, radius = diameter / 2;
  byte collisionDetection;

  Ball()
  {
    InitializeBallLocationAndSpeed();
  }
  
  void InitializeBallLocationAndSpeed()
  {
    this.x = width / 2;
    this.y = height / 2;
  
    dx = minSpeed + halfOfDirections - random(directions); 
    dy = minSpeed + halfOfDirections - random(directions);
  }
  
  void Draw(int redComponent, int greenComponent, int blueComponent)
  {
    strokeWeight(1);
    stroke(redComponent, greenComponent, blueComponent);
    fill(redComponent, greenComponent, blueComponent);
    ellipse(x, y, diameter, diameter);
  }
  
  void Move()
  {
    x += dx;
    y += dy;
    
    if (y - radius < 0 || y + radius > height)
    {
      dy *= -1; 
    }
    
    if (x < 0 || x > width)
    {
      if (x < 0)
      {
        rightRacket.points++;
      }
      else
      {
        leftRacket.points++;
      }
      InitializeBallLocationAndSpeed();
    }
  }
  
  void CheckCollision(Racket racket)
  {
    float xDistance = x - racket.x;

    if (collisionDetection > 0)
    {
      collisionDetection--;
    }

    if (collisionDetection == 0 && (xDistance < 3 && xDistance > -3) && (y > racket.y - racket.halfOfHeight && y < racket.y + racket.halfOfHeight))
    {
      collisionDetection = 50;
      dx = dx > 0 ? -random(halfOfDirections) - minSpeed : random(halfOfDirections) + minSpeed;
      if (racket.moveUp)
      {
        dy = dy > 0 ?  -random(halfOfDirections) - minSpeed : random(halfOfDirections) + minSpeed;
      }
      else if (racket.moveDown)
      {
        dy = dy > 0 ?  random(halfOfDirections) + minSpeed : -random(halfOfDirections) - minSpeed;
      }
    }
  }
}

class Racket
{
  float x, y, halfOfHeight;
  static final int moveSpeed = 5;
  boolean moveUp, moveDown;
  int points;
  
  Racket(float x, float y, float height)
  {
    this.x = x;
    this.y = y;
    this.halfOfHeight = height / 2;
    this.points = 0;
  }
  
  void Draw(int redComponent, int greenComponent, int blueComponent)
  {
    strokeWeight(5);
    stroke(redComponent, greenComponent, blueComponent);
    
    float top = y - halfOfHeight;
    float bottom = y + halfOfHeight;

    if (moveUp && top > 0)
    {
      y -= moveSpeed;
    }
    
    if (moveDown && bottom < height)
    {
      y += moveSpeed;
    }    

    line(x, top, x, bottom);
    
    text(points, x, 10);
  }
  
  void MoveUp()
  {
    moveUp = true;
  }

  void MoveDown()
  {
    moveDown = true;
  }

  void StopMoveUp()
  {
    moveUp = false;
  }

  void StopMoveDown()
  {
    moveDown = false;
  }
}

void keyPressed()
{
  movingHandler.HandleKeyPress();
}

void keyReleased()
{
  movingHandler.HandleKeyRelease();
}

class MovingHandler
{
  void HandleKeyPress()
  {
    switch (key)
    {
      case CODED:
        switch (keyCode)
        {
          case UP:
            rightRacket.MoveUp();
            break;
          case DOWN:
            rightRacket.MoveDown();
            break;
        }
        break;
      default:
        switch (keyCode)
        {
          case 'W':
            leftRacket.MoveUp();
            break;
          case 'S':
            leftRacket.MoveDown();
            break;
        }
        break;
    }
  }
  
  void HandleKeyRelease()
  {
    switch (key)
    {
      case CODED:
        switch (keyCode)
        {
          case UP:
            rightRacket.StopMoveUp();
            break;
          case DOWN:
            rightRacket.StopMoveDown();
            break;
        }
        break;
      default:
        switch (keyCode)
        {
          case 'W':
            leftRacket.StopMoveUp();
            break;
          case 'S':
            leftRacket.StopMoveDown();
            break;
        }
        break;
    }
  }
}