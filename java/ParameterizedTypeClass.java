import org.junit.jupiter.api.Test;

public class ParameterizedTypeClass {
    @Test
    // define type when new objects
    public void test1(){
        GenericClass<String, Integer, Double> g1 = new GenericClass<>("heloo",123, 4.5);
        System.out.println(g1);

    }

    @Test
    // class extends generic class
    public void test2(){
        Class2 cl = new Class2(1,2,3);
        System.out.println(cl);
    }

}
class GenericClass<T1,T2,T3> {
    T1 t1;
    T2 t2;
    T3 t3;

    public GenericClass(T1 t1, T2 t2, T3 t3) {
        this.t1 = t1;
        this.t2 = t2;
        this.t3 = t3;
    }

    public void Order(){
        // directly use array cannot pass compiling
//        T1[] arr = new T1[10];
        T1[] arr = (T1[]) new Object[10];
    }

    @Override
    public String toString() {
        return "GenericClass{" +
                "t1=" + t1 +
                ", t2=" + t2 +
                ", t3=" + t3 +
                '}';
    }

    // cannot refered from a static method, static method is created before making new objects
//    public void static show(T1 t1){
//        System.out.println(t1);
//    }

    // cannot use in try catch as exception
//    public void show(){
//        try {
//
//        }catch (T t){
//
//        }
//    }

}

class Class2 extends GenericClass<Integer,Integer,Integer>{


    public Class2(Integer integer, Integer integer2, Integer integer3) {
        super(integer, integer2, integer3);
    }
}
// can not extends Exception
//class MyException<T> extends Exception{
//
//}

/////////////////////////////////////

class B<T1,T2>{}
// clean types
class S1 extends B{}        // equals class S1 extends B<Object, Object> {}
// specific types
class S2 extends B<Integer, String>{}
// keep types
class S3<T1,T2> extends B<T1,T2>{}
// keep partial
class S4<T2> extends B<Integer,T2>{}

// extra information
class S5<T1,T2,T3,T4> extends B<T1,T2>{}
