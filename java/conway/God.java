package conway;

public class God {

    private final World world;

    public God() {
        world = new World();
    }

    public void letThereBeLife() {
        world.makeLife(1, 1);
        world.makeLife(1, 2);
        world.makeLife(1, 3);
    }

    public void tourTheWorld() {
        world.visit(new WorldVisitor());
    }

    public void passJudgement() {
        world.commandCellsToMeetTheirNeighbours();
        world.cellsMustDie();
        world.cellsMustBeBorn();
        world.theWorldRevolves();
    }

    public static void main(String[] args) {
        God god = new God();
        god.letThereBeLife();

        for(int i=0; i < 5; i ++) {
            god.tourTheWorld();
            god.passJudgement();
            System.out.println();
        }
    }
}
