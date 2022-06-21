import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

public class ParameterizedTypeMethod {
    @Test
    public void test(){
        G<String> g1 = new G<>();
        Integer[] arr = new Integer[]{1,2,3,4};
        List<Integer> list = g1.copyFromArrayToList(arr);
        System.out.println(list);

    }
}
// parameterized method refers methods having parameterizedTypeClass but not from it's class
// it does not matter if it's class it a parameterizedTypeClass
class G<T>{
    T t;
    public void show(T t){ // general method
        System.out.println(t);
    }
    <E> E show2(E e){       // parameterized method

        return e;
    }
    // parameterizedTypeMethod clamins parameterizedTypeClass when bing called
    public static <E> List<E> copyFromArrayToList(E[] arr){    // can be static
        ArrayList<E> list = new ArrayList<>();
        for(E e: arr){
            list.add(e);
        }
        return list;
    }
}