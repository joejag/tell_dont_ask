package conway;


import java.util.List;
import java.util.Map;

import static java.util.Arrays.asList;

public class World {

    public static final int START_CELL = 0;
    public static final int FINISH_CELL = 4;

    private Map<List<Integer>, Cell> liveCells;
    private Map<List<Integer>, Cell> nextGeneration;

    public World() {
        liveCells = new HashMapWithDefault<>(DeadCell.class);
        nextGeneration = new HashMapWithDefault<>(DeadCell.class);
    }

    public void makeLife(int x, int y) {
        makeLiveCell(liveCells, x, y);
    }

    private void makeLiveCell(Map<List<Integer>, Cell> coll, int x, int y) {
        coll.put(asList(x, y), new LiveCell(lifeListener(x, y)));
    }

    private LifeListener lifeListener(final int x, final int y) {
        return new LifeListener() {
            public void call() {
                reportLife(x, y);
            }
        };
    }

    private void reportLife(int x, int y) {
        makeLiveCell(nextGeneration, x, y);
    }

    public void commandCellsToMeetTheirNeighbours() {
        for (List<Integer> cords : liveCells.keySet()) {
            int x = cords.get(0);
            int y = cords.get(1);
            Cell cell = liveCells.get(cords);

            informNeighbourOfPresence(x, y, cell);
        }
    }

    private void informNeighbourOfPresence(int x, int y, Cell cell) {
        List<List<Integer>> neighbourCords = asList(
                asList(x - 1, y + 1), asList(x, y + 1), asList(x + 1, y + 1),
                asList(x - 1, y),   /* The middle */    asList(x + 1, y),
                asList(x - 1, y - 1), asList(x, y - 1), asList(x + 1, y - 1)
        );

        for (List<Integer> neighbourCord : neighbourCords) {
            liveCells.get(neighbourCord).informNeighbour(cell);
        }
    }

    public void cellsMustDie() {
        for (Cell cell : liveCells.values()) {
            cell.decideFate();
        }
    }

    public void cellsMustBeBorn() {
        for(int y=START_CELL; y < FINISH_CELL; y++) {
            for(int x=START_CELL; x < FINISH_CELL; x++) {
                DeadCell cell = new DeadCell(lifeListener(x, y));
                informNeighbourOfPresence(x, y, cell);
                cell.decideFate();
            }
        }
    }

    public void theWorldRevolves() {
       liveCells = nextGeneration;
       nextGeneration = new HashMapWithDefault<>(DeadCell.class);
    }

    public void visit(WorldVisitor visitor) {
        for(int y=START_CELL; y < FINISH_CELL; y++) {
            visitor.freshRow();
            for(int x=START_CELL; x < FINISH_CELL; x++) {
                liveCells.get(asList(x, y)).visit(visitor);
            }
        }
    }
}
