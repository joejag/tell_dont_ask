package conway;

import java.util.ArrayList;
import java.util.List;

public abstract class Cell {

    protected final List<Cell> neighbours = new ArrayList<Cell>();

    private LifeListener listener;

    public Cell(LifeListener listener) {
        this.listener = listener;
    }

    public void addNeighbour(Cell cell) {
        neighbours.add(cell);
    }

    public void decideFate() {
       if (survives()) {
           listener.call();
       }
    }

    public abstract void informNeighbour(Cell neighbour);
    public abstract void visit(WorldVisitor visitor);
    protected abstract boolean survives();
}
