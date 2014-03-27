package conway;

public class DeadCell extends Cell {

    public DeadCell() {
        super(LifeListener.NOOP);
    }

    public DeadCell(LifeListener lifeListener) {
        super(lifeListener);
    }

    protected boolean survives() {
        return neighbours.size() == 3;
    }

    public void informNeighbour(Cell neighbour) {
        // NOOP
    }

    public void visit(WorldVisitor visitor) {
        visitor.deadCell();
    }
}
