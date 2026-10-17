import com.foodapp.dao.FoodItemDAO;
import com.foodapp.model.FoodItem;
import java.util.List;
public class TestDAO {
    public static void main(String[] args) {
        FoodItemDAO dao = new FoodItemDAO();
        List<FoodItem> items = dao.getFoodItems("4", null, null, null);
        System.out.println("Items found: " + items.size());
    }
}