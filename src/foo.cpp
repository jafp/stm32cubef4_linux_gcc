
#include "foo.h"

Foo::Foo(int initial) : _counter(initial)
{	
}

Foo::~Foo() 
{
}

void Foo::increment()
{
	_counter++;
}

unsigned int Foo::getCounter() const
{
	return _counter;
}
