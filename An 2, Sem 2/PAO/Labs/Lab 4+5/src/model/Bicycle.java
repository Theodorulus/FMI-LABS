package model;

import java.util.Objects;

public class Bicycle extends Vehicle {
    private int height;

    public Bicycle(long id, String name, double price, int stock, String model, boolean limitedEdition, int height) {
        super(id, name, price, stock, model, limitedEdition);
        this.height = height;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Bicycle bicycle = (Bicycle) o;
        return model.equals(bicycle.getModel());
    }

    @Override
    public int hashCode() {
        return Objects.hash(model);
    }

    @Override
    public String toString() {
        return "Bicycle{" +
                "height=" + height +
                ", id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", model='" + model + '\'' +
                ", limitedEdition=" + limitedEdition +
                '}';
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }
}
