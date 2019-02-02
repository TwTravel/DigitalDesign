#include <stdio.h>
#include <string.h>
#include "../../BSP/system.h"
int main()
{
	char* msg = "Detected the character 't'.\n";
	char* hello = "Hello\n";
	FILE* fp;
	char prompt = 0;
	fp = fopen (JTAG_UART_NAME,"r+");
	if (fp) {
		//fwrite(hello, strlen(hello),1,fp);
		fprintf(fp, hello);
		while (prompt != 'v') {
			prompt = getc(fp);
			if (prompt == 't') {
				fwrite (msg, strlen (msg),1,fp);
			}
			if (ferror(fp)) clearerr(fp);
		}
		fprintf(fp, "Closing the JTAG UART file handle.\n");
		fclose(fp);
	}
	return 0;
}