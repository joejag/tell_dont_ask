package conway;

public interface LifeListener {
    void call();


    LifeListener NOOP = new LifeListener() {
        public void call() {
        }
    };
}
