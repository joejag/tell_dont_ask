package conway;

public class WorldVisitor {

    public void freshRow() {
        System.out.println();
    }

    public void liveCell() {
        System.out.print('X');
    }

    public void deadCell() {
        System.out.print("_");
    }

}
