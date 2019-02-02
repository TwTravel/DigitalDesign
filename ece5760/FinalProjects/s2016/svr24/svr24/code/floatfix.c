#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
typedef signed long long fix36;

#define FRACTIONAL_BITS 33
#define MULT pow(2.0, FRACTIONAL_BITS)

#define float2fix36(a) ((fix36)((a)*MULT))
#define fix2float36(a) ((float)((a)/MULT))


int main(int argc, char** argv)
{
	if ((argc < 3) || (strcmp(argv[1], "fix") && strcmp(argv[1], "float"))  ) {
		printf("Usage: \n");
		printf("floatfix <direction> <value>\n");
		printf("Converts back and forth between float and 3.33 fixed point");
		printf("<direction>: The type of value you want output\n");
		printf("<value>: The value you want converted\n");
		printf("\te.g., floatfix fix -0.2 will output -0.2 in fixed point\n");
		printf("\te.g., floatfix float 0xe00000000 will output -2.0\n");
		return -1;
	}
	if (argv[1][2] == 'x') {
		float floatval = atof(argv[2]);
		printf("float input:\t%.8f\n", floatval);
		printf("fix output:\t%llx\n", (float2fix36(floatval) & 0x0000000fffffffff));
	} else {
		fix36 fixval = strtol(&argv[2][2], NULL, 16);
		printf("fix input:\t0x%llx\n", fixval);
		if (fixval & 0x800000000) fixval |= 0xfffffff000000000;
		printf("float output:\t%.8f\n", fix2float36(fixval));
	}
	return 0;
}
