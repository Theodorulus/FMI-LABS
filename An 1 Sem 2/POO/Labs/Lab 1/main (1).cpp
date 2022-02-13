#include <iostream>

using namespace std;


class rectangle
{
    int width;
    int height;
public:
    rectangle()
    {
        width = height = 0;
    }
    rectangle(int w, int h)
    {
        width = w;
        height = h;
    }
    int get_height()
    {
        return height;
    }
    void set_height(int h)
    {
        height = h;
    }
    int get_width()
    {
        return width;
    }
    void set_width(int w)
    {
        width = w;
    }
    void print_rect()
    {
        cout << "Inaltime: " << height <<", Latime: " << width << endl;
    }
    void rotate()
    {
        int aux = height;
        height = width;
        width = aux;
    }
    int area()
    {
        return width * height;
    }

    // returns -1 when this < other, 0 when =, 1 when >

    int compare(rectangle other)
    {
        int area1 = width * height;
        int area2 = other.area();
        if (area1 > area2)
            return 1;
        else
            if (area1 == area2)
                return 0;
            else
                return -1;
    }
};

class ScoreCalculator
{

    int n;
    int v[101];
public:
    ScoreCalculator()
    {
        n = 0;
    }
    void Read(int x)
    {
        if (n == 0)
        {
            n = x;
            for (int i = 0; i < x; i++)
                cin >> v[i];
        }
        else
        {
            for (int i = n; i < n + x; i++)
                cin>>v[i];
            n += x;
        }
    }
    int Total()
    {
        int s = 0;
        for (int i = 0; i < n; i++)
            s += v[i];
        return s;
    }
};
/* SAU
class ScoreCalculator() {
	public:
    	void Read(int num) {
        	int x;
            for (int i = num; i > 0; i--) {
            	cin >> x;
                total_ += x;
            }
        }

        int Total() {
        	return total_;
        }
	private:
    	int total_;

};
*/
int main()
{
    ScoreCalculator sc;
    sc.Read(3); // 1 2 7
    cout << sc.Total(); // 10
    sc.Read(2); // 6 3
    cout << sc.Total(); // 19
    return 0;
}
