package model;

public class Car extends Vehicle { // Car IS A vehicle
    private String color;
    private Engine engine; // Car HAS AN engine

    public Car() {

    }

    public Car(long id, String name, double price, int stock, String model, boolean limitedEdition, String color, Engine engine) {
        super(id, name, price, stock, model, limitedEdition);
        this.color = color;
        this.engine = engine;
    }

    public static class Builder {
        private Car car = new Car();

        public Builder withName(String name) {
            car.setName(name);
            return this;
        }

        public Builder withPrice(double price) {
            car.setPrice(price);
            return this;
        }

        public Builder withStock(int stock) {
            car.setStock(stock);
            return this;
        }

        public Builder withModel(String model) {
            car.setModel(model);
            return this;
        }

        public Builder withLimitedEdition(boolean limitedEdition) {
            car.setLimitedEdition(limitedEdition);
            return this;
        }

        public Builder withColor(String color) {
            car.setColor(color);
            return this;
        }

        public Car build() {
            return this.car;
        }

    }


    @Override
    public String toString() {
        return "Car{" +
                "color='" + color + '\'' +
                ", engine=" + engine +
                ", id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", model='" + model + '\'' +
                ", limitedEdition=" + limitedEdition +
                '}';
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Engine getEngine() {
        return engine;
    }

    public void setEngine(Engine engine) {
        this.engine = engine;
    }
}
