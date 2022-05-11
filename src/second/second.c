#include <stdio.h>
#include "../../include/first.h"

extern void first();

void second()
{
	first();
}
