package conway;

public class LiveCell extends Cell {

    private LifeListener listener;

    public LiveCell(LifeListener listener) {
        super(listener);
    }

    protected boolean survives() {
        return neighbours.size() == 2 || neighbours.size() == 3;
    }

    public void informNeighbour(Cell neighbour) {
        neighbour.addNeighbour(this);
    }

    public void visit(WorldVisitor visitor) {
        visitor.liveCell();
    }
}
