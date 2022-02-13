/*
Array(int size); — Array a1(3) // 0 0 0
Array(int size, int val); — Array a2(2, 1) // 1 1
Length(); — a1.Length() // 3
At(int n); — a2.at(1) = 4 // 1 4; a2.at(0); // 1
Fill(int val); — a1.fill(5) // 5 5 5
FilterOdd(); — a2.FilterOdd()
FilterMultipleOfFour() — a2.FilterMultipleOfFour()
Add(Array) — a1.Add(a2) // 1 1 0; a2.Add(a1) // 1 1
Print(Stream)
Read(Stream)
*/

// array.h

#ifndef ARRAY_H
#define ARRAY_H

class Array {
	const int size_;
	int* data_;
	public:
  // Array(int size);
  Array(int size, int val = 0);
  Array(const Array &other);
  ~Array();

  int& At(int n) { return data_[n]; }
  const int& At(int n) const { return data_[n]; }

  int Length() const { return size_; }
  void Print(std::ostream& = std::cout) const;

  // friend std::ostream& operator<<(std::ostream&, const Array&); // varianta 1
};

std::ostream& operator<<(std::ostream&, const Array&); // varianta 2

#endif

// array.cpp

#include "array.h"

/*
Array::Array(int size) : size_(size) {
	if (size <= 0) {
  	data_ = NULL;
  } else {
  	data_ = new int[size_];
    for (int i = 0; i < size_; i++) {
    	data_[i] = 0;
    }
  }
}
 */

Array::Array(int size, int val) : size_(size) {
	if (size_ <= 0) {
  	data_ = NULL;
  } else {
  	data_ = new int[size_];
    for (int i = 0; i < size_; i++) {
    	data_[i] = val;
    }
  }
}

Array::Array(const Array& other) : size_(other.size_) {
	if (size_ 	<= 0) {
  	data_ = NULL;
  } else {
  	data_ = new int[size_];
    for (int i = 0; i < size_; i++) {
    	data_[i] = other.data_[i];
    }
  }
}

Array::~Array() {
	if (data_ != NULL) {
  	delete[] data_;
  }
}

void Array::Print(std::ostream& out) const {
	for (int i = 0; i < size_; i++) {
  	out << data_[i] << " ";
  }
}

std::ostream& operator<<(std::ostream& out, const Array& arr) {
	for (int i = 0; i < arr.Length(); i++) {
  	out << arr.At(i) << " ";
  }

  // sau numai
  // arr.Print(out);

  return out;
}

// main.cpp

// using namespace std;

void PrintArray(const Array &arr) {
	cout << "(" << arr << ")" << endl;
  // cout << arr.Length(); // operator<<(std::cout, arr.Length())
  // cout << "dimensiunea este " << arr.Length() // operator<<(operator<<(std::cout, "dimensiunea este "), arr.Length())
}

int main() {
	int array_classic[3] = { 1, 2, 3 };

  /*
  {
  	Array array2(2);
    // lucrez cu array
  }
   */

  /*
  Array* array = new Array(3);
  // lucrez cu array
  delete array;
   */

  Array arr1(3, 2);
  PrintArray(arr1); // 2 2 2
  arr1.Print(); // 2 2 2

  Array arr2(2);
  arr2.Print(); // 0 0

  // array.At(1) = 5;
  // cout << array.At(1); // 5
  // array[0] = 1;
  // array[1] = 2;
  // array[2] = 3;
}
