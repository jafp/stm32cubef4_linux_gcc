
class Foo {
public:
	Foo(int initial);
	virtual ~Foo();

	virtual void increment();
	unsigned int getCounter() const;

protected:
	unsigned int _counter;
};


