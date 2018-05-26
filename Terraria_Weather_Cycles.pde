int minX = 0;
int maxX = 40;
int minY = 0;
int maxY = 16;
int scale = 25;

int[] columnHeights = new int[maxX];
boolean[] hasTreeList = new boolean[maxX];
RainDrop[] drops = new RainDrop[75];
ArrayList<Block> blocks = new ArrayList<Block>();

String[] potentialWeatherStates = new String[2];

String weather = "clear";

int numWeatherSwitches = 0;

void setup()
{
  potentialWeatherStates[0] = "clear";
  potentialWeatherStates[1] = "rainy";
  noStroke();
  background(200, 252, 255);
  size(1000, 1000);
  translate(0,height-1);
  scale(0, -1);
  for(int i = minX; i < maxX; i++)
  {
    int columnHeight = (int)random(10, 15);
    columnHeights[i] = columnHeight;
    for(int j = minY; j < columnHeight - minY; j++)
    {
      if(j == columnHeight - minY - 1)
      {
        Block block = new Block(i * scale, j * scale, scale, "grass");
        blocks.add(block);
       //System.out.println("J = " + j + " columnHeight = " + columnHeight + " placing grass");
      }
      else
      {
        Block block = new Block(i * scale, j * scale, scale, "dirt");
        blocks.add(block);
       // DrawDirt(i * scale, j * scale);
      }
    }
  }
  
  for(int k = 0; k < maxX; k++)
  {
   if(random(0, 10) < 3)
   {
     InstantiateTree(k);
   }
  }
  
  for(int x = 0; x < drops.length; x++)
  {
    //int dropY = Math.round((int)random(0, width));
    //if(dropY * scale > width)
    //{
    //  dropY -= 1;
    //}
    RainDrop currentDrop = new RainDrop((int)(random(0, maxX) * scale), 0, 1, false);
    drops[x] = currentDrop;
  }
}

void draw()
{
  if(millis() >= (float)numWeatherSwitches * 10000f)
  {
    weather = potentialWeatherStates[(int(random(0, potentialWeatherStates.length)))];
    numWeatherSwitches++;
  }
  background(200, 252, 255);
  //rotate(PI / 3.0);
  textSize(20);
  text(millis(), width - 100, 100);
  text("Weather: " + weather, width - 150, 125);
  text(numWeatherSwitches * 10000, width - 150, 150);
  
  for(RainDrop drop : drops)
  {
    if(weather == "rainy")
    {
      drop.SetActive(true);
    }
    drop.SetCoords(drop.GetX(), drop.GetY() + 15);
    if(drop.GetY() > columnHeights[drop.GetX() / scale] * scale * 2.5)
    {
      drop.SetCoords((int)random(0, width), 0);
      if(weather != "rainy")
      {
        drop.SetActive(false);
      }
    }
    if(drop.IsActive())
    {
      drop.Display();
    }
  }
  for(Block block : blocks)
  {
    block.Display();
  }
}

void DrawDirt(int x, int y)
{
  fill(124, 79, 35);
  rect(x, y, scale, scale);
}
void DrawGrass(int x, int y)
{
  fill(124, 79, 35);
  rect(x, y, scale, scale);
  fill(20, 216, 50);
  rect(x, y - (scale/3) + (scale/3), scale, scale / 3);
}
void InstantiateTree(int x)
{
  int treeHeight = (int)random(3, 5);
  for(int i = columnHeights[x]; i < columnHeights[x] + treeHeight; i++)
  {
    //DrawWood(x * scale, i * scale);
    Block block = new Block(x * scale, i * scale, scale, "wood");
    blocks.add(block);
  }
  for(int j = x - 2; j < x + 3; j++)
  {
    //DrawLeaf(j * scale, (columnHeights[x] + treeHeight) * scale);
    Block block = new Block(j * scale, (columnHeights[x] + treeHeight) * scale, scale, "leaf");
    blocks.add(block);
    //System.out.println("Placing leaf at " + j + ", " + (columnHeights[x] + treeHeight + 1));
  }
  for(int k = x - 1; k < x + 2; k++)
  {
    //DrawLeaf(k * scale, (columnHeights[x] + treeHeight + 1) * scale);
    Block block = new Block(k * scale, (columnHeights[x] + treeHeight + 1) * scale, scale, "leaf");
    blocks.add(block);
  }
}
void DrawWood(int x, int y)
{
  fill(121, 81, 16);
  rect(x, y, scale, scale);
  fill(93, 62, 11);
  rect(x, y, scale / 5, scale);
  rect(x + 2*(scale / 5), y, scale / 5, scale);
  rect(x + 4*(scale / 5), y, scale / 5, scale);
}
void DrawLeaf(int x, int y)
{
  fill(71, 242, 95);
  rect(x, y, scale, scale);
}

class Block
{
  int x;
  int y;
  int scale;
  String type;
  Block(int x, int y, int scale, String type)
  {
    this.x = x;
    this.y = y;
    this.scale = scale;
    this.type = type;
  }
  
  void Display()
  {
    if(type == "dirt")
    {
      DrawDirt(x, height - y);
    }
    if(type == "grass")
    {
      DrawGrass(x, height - y);
    }
    if(type == "wood")
    {
      DrawWood(x, height - y);
    }
    if(type == "leaf")
    {
      DrawLeaf(x, height - y);
    }
  }
}

class RainDrop
{
  int x;
  int y;
  int scale;
  boolean active;
  RainDrop(int x, int y, int scale, boolean active)
  {
    this.x = x;
    this.y = y;
    this.scale = scale;
    this.active = active;
  }

  void SetCoords(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  int GetX()
  {
    return x;
  }
  
  int GetY()
  {
    return y;
  }
  boolean IsActive()
  {
   return active; 
  }
  void SetActive(boolean in)
  {
    this.active = in;
  }
  void Display()
  {
    fill(101, 124, 245);
    rect(x, y, 4 * scale, 15 * scale);
  }
}