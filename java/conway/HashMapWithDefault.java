package conway;

import java.util.HashMap;

public class HashMapWithDefault<K, V> extends HashMap<K, V> {

    private Class missingObjectType;

    public HashMapWithDefault(Class missingObjectType) {
        this.missingObjectType = missingObjectType;
    }

    @Override
    public V get(Object key) {
        if (containsKey(key)) return super.get(key);
        return newInstanceOfMissingObject();
    }

    private V newInstanceOfMissingObject() {
        try {
            return (V) missingObjectType.newInstance();
        } catch (InstantiationException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }
}
