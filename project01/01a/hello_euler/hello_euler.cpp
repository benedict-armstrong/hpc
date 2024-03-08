#include <iostream>
#include <unistd.h>

int main() {

  // print machine host name
  char hostname[256];
  gethostname(hostname, sizeof(hostname));
  std::cout << "Host name: " << hostname << std::endl;

  return 0;
}